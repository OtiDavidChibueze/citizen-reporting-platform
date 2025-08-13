import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/service/firebase_service.dart';
import 'core/service/locator_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  await FirebaseService.init();

  setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => locatorService<AuthBloc>())],
      child: const MyApp(),
    ),
  );
}
