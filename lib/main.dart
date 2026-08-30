import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zevo_app/features/auth/bloc/auth_bloc.dart';
import 'package:database_client/database_client.dart';
import 'package:auth/auth.dart';
import 'package:squad/squad.dart';
import 'package:workout/workout.dart';
import 'package:division/division.dart';
import 'core/config/config.dart';
import 'core/theme/zevo_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate configuration settings (URL and anon key check)
  AppConfig.validate();

  // Initialize central Supabase client wrapper
  final dbClient = await DatabaseClient.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Initialize domain repositories
  final authRepository = AuthRepositoryImpl(dbClient);
  final squadRepository = SquadRepositoryImpl(dbClient);
  final workoutRepository = WorkoutRepositoryImpl(dbClient);
  final divisionRepository = DivisionRepositoryImpl(dbClient);

  runApp(
    ZevoApp(
      authRepository: authRepository,
      squadRepository: squadRepository,
      workoutRepository: workoutRepository,
      divisionRepository: divisionRepository,
    ),
  );
}

/// The root ZEVO application widget.
class ZevoApp extends StatelessWidget {
  final AuthRepository authRepository;
  final SquadRepository squadRepository;
  final WorkoutRepository workoutRepository;
  final DivisionRepository divisionRepository;

  const ZevoApp({
    super.key,
    required this.authRepository,
    required this.squadRepository,
    required this.workoutRepository,
    required this.divisionRepository,
  });

@override
Widget build(BuildContext context) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>.value(value: authRepository),
      RepositoryProvider<SquadRepository>.value(value: squadRepository),
      RepositoryProvider<WorkoutRepository>.value(value: workoutRepository),
      RepositoryProvider<DivisionRepository>.value(value: divisionRepository),
    ],
    child: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository),
      child: MaterialApp.router(
        title: 'ZEVO',
        debugShowCheckedModeBanner: false,
        theme: ZevoTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    ),
  );
}
}
