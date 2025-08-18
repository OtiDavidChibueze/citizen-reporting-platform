import 'package:citizen_report_incident/features/incidents/data/model/incident_notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../../core/storage/app_storage_keys.dart';
import '../../dto/fetch_incident_by_category.dart';

import '../../../../../core/service/supabase_service.dart';
import '../../dto/upload_incident_img_dto.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../core/service/local_storage_service.dart';
import '../../model/incident_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class IncidentRemoteSource {
  Future<IncidentModel> uploadInicident(IncidentModel incident);
  Future<String> uploadIncidentImage(UploadIncidentImgDto req);
  Future<List<IncidentModel>> getIncidents();
  Future<List<IncidentModel>> fetchIncidentsByCategory(CategoryDto req);
  Future<List<IncidentModel>> fetchMyIncidents();
  Future<IncidentNotificationModel> incidentNotificationService(
    IncidentNotificationModel incident,
  );
  Future<String> getFCMToken();
}

class IncidentRemoteSourceImpl implements IncidentRemoteSource {
  final SupabaseService _supabaseService;
  final InternetConnectionChecker _internetConnectionChecker;
  final LocalStorageService _localStorageService;
  final FirebaseMessaging _firebaseMessaging;

  IncidentRemoteSourceImpl({
    required SupabaseService supabaseService,
    required InternetConnectionChecker internetConnectionChecker,
    required LocalStorageService localStorageService,
    required FirebaseMessaging firebaseMessaging,
  }) : _supabaseService = supabaseService,
       _internetConnectionChecker = internetConnectionChecker,
       _localStorageService = localStorageService,
       _firebaseMessaging = firebaseMessaging;

  @override
  Future<IncidentModel> uploadInicident(IncidentModel incident) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final response = await _supabaseService.client
          .from('incidents')
          .insert(incident.toJson())
          .select();

      AppLogger.i('Incident uploaded successfully: ${response.first}');

      return IncidentModel.fromJson(response.first);
    } catch (e) {
      AppLogger.e('Incident upload Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadIncidentImage(UploadIncidentImgDto req) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      await _supabaseService.client.storage
          .from('incidents_image')
          .upload(req.incident.id, req.image);

      return _supabaseService.client.storage
          .from('incidents_image')
          .getPublicUrl(req.incident.id);
    } catch (e) {
      AppLogger.e('Incident upload Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<IncidentModel>> getIncidents() async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final incidents = await _supabaseService.client
          .from('incidents')
          .select('*, profiles(fullname)')
          .order('created_at', ascending: false);

      AppLogger.i('Fetch incidents successfully: ${incidents.first}');

      return incidents
          .map(
            (e) => IncidentModel.fromJson(
              e,
            ).copyWith(createdByUsername: e['profiles']['fullname']),
          )
          .toList();
    } catch (e) {
      AppLogger.e('Get incidents Error: $e');
      return [];
    }
  }

  @override
  Future<List<IncidentModel>> fetchIncidentsByCategory(CategoryDto req) async {
    try {
      final incidents = await _supabaseService.client
          .from('incidents')
          .select('*, profiles(fullname)')
          .eq('category', req.category)
          .order('created_at', ascending: false);

      AppLogger.i('Fetch incidents successfully: ${incidents.first}');

      return incidents
          .map(
            (e) => IncidentModel.fromJson(
              e,
            ).copyWith(createdByUsername: e['profiles']['fullname']),
          )
          .toList();
    } catch (e) {
      AppLogger.e('fectch incidents by category Error: $e');
      return [];
    }
  }

  @override
  Future<List<IncidentModel>> fetchMyIncidents() async {
    try {
      final loggedInUser = _supabaseService.client.auth.currentUser;

      final appUserId = _localStorageService.get(AppStorageKeys.uid);

      if (loggedInUser == null ||
          appUserId == null ||
          appUserId != loggedInUser.id) {
        AppLogger.w('User is not logged in. Please log in first.');
        await _supabaseService.client.auth.signOut();
        return [];
      }

      final incidents = await _supabaseService.client
          .from('incidents')
          .select('*, profiles(fullname)')
          .eq('created_by', appUserId)
          .order('created_at', ascending: false);

      AppLogger.i('Fetch incidents successfully: ${incidents.first}');

      return incidents
          .map(
            (e) => IncidentModel.fromJson(
              e,
            ).copyWith(createdByUsername: e['profiles']['fullname']),
          )
          .toList();
    } catch (e) {
      AppLogger.e('fectch incidents by category Error: $e');
      return [];
    }
  }

  @override
  Future<IncidentNotificationModel> incidentNotificationService(
    IncidentNotificationModel incident,
  ) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final response = await _supabaseService.client
          .from('devices')
          .upsert(incident.toJson(), onConflict: 'fcm_token')
          .select();

      if (response.isEmpty) {
        throw ServerException(AppString.noResponse);
      }

      return IncidentNotificationModel.fromJson(response.first);
    } catch (e) {
      AppLogger.e('Incident notification Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> getFCMToken() async {
    try {
      await _firebaseMessaging.requestPermission();

      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken == null) {
        throw ServerException(AppString.noFcmTokenFound);
      }

      AppLogger.i('FCM token: $fcmToken');

      final userId = _localStorageService.get(AppStorageKeys.uid);
      if (userId == null) {
        await _supabaseService.client.auth.signOut();
        throw ServerException(AppString.userNotFound);
      }

      return fcmToken;
    } catch (e) {
      AppLogger.e('Get FCM token Error: $e');
      throw ServerException(e.toString());
    }
  }
}
