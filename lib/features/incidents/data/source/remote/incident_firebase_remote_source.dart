import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../core/service/local_storage_hive.dart';
import '../../../../../core/storage/app_storage_keys.dart';
import '../../dto/add_incident_dto.dart';
import '../../model/incident_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/service/fcm_api_service.dart';

abstract interface class IncidentFirebaseRemoteSource {
  Future<IncidentModel> addIncident(AddIncidentDto req);
}

class IncidentFirebaseRemoteSourceImpl implements IncidentFirebaseRemoteSource {
  final Uuid _uuid;
  final InternetConnectionChecker _internetConnectionChecker;
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firestore;
  final LocalStorageService _localStorageService;

  IncidentFirebaseRemoteSourceImpl({
    required Uuid uuid,
    required InternetConnectionChecker internetConnectionChecker,
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firestore,
    required LocalStorageService localStorageService,
  }) : _uuid = uuid,
       _internetConnectionChecker = internetConnectionChecker,
       _firebaseStorage = firebaseStorage,
       _firestore = firestore,
       _localStorageService = localStorageService;

  @override
  Future<IncidentModel> addIncident(AddIncidentDto req) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final String incidentId = _uuid.v4();

      final incidentData = IncidentModel(
        id: incidentId,
        title: req.title,
        description: req.description,
        category: req.category,
        imageUrl: req.imageUrl,
        latitude: req.latitude,
        longitude: req.longitude,
        createdAt: DateTime.now(),
        createdByUserId: _localStorageService.get(AppStorageKeys.uid)!,
        createdByEmail: _localStorageService.get(AppStorageKeys.email)!,
      );

      await _firestore
          .collection('incidents')
          .doc(incidentId)
          .set(incidentData.toMap());

      // Send FCM notification to all users
      try {
        await FcmApiService.sendIncidentNotification(
          title: 'New Incident: ${incidentData.category}',
          body: incidentData.title,
        );
      } catch (e) {
        AppLogger.e('FCM notification failed: $e');
      }

      AppLogger.i('Incident added: ${incidentData.toMap()}');

      return IncidentModel.fromMap(incidentData.toMap());
    } catch (e) {
      AppLogger.e('Add Incident Error: $e');
      throw ServerException(e.toString());
    }
  }
}
