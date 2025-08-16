import 'package:citizen_report_incident/core/error/exception.dart';
import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:citizen_report_incident/core/service/local_storage_service.dart';
import 'package:citizen_report_incident/core/storage/app_storage_keys.dart';
import 'package:citizen_report_incident/features/incidents/data/dto/upload_incident_dto.dart';
import 'package:citizen_report_incident/features/incidents/data/dto/upload_incident_img_dto.dart';
import 'package:citizen_report_incident/features/incidents/data/model/incident_model.dart';
import 'package:citizen_report_incident/features/incidents/data/source/remote/incident_remote_source.dart';
import 'package:citizen_report_incident/features/incidents/domain/entities/incident_entity.dart';
import 'package:citizen_report_incident/features/incidents/domain/repository/incident_repository.dart';
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
        createdByUserId: _localStorageService.get(AppStorageKeys.uid)!,
      );

      final imageUrl = await _incidentRemoteSource.uploadIncidentImage(
        UploadIncidentImgDto(incident: incidentModel, image: req.imageUrl),
      );

      return Right(incidentModel.copyWith(imageUrl: imageUrl));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
