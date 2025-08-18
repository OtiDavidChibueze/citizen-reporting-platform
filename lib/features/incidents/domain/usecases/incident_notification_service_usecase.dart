import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:citizen_report_incident/core/usecases/usecases.dart';
import 'package:citizen_report_incident/features/incidents/domain/entities/incident_notification_entity.dart';
import 'package:citizen_report_incident/features/incidents/domain/repository/incident_repository.dart';
import 'package:fpdart/fpdart.dart';

class IncidentNotificationServiceUsecase
    implements UseCase<IncidentNotificationEntity, NoParams> {
  final IncidentRepository _incidentRepository;

  IncidentNotificationServiceUsecase({
    required IncidentRepository incidentRepository,
  }) : _incidentRepository = incidentRepository;

  @override
  Future<Either<Failure, IncidentNotificationEntity>> call(
    NoParams params,
  ) async {
    return await _incidentRepository.incidentNotificationService();
  }
}
