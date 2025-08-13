import 'package:citizen_report_incident/features/auth/domain/entities/user_entity.dart';

import '../../../../core/error/failure.dart';
import '../../data/dto/register_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> register(RegisterDTO req);
}
