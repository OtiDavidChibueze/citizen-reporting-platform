import '../../../../core/constants/app_string.dart';
import '../dto/fetch_incident_by_category.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/service/local_storage_service.dart';
import '../../../../core/storage/app_storage_keys.dart';
import '../dto/upload_incident_dto.dart';
import '../dto/upload_incident_img_dto.dart';
import '../model/incident_model.dart';
import '../source/remote/incident_remote_source.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/repository/incident_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteSource _incidentRemoteSource;
  final Uuid _uuid;
  final LocalStorageService _localStorageService;

  IncidentRepositoryImpl({
    required IncidentRemoteSource incidentRemoteSource,
    required Uuid uuid,
    required LocalStorageService localStorageService,
  }) : _incidentRemoteSource = incidentRemoteSource,
       _uuid = uuid,
       _localStorageService = localStorageService;

  @override
  Future<Either<Failure, IncidentEntity>> uploadInicident(
    UploadIncidentDto req,
  ) async {
    try {
      final incidentModel = IncidentModel(
        id: _uuid.v1(),
        title: req.title,
        description: req.description,
        category: req.category,
        imageUrl: '',
        latitude: req.latitude,
        longitude: req.longitude,
        createdAt: DateTime.now(),
        createdByUserId: _localStorageService.get(AppStorageKeys.uid) ?? '',
      );

      final imageUrl = await _incidentRemoteSource.uploadIncidentImage(
        UploadIncidentImgDto(incident: incidentModel, image: req.imageFile),
      );

      final incidentToUpload = incidentModel.copyWith(imageUrl: imageUrl);

      final uploadedIncident = await _incidentRemoteSource.uploadInicident(
        incidentToUpload,
      );

      return Right(uploadedIncident);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IncidentEntity>>> getIncidents() async {
    try {
      final incidents = await _incidentRemoteSource.getIncidents();

      return Right(incidents);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IncidentEntity>>> fetchIncidentsByCategory(
    CategoryDto req,
  ) async {
    try {
      final incidents = await _incidentRemoteSource.fetchIncidentsByCategory(
        req,
      );

      if (incidents == []) {
        return Left(Failure(AppString.noIncidentsFound));
      }

      return Right(incidents);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IncidentEntity>>> fetchMyIncidents() async {
    try {
      final incidents = await _incidentRemoteSource.fetchMyIncidents();

      if (incidents == []) {
        return Left(Failure(AppString.noIncidentsFound));
      }

      return Right(incidents);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
