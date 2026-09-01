import 'package:go_router/go_router.dart';
import 'package:zevo_app/features/auth/views/splash_view.dart';
import 'package:zevo_app/features/auth/views/login_view.dart';
import 'package:zevo_app/features/auth/views/create_account_view.dart';
import 'package:zevo_app/features/auth/views/authenticated_view.dart';
import 'package:zevo_app/features/journey/views/journey_view.dart';
import 'package:zevo_app/features/home/views/home_view.dart';

/// Centralized route paths for the Zevo application.
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String journey = '/journey';
  static const String dashboard = '/dashboard';
  static const String authenticated = '/authenticated';
}

/// Resolves the post-authentication route based on the user's journey choice.
///
/// - null (onboarding not completed) or unexpected values -> /journey
/// - 'solo' or 'squad' -> /dashboard (Locked Home View in Phase 2)
String resolveJourneyRoute(String? journeyChoice) {
  switch (journeyChoice) {
    case 'solo':
    case 'squad':
      return AppRoutes.dashboard;
    default:
      return AppRoutes.journey;
  }
}

/// Central router configuration for the application.
class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const CreateAccountView(),
      ),
      GoRoute(
        path: AppRoutes.authenticated,
        builder: (context, state) => const AuthenticatedView(),
      ),
      GoRoute(
        path: AppRoutes.journey,
        builder: (context, state) => const JourneyView(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
