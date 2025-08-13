import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:citizen_report_incident/features/auth/data/dto/register_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, dynamic>> register(RegisterDTO req);
}
