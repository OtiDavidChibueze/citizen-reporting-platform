
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final ImagePicker _imagePicker;

  ImagePickerCubit({required ImagePicker imagePicker})
    : _imagePicker = imagePicker,
      super(ImagePickerInitial());

  Future<void> pickImage() async {
    try {
      emit(ImagePickerLoadingState());

      final pickImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickImage == null || pickImage.path.isEmpty || pickImage.path == '') {
        return emit(ImagePickerErrorState(message: 'No image selected'));
      }

      return emit(ImagePickerSuccessState(imageFile: pickImage));
    } catch (e) {
      emit(ImagePickerLoadingState());
      return emit(ImagePickerErrorState(message: e.toString()));
    }
  }

  void resetImage() {
    emit(ImagePickerInitial());
  }
}
