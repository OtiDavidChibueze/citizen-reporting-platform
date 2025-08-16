import '../../data/dto/upload_incident_dto.dart';

import '../../domain/usecases/add_incident_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'incident_event.dart';
part 'incident_state.dart';

class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  final AddIncidentUseCase _uploadInicidentUseCase;

  IncidentBloc({required AddIncidentUseCase uploadInicidentUseCase})
    : _uploadInicidentUseCase = uploadInicidentUseCase,
      super(IncidentInitialState()) {
    on<IncidentEvent>((event, emit) => emit(IncidentLoadingState()));
    on<AddIncidentEvent>(_onAddIncident);
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
}
