import 'package:citizen_report_incident/features/incidents/domain/usecases/incident_notification_service_usecase.dart';

import '../../../../core/usecases/usecases.dart';
import '../../data/dto/fetch_incident_by_category.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/usecases/fetch_incidents_by_category.dart';
import '../../domain/usecases/fetch_my_incidents.dart';
import '../../domain/usecases/get_incidents.dart';
import '../../data/dto/upload_incident_dto.dart';
import '../../domain/usecases/add_incident_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'incident_event.dart';
part 'incident_state.dart';

class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  final AddIncidentUseCase _uploadInicidentUseCase;
  final GetIncidentsUsecase _getIncidentsUsecase;
  final FetchIncidentsByCategoryUseCase _fetchIncidentsByCategoryUseCase;
  final FetchMyIncidentsUseCase _fetchMyIncidentsUseCase;
  final IncidentNotificationServiceUsecase _incidentNotificationServiceUsecase;

  IncidentBloc({
    required AddIncidentUseCase uploadInicidentUseCase,
    required GetIncidentsUsecase getIncidentsUsecase,
    required FetchIncidentsByCategoryUseCase fetchIncidentsByCategoryUseCase,
    required FetchMyIncidentsUseCase fetchMyIncidentsUseCase,
    required IncidentNotificationServiceUsecase
    incidentNotificationServiceUsecase,
  }) : _uploadInicidentUseCase = uploadInicidentUseCase,
       _getIncidentsUsecase = getIncidentsUsecase,
       _fetchIncidentsByCategoryUseCase = fetchIncidentsByCategoryUseCase,
       _fetchMyIncidentsUseCase = fetchMyIncidentsUseCase,
       _incidentNotificationServiceUsecase = incidentNotificationServiceUsecase,
       super(IncidentInitialState()) {
    on<IncidentEvent>((event, emit) => emit(IncidentLoadingState()));
    on<AddIncidentEvent>(_onAddIncident);
    on<GetIncidentsEvent>(_onGetIncidents);
    on<FetchIncidentsByCategoryEvent>(_onFetchIncidentsByCategory);
    on<FetchMyIncidentsEvent>(_onFetchMyIncidents);
    on<IncidentNotificationEvent>(_onIncidentNotification);
  }

  Future<void> _onAddIncident(
    AddIncidentEvent event,
    Emitter<IncidentState> emit,
  ) async {
    final result = await _uploadInicidentUseCase(
      UploadIncidentDto(
        title: event.req.title,
        description: event.req.description,
        category: event.req.category,
        latitude: event.req.latitude,
        longitude: event.req.longitude,
        imageFile: event.req.imageFile,
      ),
    );

    result.fold(
      (l) => emit(IncidentErrorState(message: l.message)),
      (r) => emit(IncidentSuccessState()),
    );
  }

  Future<void> _onGetIncidents(
    GetIncidentsEvent event,
    Emitter<IncidentState> emit,
  ) async {
    final result = await _getIncidentsUsecase(NoParams());

    result.fold(
      (l) => emit(IncidentErrorState(message: l.message)),
      (r) => emit(GetIncidentsSuccessState(incidents: r)),
    );
  }

  Future<void> _onFetchIncidentsByCategory(
    FetchIncidentsByCategoryEvent event,
    Emitter<IncidentState> emit,
  ) async {
    final result = await _fetchIncidentsByCategoryUseCase(
      CategoryDto(category: event.req.category),
    );

    result.fold(
      (l) => emit(IncidentErrorState(message: l.message)),
      (r) => emit(GetIncidentsSuccessState(incidents: r)),
    );
  }

  Future<void> _onFetchMyIncidents(
    FetchMyIncidentsEvent event,
    Emitter<IncidentState> emit,
  ) async {
    final result = await _fetchMyIncidentsUseCase(NoParams());

    result.fold(
      (l) => emit(IncidentErrorState(message: l.message)),
      (r) => emit(GetIncidentsSuccessState(incidents: r)),
    );
  }

  Future<void> _onIncidentNotification(
    IncidentNotificationEvent event,
    Emitter<IncidentState> emit,
  ) async {
    final result = await _incidentNotificationServiceUsecase(NoParams());

    result.fold(
      (l) => emit(IncidentErrorState(message: l.message)),
      (r) => emit(IncidentSuccessState()),
    );
  }
}
