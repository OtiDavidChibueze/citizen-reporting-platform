class IncidentNotificationEntity {
  final String id;
  final String userId;
  final String fcmToken;
  final DateTime createdAt;

  IncidentNotificationEntity({
    required this.id,
    required this.userId,
    required this.fcmToken,
    required this.createdAt,
  });
}
