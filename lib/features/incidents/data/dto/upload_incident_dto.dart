import 'dart:io';

class UploadIncidentDto {
  final String title;
  final String description;
  final String category;
  final File imageUrl;
  final double latitude;
  final double longitude;

  UploadIncidentDto({
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
