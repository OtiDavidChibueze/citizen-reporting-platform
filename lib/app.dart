import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/incidents/presentation/pages/incident.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_string.dart';
import 'core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthGetCurrentUserEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          return AppRoutes.goRouter.goNamed(
            Incident.routeName,
            extra: state.user,
          );
        } else if (state is AuthErrorState) {
          return AppRoutes.goRouter.goNamed(LoginPage.routeName);
        }
      },
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp.router(
          title: AppString.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: AppString.fontFamily),
          routerConfig: AppRoutes.goRouter,
        ),
      ),
    );
  }
}
