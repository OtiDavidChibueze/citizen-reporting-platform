import '../../../../core/usecases/usecases.dart';
import '../../domain/usecases/get_current_user.dart';

import '../../data/dto/login_dto.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

import '../../data/dto/register_dto.dart';
import '../../domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUsecase _loginUseCase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;

  AuthBloc({
    required RegisterUseCase registerUseCase,
    required LoginUsecase loginUseCase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
  }) : _registerUseCase = registerUseCase,
       _loginUseCase = loginUseCase,
       _getCurrentUserUsecase = getCurrentUserUsecase,
       super(AuthInitialState()) {
    on<AuthEvent>((_, emit) => emit(AuthLoadingState()));
    on<AuthRegisterEvent>(_register);
    on<AuthLoginEvent>(_login);
    on<AuthGetCurrentUserEvent>(_getCurrentUser);
  }

  Future<void> _register(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _registerUseCase(
      RegisterDTO(
        fullname: event.req.fullname,
        email: event.req.email,
        password: event.req.password,
      ),
    );

    result.fold(
      (l) => emit(AuthErrorState(message: l.message)),
      (r) => emit(AuthSuccessState(user: r)),
    );
  }

  Future<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    final result = await _loginUseCase(
      LoginDto(email: event.req.email, password: event.req.password),
    );

    result.fold(
      (l) => emit(AuthErrorState(message: l.message)),
      (r) => emit(AuthSuccessState(user: r)),
    );
  }

  Future<void> _getCurrentUser(
    AuthGetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUsecase(NoParams());

    result.fold(
      (l) => emit(AuthErrorState(message: l.message)),
      (r) => emit(AuthSuccessState(user: r)),
    );
  }
}
