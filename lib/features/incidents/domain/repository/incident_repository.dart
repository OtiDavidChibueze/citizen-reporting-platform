import '../../../../core/error/failure.dart';
import '../entities/incident_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../data/dto/add_incident_dto.dart';

abstract interface class IncidentRepository {
  Future<Either<Failure, IncidentEntity>> addIncident(AddIncidentDto req);
}
