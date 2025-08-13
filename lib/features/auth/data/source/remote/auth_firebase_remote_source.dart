import 'package:citizen_report_incident/features/auth/data/model/user_model.dart';

import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../core/service/firebase_service.dart';
import '../../dto/register_dto.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class AuthFirebaseRemoteSource {
  Future<UserModel> register(RegisterDTO req);
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
  Future<UserModel> register(RegisterDTO req) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final createUser = await _firebaseService.auth
          .createUserWithEmailAndPassword(
            email: req.email,
            password: req.password,
          );

      if (createUser.user == null) {
        throw ServerException(AppString.registerUserFailed);
      }

      final UserModel userData = UserModel(
        name: createUser.user!.displayName!,
        email: createUser.user!.email!,
        password: req.password,
      );

      AppLogger.i(
        'User registered: Uid-> ${createUser.user!.uid}, Email-> ${createUser.user!.email}',
      );

      return UserModel.fromJson(userData.toJson());
    } catch (e) {
      AppLogger.e('Register Error: $e');
      throw ServerException(e.toString());
    }
  }
}
