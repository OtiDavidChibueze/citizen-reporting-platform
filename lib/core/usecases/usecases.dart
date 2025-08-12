import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
