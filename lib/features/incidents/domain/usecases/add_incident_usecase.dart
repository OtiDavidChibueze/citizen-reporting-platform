import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../../data/dto/upload_incident_dto.dart';
import '../entities/incident_entity.dart';
import '../repository/incident_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddIncidentUseCase implements UseCase<IncidentEntity, UploadIncidentDto> {
  final IncidentRepository _incidentRepository;

  AddIncidentUseCase({required IncidentRepository incidentRepository})
    : _incidentRepository = incidentRepository;

  @override
  Future<Either<Failure, IncidentEntity>> call(UploadIncidentDto params) async {
    return await _incidentRepository.uploadInicident(params);
  }
}
