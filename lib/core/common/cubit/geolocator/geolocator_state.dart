part of 'geolocator_cubit.dart';

sealed class GeolocatorState extends Equatable {
  const GeolocatorState();

  @override
  List<Object> get props => [];
}

final class GeolocatorInitial extends GeolocatorState {}

final class GeolocatorLoading extends GeolocatorState {}

final class GeolocatorSuccess extends GeolocatorState {
  final Position position;

  const GeolocatorSuccess({required this.position});
}

final class GeolocatorError extends GeolocatorState {
  final String message;

  const GeolocatorError({required this.message});
}
