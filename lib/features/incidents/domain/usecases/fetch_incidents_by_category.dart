import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../../data/dto/fetch_incident_by_category.dart';
import '../entities/incident_entity.dart';
import '../repository/incident_repository.dart';
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
