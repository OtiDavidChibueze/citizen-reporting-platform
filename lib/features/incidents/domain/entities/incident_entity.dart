class IncidentEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String createdByUserId;
  String? createdByUsername;
  IncidentEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.createdByUserId,
    this.createdByUsername,
  });
}
