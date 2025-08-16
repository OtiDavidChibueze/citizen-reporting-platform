import 'package:citizen_report_incident/core/usecases/usecases.dart';
import 'package:citizen_report_incident/features/incidents/domain/entities/incident_entity.dart';
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

  IncidentBloc({
    required AddIncidentUseCase uploadInicidentUseCase,
    required GetIncidentsUsecase getIncidentsUsecase,
  }) : _uploadInicidentUseCase = uploadInicidentUseCase,
       _getIncidentsUsecase = getIncidentsUsecase,
       super(IncidentInitialState()) {
    on<IncidentEvent>((event, emit) => emit(IncidentLoadingState()));
    on<AddIncidentEvent>(_onAddIncident);
    on<GetIncidentsEvent>(_onGetIncidents);
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
}
