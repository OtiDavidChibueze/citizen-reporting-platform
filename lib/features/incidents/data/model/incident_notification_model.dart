import 'package:citizen_report_incident/features/incidents/domain/entities/incident_notification_entity.dart';

class IncidentNotificationModel extends IncidentNotificationEntity {
  IncidentNotificationModel({
    required super.id,
    required super.userId,
    required super.fcmToken,
    required super.createdAt,
  });

  IncidentNotificationModel copyWith({
    String? id,
    String? userId,
    String? fcmToken,
    DateTime? createdAt,
  }) {
    return IncidentNotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'fcm_token': fcmToken,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory IncidentNotificationModel.fromJson(Map<String, dynamic> map) {
    assert(map['id'] != null, 'id should not be null');
    assert(map['user_id'] != null, 'user_id should not be null');
    assert(map['fcm_token'] != null, 'fcm_token should not be null');
    assert(map['created_at'] != null, 'created_at should not be null');

    return IncidentNotificationModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      fcmToken: map['fcm_token'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
