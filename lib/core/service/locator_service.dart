import 'package:citizen_report_incident/features/incidents/domain/usecases/get_incidents.dart';

import '../common/cubit/geolocator/geolocator_cubit.dart';
import 'supabase_service.dart';
import '../common/cubit/image_picker/cubit/image_picker_cubit.dart';
import '../common/cubit/navigation_cubit/navigation_cubit.dart';
import '../../features/incidents/data/repository/incident_repo_impl.dart';
import '../../features/incidents/data/source/remote/incident_remote_source.dart';
import '../../features/incidents/domain/repository/incident_repository.dart';
import '../../features/incidents/domain/usecases/add_incident_usecase.dart';
import '../../features/incidents/presentation/bloc/incident_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import 'local_storage_service.dart';

import '../../features/auth/domain/usecases/login_usecase.dart';

import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/data/source/remote/auth_remote_source.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uuid/uuid.dart';

final locatorService = GetIt.I;

setupLocator() {
  locatorService.registerLazySingleton(() => SupabaseService());
  locatorService.registerFactory(() => Uuid());
  locatorService.registerLazySingleton(() => InternetConnectionChecker.I);
  locatorService.registerLazySingleton(() => LocalStorageService());

  locatorService.registerFactory(() => ImagePicker());

  _initAuth();

  _initIncident();

  locatorService.registerLazySingleton(() => NavigationCubit());

  locatorService.registerLazySingleton(
    () => ImagePickerCubit(imagePicker: locatorService()),
  );

  locatorService.registerFactory(() => GeolocatorCubit());
}

_initAuth() {
  locatorService
    ..registerLazySingleton<AuthRemoteSource>(
      () => AuthRemoteSourceImpl(
        firebaseService: locatorService(),
        internetConnectionChecker: locatorService(),
        localStorageService: locatorService(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(AuthRemoteSource: locatorService()),
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
    ..registerLazySingleton<IncidentRemoteSource>(
      () => IncidentRemoteSourceImpl(
        internetConnectionChecker: locatorService(),
        localStorageService: locatorService(),
        supabaseService: locatorService(),
        uuid: locatorService(),
      ),
    )
    ..registerLazySingleton<IncidentRepository>(
      () => IncidentRepositoryImpl(
        incidentRemoteSource: locatorService(),
        uuid: locatorService(),
        localStorageService: locatorService(),
      ),
    )
    ..registerFactory(
      () => AddIncidentUseCase(incidentRepository: locatorService()),
    )
    ..registerFactory(
      () => GetIncidentsUsecase(incidentRepository: locatorService()),
    )
    ..registerLazySingleton(
      () => IncidentBloc(
        uploadInicidentUseCase: locatorService(),
        getIncidentsUsecase: locatorService(),
      ),
    );
}
