import '../../data/dto/login_dto.dart';
import '../entities/user_entity.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LoginUsecase implements UseCase<UserEntity, LoginDto> {
  final AuthRepository _authRepository;

  LoginUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginDto params) async {
    return _authRepository.login(params);
  }
}
