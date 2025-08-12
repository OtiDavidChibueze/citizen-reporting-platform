import 'package:citizen_report_incident/core/service/firebase_service.dart';
import 'package:get_it/get_it.dart';

final locatorService = GetIt.I;

void setupLocator() {
  locatorService.registerLazySingleton(() => FirebaseService());
}
