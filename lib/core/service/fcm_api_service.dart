import 'dart:convert';
import 'package:http/http.dart' as http;

class FcmApiService {
  static const String _serverKey =
      'YOUR_SERVER_KEY_HERE'; // TODO: Replace with your FCM server key
  static const String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  static Future<void> sendIncidentNotification({
    required String title,
    required String body,
  }) async {
    final message = {
      'to': '/topics/incidents',
      'notification': {'title': title, 'body': body},
      'priority': 'high',
    };

    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
      body: jsonEncode(message),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send FCM notification: ${response.body}');
    }
  }
}
