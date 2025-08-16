import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto/login_dto.dart';
import '../../domain/entities/user_entity.dart';

import '../../../../core/constants/app_string.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../dto/register_dto.dart';
import '../source/remote/auth_remote_source.dart';
import '../../domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _AuthRemoteSource;

  AuthRepositoryImpl({required AuthRemoteSource AuthRemoteSource})
    : _AuthRemoteSource = AuthRemoteSource;

  @override
  Future<Either<Failure, UserEntity>> register(RegisterDTO req) =>
      _getCredentails(() async => await _AuthRemoteSource.register(req));

  @override
  Future<Either<Failure, UserEntity>> login(LoginDto req) =>
      _getCredentails(() async => await _AuthRemoteSource.login(req));

  Future<Either<Failure, UserEntity>> _getCredentails(
    Future<UserEntity> Function() fn,
  ) async {
    try {
      final data = await fn();

      return Right(data);
    } on AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final data = await _AuthRemoteSource.getCurrentUser();

      if (data == null) {
        return Left(Failure(AppString.userNotFound));
      }

      return Right(data);
    } on AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
