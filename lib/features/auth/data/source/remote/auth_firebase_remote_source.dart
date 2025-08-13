import '../../../../../core/storage/app_storage_keys.dart';

import '../../../../../core/service/local_storage_hive.dart';

import '../../dto/login_dto.dart';
import '../../model/user_model.dart';

import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../../../../core/service/firebase_service.dart';
import '../../dto/register_dto.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class AuthFirebaseRemoteSource {
  Future<UserModel> register(RegisterDTO req);
  Future<UserModel> login(LoginDto req);
  Future<UserModel?> getCurrentUser();
}

class AuthFirebaseRemoteSourceImpl implements AuthFirebaseRemoteSource {
  final FirebaseService _firebaseService;
  final InternetConnectionChecker _internetConnectionChecker;
  final LocalStorageService _localStorageService;

  AuthFirebaseRemoteSourceImpl({
    required FirebaseService firebaseService,
    required InternetConnectionChecker internetConnectionChecker,
    required LocalStorageService localStorageService,
  }) : _firebaseService = firebaseService,
       _internetConnectionChecker = internetConnectionChecker,
       _localStorageService = localStorageService;

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
        name: req.name,
        email: createUser.user!.email!,
        password: '',
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

  @override
  Future<UserModel> login(LoginDto req) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final loginUser = await _firebaseService.auth.signInWithEmailAndPassword(
        email: req.email,
        password: req.password,
      );

      if (loginUser.user == null) {
        throw ServerException(AppString.loginFailed);
      }

      final name = loginUser.user!.email!.split('@')[0];

      await _localStorageService.save(AppStorageKeys.uid, loginUser.user!.uid);
      await _localStorageService.save(AppStorageKeys.name, name);
      await _localStorageService.save(
        AppStorageKeys.email,
        loginUser.user!.email!,
      );

      final UserModel userData = UserModel(
        name: name,
        email: loginUser.user!.email!,
        password: req.password,
      );

      AppLogger.i(
        'User logged in: Uid-> ${loginUser.user!.uid}, Email-> ${loginUser.user!.email}, Name-> $name',
      );

      return UserModel.fromJson(userData.toJson());
    } catch (e) {
      AppLogger.e('Login Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseService.auth.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      final savedUserId = _localStorageService.get(AppStorageKeys.uid);

      if (savedUserId == null || savedUserId != firebaseUser.uid) {
        await _localStorageService.clear();
        await _firebaseService.auth.signOut();
        return null;
      }

      final email = _localStorageService.get(AppStorageKeys.email);
      final name = _localStorageService.get(AppStorageKeys.name);

      final UserModel userData = UserModel(
        name: name!,
        email: email!,
        password: '',
      );

      AppLogger.i(
        'Current User: Uid-> ${firebaseUser.uid}, Email-> $email, Name-> $name',
      );

      return UserModel.fromJson(userData.toJson());
    } catch (e) {
      AppLogger.e('Get Current User Error: $e');
      throw ServerException(e.toString());
    }
  }
}
