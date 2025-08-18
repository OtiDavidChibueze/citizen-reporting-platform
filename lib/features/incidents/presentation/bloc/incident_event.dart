part of 'incident_bloc.dart';

sealed class IncidentEvent extends Equatable {
  const IncidentEvent();

  @override
  List<Object> get props => [];
}

final class AddIncidentEvent extends IncidentEvent {
  final UploadIncidentDto req;

  const AddIncidentEvent({required this.req});
}

final class GetIncidentsEvent extends IncidentEvent {
  final bool refresh;

  const GetIncidentsEvent({this.refresh = true});
}

final class FetchIncidentsByCategoryEvent extends IncidentEvent {
  final CategoryDto req;

  const FetchIncidentsByCategoryEvent({required this.req});
}

final class FetchMyIncidentsEvent extends IncidentEvent {}

final class IncidentNotificationEvent extends IncidentEvent {}

final class GetIncidentTimer extends IncidentEvent {}

final class StopIncidentTimer extends IncidentEvent {}
