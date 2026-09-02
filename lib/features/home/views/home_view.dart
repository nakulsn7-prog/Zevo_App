import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';
import 'package:zevo_app/features/auth/bloc/auth_bloc.dart';
import 'package:zevo_app/features/auth/bloc/auth_event.dart';
import 'package:zevo_app/features/auth/bloc/auth_state.dart';
import 'package:zevo_app/features/squad/bloc/squad_bloc.dart';
import 'package:zevo_app/features/squad/bloc/squad_event.dart';
import 'package:zevo_app/features/squad/bloc/squad_state.dart';
import 'package:zevo_app/features/squad/views/squad_home_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Always reload squad state when HomeView is mounted.
    // The bloc is global, so stale state (e.g. SquadEmpty from a
    // previous session) would otherwise prevent the reload.
    context.read<SquadBloc>().add(LoadSquad());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              context.go('/login');
            } else if (state is Authenticated) {
              // Reload squad state when auth state changes to Authenticated
              context.read<SquadBloc>().add(LoadSquad());
            }
          },
        ),
        BlocListener<SquadBloc, SquadState>(
          listener: (context, state) {
            if (state is SquadOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is SquadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<SquadBloc, SquadState>(
        builder: (context, state) {
          if (state is SquadLoading || state is SquadInitial) {
            return const Scaffold(
              backgroundColor: ZevoColors.background,
              body: Center(
                child: CircularProgressIndicator(color: ZevoColors.accent),
              ),
            );
          }

          if (state is SquadLoaded) {
            final authState = context.read<AuthBloc>().state;
            String userId = '';
            if (authState is Authenticated) {
              userId = authState.profile.id;
            }

            return SquadHomeView(
              squad: state.squad,
              members: state.members,
              inviteCode: state.inviteCode,
              currentUserId: userId,
            );
          }

          // SquadEmpty or SquadError (falling back to empty state)
          return Scaffold(
            backgroundColor: ZevoColors.background,
            appBar: AppBar(
              backgroundColor: ZevoColors.background,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: ZevoColors.textPrimary),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: ZevoColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ZevoColors.border,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.group_add,
                          size: 48,
                          color: ZevoColors.accent,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Join the Movement',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: ZevoColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create a new squad or join an existing one to start competing.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: ZevoColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push('/squad/create'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ZevoColors.accent,
                            foregroundColor: ZevoColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Create Squad',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.push('/squad/join'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ZevoColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: ZevoColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Join Squad',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
