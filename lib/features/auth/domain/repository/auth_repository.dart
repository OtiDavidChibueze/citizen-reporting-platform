import '../../data/dto/login_dto.dart';
import '../entities/user_entity.dart';

import '../../../../core/error/failure.dart';
import '../../data/dto/register_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> register(RegisterDTO req);
  Future<Either<Failure, UserEntity>> login(LoginDto req);
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
