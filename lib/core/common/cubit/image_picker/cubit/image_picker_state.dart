part of 'image_picker_cubit.dart';

sealed class ImagePickerState extends Equatable {
  const ImagePickerState();

  @override
  List<Object> get props => [];
}

final class ImagePickerInitial extends ImagePickerState {}

final class ImagePickerLoadingState extends ImagePickerState {}

final class ImagePickerSuccessState extends ImagePickerState {
  final XFile imageFile;

  const ImagePickerSuccessState({required this.imageFile});
}

final class ImagePickerErrorState extends ImagePickerState {
  final String message;

  const ImagePickerErrorState({required this.message});
}
