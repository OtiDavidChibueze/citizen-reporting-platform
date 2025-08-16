import 'dart:io';

class UploadIncidentDto {
  final String title;
  final String description;
  final String category;
  final File imageFile;
  final double latitude;
  final double longitude;

  UploadIncidentDto({
    required this.title,
    required this.description,
    required this.category,
    required this.imageFile,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'category': category,
      'imageFile': imageFile,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
