import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centralized route paths for the Zevo application.
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String journey = '/journey';
  static const String dashboard = '/dashboard';
  static const String logWorkout = '/log-workout';
  static const String division = '/division';
  static const String squad = '/squad';
  static const String profile = '/profile';
}

/// Central router configuration for the application.
class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _PlaceholderScreen(title: 'Splash Screen'),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const _PlaceholderScreen(title: 'Login Screen'),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const _PlaceholderScreen(title: 'Create Account Screen'),
      ),
      GoRoute(
        path: AppRoutes.journey,
        builder: (context, state) => const _PlaceholderScreen(title: 'Choose Your Journey'),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const _PlaceholderScreen(title: 'Dashboard Screen'),
      ),
      GoRoute(
        path: AppRoutes.logWorkout,
        builder: (context, state) => const _PlaceholderScreen(title: 'Log Workout'),
      ),
      GoRoute(
        path: AppRoutes.division,
        builder: (context, state) => const _PlaceholderScreen(title: 'Division Leaderboard'),
      ),
      GoRoute(
        path: AppRoutes.squad,
        builder: (context, state) => const _PlaceholderScreen(title: 'Squad Screen'),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile Screen'),
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
