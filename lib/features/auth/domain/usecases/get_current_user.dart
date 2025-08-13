import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUserUsecase implements UseCase<UserEntity, NoParams> {
  final AuthRepository _authRepository;

  GetCurrentUserUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await _authRepository.getCurrentUser();
  }
}
