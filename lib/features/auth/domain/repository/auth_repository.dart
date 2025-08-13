import '../../../../core/error/failure.dart';
import '../../data/dto/register_dto.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, dynamic>> register(RegisterDTO req);
}
