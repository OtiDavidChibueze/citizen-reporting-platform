import 'dart:io';
import '../../domain/entities/incident_entity.dart';

class UploadIncidentImgDto {
  final File image;
  final IncidentEntity incident;

  UploadIncidentImgDto({required this.image, required this.incident});
}
