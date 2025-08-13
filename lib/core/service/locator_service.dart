import 'firebase_service.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/data/source/remote/auth_firebase_remote_source.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';

final locatorService = GetIt.I;

void setupLocator() {
  locatorService.registerLazySingleton(() => FirebaseService());
  locatorService.registerLazySingleton(() => Uuid());
  locatorService.registerLazySingleton(() => InternetConnectionChecker.I);

  _initAuth();
}

_initAuth() {
  locatorService
    ..registerLazySingleton<AuthFirebaseRemoteSource>(
      () => AuthFirebaseRemoteSourceImpl(
        firebaseService: locatorService(),
        internetConnectionChecker: locatorService(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authFirebaseRemoteSource: locatorService()),
    )
    ..registerFactory(() => RegisterUseCase(authRepository: locatorService()))
    ..registerLazySingleton(() => AuthBloc(registerUseCase: locatorService()));
}
