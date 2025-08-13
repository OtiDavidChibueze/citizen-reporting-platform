import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:citizen_report_incident/core/usecases/usecases.dart';
import 'package:citizen_report_incident/features/auth/data/dto/register_dto.dart';
import 'package:citizen_report_incident/features/auth/domain/repository/auth_repository.dart';
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
