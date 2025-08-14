part of 'incident_bloc.dart';

sealed class IncidentState extends Equatable {
  const IncidentState();

  @override
  List<Object> get props => [];
}

final class IncidentInitialState extends IncidentState {}

final class IncidentLoadingState extends IncidentState {}

final class IncidentSuccessState extends IncidentState {}

final class IncidentErrorState extends IncidentState {
  final String message;

  const IncidentErrorState({required this.message});
}
