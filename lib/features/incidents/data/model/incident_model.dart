import '../../domain/entities/incident_entity.dart';

class IncidentModel extends IncidentEntity {
  IncidentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.imageUrl,
    required super.latitude,
    required super.longitude,
    required super.createdAt,
    required super.createdByUserId,
  });

  IncidentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    String? createdByUserId,
  }) {
    return IncidentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'created_by_user_id': createdByUserId,
    };
  }

  factory IncidentModel.fromJson(Map<String, dynamic> map) {
    return IncidentModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['image_url'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now()),
      createdByUserId: map['created_by_user_id'] ?? '',
    );
  }
}
