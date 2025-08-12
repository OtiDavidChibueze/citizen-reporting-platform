import 'package:citizen_report_incident/app.dart';
import 'package:citizen_report_incident/core/service/locator_service.dart';
import 'package:citizen_report_incident/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();

  runApp(const MyApp());
}
