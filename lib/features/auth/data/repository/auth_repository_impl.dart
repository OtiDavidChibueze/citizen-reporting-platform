import 'package:citizen_report_incident/core/constants/app_string.dart';
import 'package:citizen_report_incident/core/error/exception.dart';
import 'package:citizen_report_incident/core/error/failure.dart';
import 'package:citizen_report_incident/features/auth/data/dto/register_dto.dart';
import 'package:citizen_report_incident/features/auth/data/source/remote/auth_firebase_remote_source.dart';
import 'package:citizen_report_incident/features/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseRemoteSource _authFirebaseRemoteSource;

  AuthRepositoryImpl({
    required AuthFirebaseRemoteSource authFirebaseRemoteSource,
  }) : _authFirebaseRemoteSource = authFirebaseRemoteSource;

  @override
  Future<Either<Failure, dynamic>> register(RegisterDTO req) => _getCredentails(
    () async => await _authFirebaseRemoteSource.register(req),
  );

  Future<Either<Failure, dynamic>> _getCredentails(
    Future<dynamic> Function() fn,
  ) async {
    try {
      final data = await fn();

      return Right(data);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message ?? AppString.failure));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
