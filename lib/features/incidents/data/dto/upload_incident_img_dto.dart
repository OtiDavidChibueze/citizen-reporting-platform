import 'package:image_picker/image_picker.dart';


import '../../domain/entities/incident_entity.dart';

class UploadIncidentImgDto {
  final XFile image;
  final IncidentEntity incident;

  UploadIncidentImgDto({required this.image, required this.incident});
}

