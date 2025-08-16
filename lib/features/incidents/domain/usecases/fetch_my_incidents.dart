import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/incident_entity.dart';
import '../repository/incident_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchMyIncidentsUseCase
    implements UseCase<List<IncidentEntity>, NoParams> {
  final IncidentRepository _incidentRepository;

  FetchMyIncidentsUseCase({required IncidentRepository incidentRepository})
    : _incidentRepository = incidentRepository;

  @override
  Future<Either<Failure, List<IncidentEntity>>> call(NoParams params) async {
    return await _incidentRepository.fetchMyIncidents();
  }
}
