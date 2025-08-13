import '../../data/dto/register_dto.dart';
import '../../domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;

  AuthBloc({required RegisterUseCase registerUseCase})
    : _registerUseCase = registerUseCase,
      super(AuthInitialState()) {
    on<AuthEvent>((_, emit) => AuthLoadingState());
    on<AuthRegisterEvent>(_register);
  }

  Future<void> _register(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _registerUseCase(
      RegisterDTO(email: event.req.email, password: event.req.password),
    );

    result.fold(
      (l) => emit(AuthErrorState(message: l.message)),
      (r) => emit(AuthSuccessState(data: r)),
    );
  }
}
