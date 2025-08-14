import 'core/common/cubit/image_picker/cubit/image_picker_cubit.dart';
import 'core/common/cubit/navigation_cubit/navigation_cubit.dart';
import 'features/incidents/presentation/bloc/incident_bloc.dart';

import 'core/service/local_storage_hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'app.dart';
import 'core/service/firebase_service.dart';
import 'core/service/locator_service.dart';

import 'core/service/notification_service.dart';
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

  await Hive.initFlutter();
  await LocalStorageService.init();

  await FirebaseService.init();

  setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locatorService<AuthBloc>()),
        BlocProvider(create: (_) => locatorService<IncidentBloc>()),
        BlocProvider(create: (_) => locatorService<NavigationCubit>()),
        BlocProvider(create: (_) => locatorService<ImagePickerCubit>()),
      ],
      child: NotificationInit(child: const MyApp()),
    ),
  );
}

class NotificationInit extends StatelessWidget {
  final Widget child;
  const NotificationInit({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService.initializeFCM(context);
    NotificationService.subscribeToIncidents();
    return child;
  }
}
