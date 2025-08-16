import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:citizen_report_incident/core/usecases/usecases.dart';
import 'package:citizen_report_incident/features/incidents/data/dto/fetch_incident_by_category.dart';
import 'package:citizen_report_incident/features/incidents/domain/entities/incident_entity.dart';
import 'package:citizen_report_incident/features/incidents/domain/repository/incident_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchIncidentsByCategoryUseCase
    implements UseCase<List<IncidentEntity>, CategoryDto> {
  final IncidentRepository _incidentRepository;

  FetchIncidentsByCategoryUseCase({
    required IncidentRepository incidentRepository,
  }) : _incidentRepository = incidentRepository;

  @override
  Future<Either<Failure, List<IncidentEntity>>> call(CategoryDto params) async {
    return await _incidentRepository.fetchIncidentsByCategory(params);
  }
}
