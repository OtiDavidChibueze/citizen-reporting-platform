import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initializeFCM(BuildContext context) async {
    // Request permissions for iOS
    await _messaging.requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notification = message.notification!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notification.title ?? 'New Incident'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  static Future<void> subscribeToIncidents() async {
    await _messaging.subscribeToTopic('incidents');
  }
}
