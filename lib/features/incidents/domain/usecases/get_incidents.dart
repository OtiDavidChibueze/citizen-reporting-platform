import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:citizen_report_incident/core/usecases/usecases.dart';
import 'package:citizen_report_incident/features/incidents/domain/entities/incident_entity.dart';
import 'package:citizen_report_incident/features/incidents/domain/repository/incident_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetIncidentsUsecase implements UseCase<List<IncidentEntity>, NoParams> {
  final IncidentRepository incidentRepository;

  GetIncidentsUsecase({required this.incidentRepository});

  @override
  Future<Either<Failure, List<IncidentEntity>>> call(NoParams params) async {
    return await incidentRepository.getIncidents();
  }
}
