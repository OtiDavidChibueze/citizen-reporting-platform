part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {
  final dynamic data;

  const AuthSuccessState({required this.data});
}

final class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});
}
