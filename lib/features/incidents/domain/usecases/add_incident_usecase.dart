import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../../data/dto/add_incident_dto.dart';
import '../entities/incident_entity.dart';
import '../repository/incident_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddIncidentUseCase implements UseCase<IncidentEntity, AddIncidentDto> {
  final IncidentRepository _incidentRepository;

  AddIncidentUseCase({required IncidentRepository incidentRepository})
    : _incidentRepository = incidentRepository;

  @override
  Future<Either<Failure, IncidentEntity>> call(AddIncidentDto params) async {
    return await _incidentRepository.addIncident(params);
  }
}
