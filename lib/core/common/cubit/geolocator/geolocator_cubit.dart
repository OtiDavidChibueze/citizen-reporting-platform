import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
part 'geolocator_state.dart';

class GeolocatorCubit extends Cubit<GeolocatorState> {
  GeolocatorCubit() : super(GeolocatorInitial());

  StreamSubscription<Position>? _positionSub;

  Future<void> getCurrentPosition() async {
    emit(GeolocatorLoading());

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(GeolocatorError(message: 'Device location is currently disabled.'));
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(GeolocatorError(message: 'Location permissions are denied.'));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(
        GeolocatorError(
          message:
              'Location permissions are permanently denied, cannot request permissions.',
        ),
      );
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      emit(GeolocatorSuccess(position: position));
    } catch (e) {
      emit(GeolocatorError(message: e.toString()));
    }
  }

  void startLiveLocation() {
    final settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen((pos) => emit(GeolocatorSuccess(position: pos)));
  }

  @override
  Future<void> close() {
    _positionSub?.cancel();
    return super.close();
  }
}
