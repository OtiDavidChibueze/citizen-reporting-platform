import 'package:citizen_report_incident/features/incidents/data/dto/fetch_incident_by_category.dart';

import '../../../../../core/service/supabase_service.dart';
import '../../dto/upload_incident_img_dto.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../core/service/local_storage_service.dart';
import '../../model/incident_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';

abstract interface class IncidentRemoteSource {
  Future<IncidentModel> uploadInicident(IncidentModel incident);
  Future<String> uploadIncidentImage(UploadIncidentImgDto req);
  Future<List<IncidentModel>> getIncidents();
  Future<List<IncidentModel>> fetchIncidentsByCategory(CategoryDto req);
}

class IncidentRemoteSourceImpl implements IncidentRemoteSource {
  final SupabaseService _supabaseService;
  final InternetConnectionChecker _internetConnectionChecker;

  IncidentRemoteSourceImpl({
    required Uuid uuid,
    required SupabaseService supabaseService,
    required InternetConnectionChecker internetConnectionChecker,
    required LocalStorageService localStorageService,
  }) : _supabaseService = supabaseService,
       _internetConnectionChecker = internetConnectionChecker;

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
      throw ServerException(e.toString());
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
}
