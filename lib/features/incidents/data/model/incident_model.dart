import 'dart:convert';

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
    required super.createdByEmail,
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
    String? createdByEmail,
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
      createdByEmail: createdByEmail ?? this.createdByEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'createdByUserId': createdByUserId,
      'createdByEmail': createdByEmail,
    };
  }

  factory IncidentModel.fromMap(Map<String, dynamic> map) {
    assert(map['id'] != null, 'Id cannot be null');
    assert(map['title'] != null, 'Title cannot be null');
    assert(map['description'] != null, 'Description cannot be null');
    assert(map['category'] != null, 'Category cannot be null');
    assert(map['imageUrl'] != null, 'ImageUrl cannot be null');
    assert(map['latitude'] != null, 'Latitude cannot be null');
    assert(map['longitude'] != null, 'Longitude cannot be null');
    assert(map['createdAt'] != null, 'CreatedAt cannot be null');
    assert(map['createdByUserId'] != null, 'CreatedByUserId cannot be null');
    assert(map['createdByEmail'] != null, 'CreatedByEmail cannot be null');

    return IncidentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      createdByUserId: map['createdByUserId'] as String,
      createdByEmail: map['createdByEmail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IncidentModel.fromJson(String source) =>
      IncidentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IncidentModel(id: $id, title: $title, description: $description, category: $category, imageUrl: $imageUrl, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, createdByUserId: $createdByUserId, createdByEmail: $createdByEmail)';
  }

  @override
  bool operator ==(covariant IncidentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.imageUrl == imageUrl &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.createdAt == createdAt &&
        other.createdByUserId == createdByUserId &&
        other.createdByEmail == createdByEmail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        imageUrl.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        createdAt.hashCode ^
        createdByUserId.hashCode ^
        createdByEmail.hashCode;
  }
}
