import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../../data/dto/register_dto.dart';
import '../repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUseCase implements UseCase<dynamic, RegisterDTO> {
  final AuthRepository _authRepository;

  RegisterUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, dynamic>> call(RegisterDTO params) async {
    return _authRepository.register(params);
  }
}
