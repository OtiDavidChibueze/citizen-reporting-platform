import '../../../../core/error/failure.dart';
import '../entities/incident_entity.dart';
import 'package:fpdart/fpdart.dart';

import '../../data/dto/upload_incident_dto.dart';

abstract interface class IncidentRepository {
  Future<Either<Failure, IncidentEntity>> uploadInicident(
    UploadIncidentDto req,
  );
}
