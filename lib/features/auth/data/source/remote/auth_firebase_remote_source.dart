import 'package:citizen_report_incident/core/constants/app_string.dart';
import 'package:citizen_report_incident/core/error/exception.dart';
import 'package:citizen_report_incident/core/logger/app_logger.dart';
import 'package:citizen_report_incident/core/service/firebase_service.dart';
import 'package:citizen_report_incident/features/auth/data/dto/register_dto.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class AuthFirebaseRemoteSource {
  Future<dynamic> register(RegisterDTO req);
}

class AuthFirebaseRemoteSourceImpl implements AuthFirebaseRemoteSource {
  final FirebaseService _firebaseService;
  final InternetConnectionChecker _internetConnectionChecker;

  AuthFirebaseRemoteSourceImpl({
    required FirebaseService firebaseService,
    required InternetConnectionChecker internetConnectionChecker,
  }) : _firebaseService = firebaseService,
       _internetConnectionChecker = internetConnectionChecker;

  @override
  Future register(RegisterDTO req) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final createUser = await _firebaseService.auth
          .createUserWithEmailAndPassword(
            email: req.email,
            password: req.password,
          );

      AppLogger.i('User registered: $createUser');

      return createUser.user;
    } catch (e) {
      AppLogger.e('Register Error: $e');
      throw ServerException(e.toString());
    }
  }
}
