import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';

import 'app.dart';
import 'core/common/cubit/geolocator/geolocator_cubit.dart';
import 'core/common/cubit/image_picker/cubit/image_picker_cubit.dart';
import 'core/common/cubit/navigation_cubit/navigation_cubit.dart';
import 'core/service/local_storage_service.dart';
import 'core/service/locator_service.dart';
import 'core/service/supabase_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/incidents/presentation/bloc/incident_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  await LocalStorageService.init();

  await SupabaseService.init();

  await setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locatorService<AuthBloc>()),
        BlocProvider(create: (_) => locatorService<IncidentBloc>()),
        BlocProvider(create: (_) => locatorService<NavigationCubit>()),
        BlocProvider(create: (_) => locatorService<ImagePickerCubit>()),
        BlocProvider(create: (_) => locatorService<GeolocatorCubit>()),
      ],
      child: MyApp(),
    ),
  );
}
