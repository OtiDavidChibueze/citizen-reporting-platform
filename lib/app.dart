import 'core/constants/app_string.dart';
import 'core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        title: AppString.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: AppString.fontFamily),
        routerConfig: AppRoutes.goRouter,
      ),
    );
  }
}
