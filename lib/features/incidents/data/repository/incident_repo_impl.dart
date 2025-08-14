import '../../../../core/error/failure.dart';
import '../source/remote/incident_firebase_remote_source.dart';
import '../../domain/entities/incident_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/repository/incident_repository.dart';
import '../dto/add_incident_dto.dart';

class IncidentRepoImpl implements IncidentRepository {
  final IncidentFirebaseRemoteSource _incidentFirebaseRemoteSource;

  IncidentRepoImpl({
    required IncidentFirebaseRemoteSource incidentFirebaseRemoteSource,
  }) : _incidentFirebaseRemoteSource = incidentFirebaseRemoteSource;

  @override
  Future<Either<Failure, IncidentEntity>> addIncident(
    AddIncidentDto req,
  ) async {
    try {
      final data = await _incidentFirebaseRemoteSource.addIncident(req);

      return Right(data);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
