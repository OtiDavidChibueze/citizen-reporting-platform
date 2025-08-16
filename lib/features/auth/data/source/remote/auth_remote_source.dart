import '../../../../../core/service/supabase_service.dart';
import '../../../../../core/storage/app_storage_keys.dart';
import '../../../../../core/service/local_storage_service.dart';
import '../../dto/login_dto.dart';
import '../../model/user_model.dart';
import '../../../../../core/constants/app_string.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/logger/app_logger.dart';
import '../../dto/register_dto.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class AuthRemoteSource {
  Future<UserModel> register(RegisterDTO req);
  Future<UserModel> login(LoginDto req);
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final SupabaseService _supabaseService;
  final InternetConnectionChecker _internetConnectionChecker;
  final LocalStorageService _localStorageService;

  AuthRemoteSourceImpl({
    required SupabaseService firebaseService,
    required InternetConnectionChecker internetConnectionChecker,
    required LocalStorageService localStorageService,
  }) : _supabaseService = firebaseService,
       _internetConnectionChecker = internetConnectionChecker,
       _localStorageService = localStorageService;

  @override
  Future<UserModel> register(RegisterDTO req) async {
    try {
      if (!await _internetConnectionChecker.hasConnection) {
        throw ServerException(AppString.noInternetConnection);
      }

      final response = await _supabaseService.client.auth.signUp(
        email: req.email,
        password: req.password,
        data: {'fullname': req.fullname},
      );

      if (response.user == null) {
        throw ServerException(AppString.registrationFailed);
      }

      AppLogger.i('Register Success: ${response.user}');

      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: response.user!.email);
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

      final response = await _supabaseService.client.auth.signInWithPassword(
        password: req.password,
        email: req.email,
      );

      if (response.user == null) {
        throw ServerException(AppString.loginFailed);
      }

      AppLogger.i('Login Success: ${response.user}');

      _localStorageService.save(AppStorageKeys.uid, response.user!.id);

      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: response.user!.email);
    } catch (e) {
      AppLogger.e('Login Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentSession = _supabaseService.client.auth.currentSession;

      AppLogger.i('Current Session: ${currentSession?.user.id}');

      if (currentSession == null) {
        return null;
      }

      final getSavedUserId = _localStorageService.get(AppStorageKeys.uid);

      AppLogger.i('Storage id: $getSavedUserId');

      if (getSavedUserId == null || getSavedUserId != currentSession.user.id) {
        await _localStorageService.clear();
        await _supabaseService.client.auth.signOut();
        return null;
      }

      final userData = await _supabaseService.client
          .from('profiles')
          .select()
          .eq('id', currentSession.user.id)
          .single();

      return UserModel.fromJson(
        userData,
      ).copyWith(email: currentSession.user.email);
    } catch (e) {
      AppLogger.e('Get Current User Error: $e');
      throw ServerException(e.toString());
    }
  }
}
