import 'package:citizen_report_incident/features/incidents/domain/entities/incident_notification_entity.dart';

import '../../data/dto/fetch_incident_by_category.dart';

import '../../../../core/error/failure.dart';
import '../entities/incident_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../data/dto/upload_incident_dto.dart';

abstract interface class IncidentRepository {
  Future<Either<Failure, IncidentEntity>> uploadInicident(
    UploadIncidentDto req,
  );
  Future<Either<Failure, List<IncidentEntity>>> getIncidents();
  Future<Either<Failure, List<IncidentEntity>>> fetchIncidentsByCategory(
    CategoryDto req,
  );
  Future<Either<Failure, List<IncidentEntity>>> fetchMyIncidents();

  Future<Either<Failure, IncidentNotificationEntity>>
  incidentNotificationService();
}
