part of 'incident_bloc.dart';

sealed class IncidentEvent extends Equatable {
  const IncidentEvent();

  @override
  List<Object> get props => [];
}

final class AddIncidentEvent extends IncidentEvent {
  final AddIncidentDto req;

  const AddIncidentEvent({required this.req});
}
