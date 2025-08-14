class AddIncidentDto {
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final double latitude;
  final double longitude;

  AddIncidentDto({
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
