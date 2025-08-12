import 'package:citizen_report_incident/app.dart';
import 'package:citizen_report_incident/core/service/firebase_service.dart';
import 'package:citizen_report_incident/core/service/locator_service.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.init();

  setupLocator();

  runApp(const MyApp());
}
