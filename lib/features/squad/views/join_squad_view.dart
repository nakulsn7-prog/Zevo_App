import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';
import 'package:zevo_app/features/squad/bloc/squad_bloc.dart';
import 'package:zevo_app/features/squad/bloc/squad_event.dart';
import 'package:zevo_app/features/squad/bloc/squad_state.dart';

class JoinSquadView extends StatefulWidget {
  const JoinSquadView({super.key});

  @override
  State<JoinSquadView> createState() => _JoinSquadViewState();
}

class _JoinSquadViewState extends State<JoinSquadView> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onJoin() {
    context.read<SquadBloc>().add(
          JoinSquadRequested(_codeController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SquadBloc, SquadState>(
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
        } else if (state is SquadLoaded) {
          context.go('/dashboard');
        }
      },
      child: Scaffold(
        backgroundColor: ZevoColors.background,
        appBar: AppBar(
          backgroundColor: ZevoColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ZevoColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Join Squad',
            style: TextStyle(
              color: ZevoColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Invite Code',
                  style: TextStyle(
                    color: ZevoColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ask your squad owner for the code.',
                  style: TextStyle(
                    color: ZevoColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _codeController,
                  style: const TextStyle(
                    color: ZevoColors.textPrimary,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'e.g. ZEVO-1234',
                    hintStyle: const TextStyle(
                      color: ZevoColors.textSecondary,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: ZevoColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ZevoColors.accent, width: 1),
                    ),
                  ),
                ),
                const Spacer(),
                BlocBuilder<SquadBloc, SquadState>(
                  builder: (context, state) {
                    final isLoading = state is SquadLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _onJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ZevoColors.accent,
                        foregroundColor: ZevoColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: ZevoColors.surface,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ZevoColors.textPrimary,
                                ),
                              ),
                            )
                          : const Text(
                              'Join Squad',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
