import 'package:citizen_report_incident/features/auth/domain/entities/user_entity.dart';

import '../../../../core/constants/app_string.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../dto/register_dto.dart';
import '../source/remote/auth_firebase_remote_source.dart';
import '../../domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseRemoteSource _authFirebaseRemoteSource;

  AuthRepositoryImpl({
    required AuthFirebaseRemoteSource authFirebaseRemoteSource,
  }) : _authFirebaseRemoteSource = authFirebaseRemoteSource;

  @override
  Future<Either<Failure, UserEntity>> register(RegisterDTO req) =>
      _getCredentails(
        () async => await _authFirebaseRemoteSource.register(req),
      );

  Future<Either<Failure, UserEntity>> _getCredentails(
    Future<UserEntity> Function() fn,
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
