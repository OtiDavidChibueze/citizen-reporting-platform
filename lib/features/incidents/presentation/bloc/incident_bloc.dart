import 'package:citizen_report_incident/core/usecases/usecases.dart';
import 'package:citizen_report_incident/features/incidents/data/dto/fetch_incident_by_category.dart';
import 'package:citizen_report_incident/features/incidents/domain/entities/incident_entity.dart';
import 'package:citizen_report_incident/features/incidents/domain/usecases/fetch_incidents_by_category.dart';
import 'package:citizen_report_incident/features/incidents/domain/usecases/get_incidents.dart';
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

  IncidentBloc({
    required AddIncidentUseCase uploadInicidentUseCase,
    required GetIncidentsUsecase getIncidentsUsecase,
    required FetchIncidentsByCategoryUseCase fetchIncidentsByCategoryUseCase,
  }) : _uploadInicidentUseCase = uploadInicidentUseCase,
       _getIncidentsUsecase = getIncidentsUsecase,
       _fetchIncidentsByCategoryUseCase = fetchIncidentsByCategoryUseCase,
       super(IncidentInitialState()) {
    on<IncidentEvent>((event, emit) => emit(IncidentLoadingState()));
    on<AddIncidentEvent>(_onAddIncident);
    on<GetIncidentsEvent>(_onGetIncidents);
    on<FetchIncidentsByCategoryEvent>(_onFetchIncidentsByCategory);
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
}
