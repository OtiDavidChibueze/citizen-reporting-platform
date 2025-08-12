import 'package:citizen_report_incident/features/incidents/presentation/pages/register_page.dart';
import 'package:citizen_report_incident/features/splash/presentation/page/splash.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter goRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: Splash.routeName,
        builder: (context, state) => Splash(),
      ),

      GoRoute(
        path: '/register',
        name: RegisterPage.routeName,
        builder: (context, state) => RegisterPage(),
      ),
    ],
  );
}
