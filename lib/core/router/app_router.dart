import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';
import 'package:zevo_app/features/auth/views/splash_view.dart';
import 'package:zevo_app/features/auth/views/login_view.dart';
import 'package:zevo_app/features/auth/views/create_account_view.dart';
import 'package:zevo_app/features/auth/views/authenticated_view.dart';
import 'package:zevo_app/features/journey/views/journey_view.dart';
import 'package:zevo_app/features/dashboard/views/dashboard_view.dart';
import 'package:zevo_app/features/division/views/division_view.dart';
import 'package:zevo_app/features/squad/views/squad_view.dart';
import 'package:zevo_app/features/squad/views/squad_dashboard_view.dart';
import 'package:zevo_app/features/auth/bloc/auth_bloc.dart';
import 'package:zevo_app/features/auth/bloc/auth_state.dart';

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
  static const String squadEmpty = '/squad/empty';
  static const String profile = '/profile';
  static const String authenticated = '/authenticated';
}

/// Resolves the post-authentication route based on the user's journey choice.
///
/// - null (onboarding not completed) or unexpected values -> /journey
/// - 'solo' -> /dashboard (Solo Dashboard via [ZevoDashboardView])
/// - 'squad' -> /dashboard (Squad Dashboard is the squad user's HOME, shown via
///   [ZevoDashboardView]). Squad users are NOT sent to /squad, which is the
///   Squad TAB and renders the Squad Section / details screen.
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
        builder: (context, state) => const ZevoDashboardView(),
      ),
      GoRoute(
        path: AppRoutes.logWorkout,
        builder: (context, state) => const _PlaceholderScreen(title: 'Log Workout'),
      ),
      GoRoute(
        path: AppRoutes.division,
        builder: (context, state) => const DivisionView(),
      ),
      GoRoute(
        path: AppRoutes.squad,
        builder: (context, state) => const ZevoSquadSectionView(),
      ),
      GoRoute(
        path: AppRoutes.squadEmpty,
        builder: (context, state) => const SquadView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const _PlaceholderScreen(title: 'Profile Screen'),
      ),
    ],
  );
}

/// State-aware resolver for the Home (/dashboard) route.
///
/// Renders the correct Home dashboard based on the authenticated user's
/// journeyChoice:
/// - 'solo'  -> [DashboardView] (Solo Dashboard)
/// - 'squad' -> [SquadDashboardView] (Squad Dashboard is the squad user's Home)
class ZevoDashboardView extends StatelessWidget {
  const ZevoDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final journeyChoice = context.select<AuthBloc, String?>(
      (bloc) {
        final state = bloc.state;
        return state is Authenticated ? state.profile.journeyChoice : null;
      },
    );
    return journeyChoice == 'squad'
        ? const SquadDashboardView()
        : const DashboardView();
  }
}

/// State-aware resolver for the Squad (/squad) route.
///
/// The Squad tab represents a SECTION, not a user mode:
/// - 'solo'  -> [SquadView] (Solo Squad Empty / Locked State)
/// - 'squad' -> [SquadDetailsPlaceholder] (real Squad section is Phase 3)
class ZevoSquadSectionView extends StatelessWidget {
  const ZevoSquadSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final journeyChoice = context.select<AuthBloc, String?>(
      (bloc) {
        final state = bloc.state;
        return state is Authenticated ? state.profile.journeyChoice : null;
      },
    );
    return journeyChoice == 'squad'
        ? const SquadDetailsPlaceholder()
        : const SquadView();
  }
}

/// Temporary placeholder for the real Squad section (details) view.
///
/// Used for the Squad tab of SQUAD users until the actual Squad details
/// screen is implemented (Phase 3). It is intentionally NOT the Squad Dashboard
/// (which is the squad user's Home) and NOT the Solo Squad Empty State.
class SquadDetailsPlaceholder extends StatelessWidget {
  const SquadDetailsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZevoColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.group_outlined,
                  size: 40,
                  color: ZevoColors.accent,
                ),
                const SizedBox(height: 16),
                Text(
                  'Squad Section',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.25,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your squad details are coming in Phase 3.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: ZevoColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
