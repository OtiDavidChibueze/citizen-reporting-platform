import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/incidents/presentation/pages/incident_page.dart';

import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/splash/presentation/page/splash.dart';
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

      GoRoute(
        path: '/login',
        name: LoginPage.routeName,
        builder: (context, state) => LoginPage(),
      ),

      GoRoute(
        path: '/incident',
        name: IncidentPage.routeName,
        builder: (context, state) => LoginPage(),
      ),
    ],
  );
}
