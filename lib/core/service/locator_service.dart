import '../common/cubit/image_picker/cubit/image_picker_cubit.dart';
import '../common/cubit/navigation_cubit/navigation_cubit.dart';
import '../../features/incidents/data/repository/incident_repo_impl.dart';
import '../../features/incidents/data/source/remote/incident_firebase_remote_source.dart';
import '../../features/incidents/domain/repository/incident_repository.dart';
import '../../features/incidents/domain/usecases/add_incident_usecase.dart';
import '../../features/incidents/presentation/bloc/incident_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/auth/domain/usecases/get_current_user.dart';

import 'local_storage_hive.dart';

import '../../features/auth/domain/usecases/login_usecase.dart';

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
  locatorService.registerLazySingleton(() => LocalStorageService());
  locatorService.registerLazySingleton(() => FirebaseStorage.instance);
  locatorService.registerLazySingleton(() => FirebaseFirestore.instance);
  locatorService.registerLazySingleton(() => ImagePicker());

  _initAuth();

  _initIncident();

  _initNavigationCubit();

  _initImagePickerCubit();
}

_initAuth() {
  locatorService
    ..registerLazySingleton<AuthFirebaseRemoteSource>(
      () => AuthFirebaseRemoteSourceImpl(
        firebaseService: locatorService(),
        internetConnectionChecker: locatorService(),
        localStorageService: locatorService(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authFirebaseRemoteSource: locatorService()),
    )
    ..registerFactory(() => RegisterUseCase(authRepository: locatorService()))
    ..registerFactory(() => LoginUsecase(authRepository: locatorService()))
    ..registerFactory(
      () => GetCurrentUserUsecase(authRepository: locatorService()),
    )
    ..registerLazySingleton(
      () => AuthBloc(
        registerUseCase: locatorService(),
        loginUseCase: locatorService(),
        getCurrentUserUsecase: locatorService(),
      ),
    );
}

_initIncident() {
  locatorService
    ..registerLazySingleton<IncidentFirebaseRemoteSource>(
      () => IncidentFirebaseRemoteSourceImpl(
        firebaseStorage: locatorService(),
        firestore: locatorService(),
        internetConnectionChecker: locatorService(),
        localStorageService: locatorService(),
        uuid: locatorService(),
      ),
    )
    ..registerLazySingleton<IncidentRepository>(
      () => IncidentRepoImpl(incidentFirebaseRemoteSource: locatorService()),
    )
    ..registerFactory(
      () => AddIncidentUseCase(incidentRepository: locatorService()),
    )
    ..registerLazySingleton(
      () => IncidentBloc(addIncidentUseCase: locatorService()),
    );
}

_initNavigationCubit() {
  locatorService.registerLazySingleton(() => NavigationCubit());
}

_initImagePickerCubit() {
  locatorService.registerLazySingleton(
    () => ImagePickerCubit(imagePicker: locatorService()),
  );
}
