import 'dart:io';
import 'package:citizen_report_incident/features/incidents/domain/entities/incident_entity.dart';

class UploadIncidentImgDto {
  final File image;
  final IncidentEntity incident;

  UploadIncidentImgDto({required this.image, required this.incident});
}
