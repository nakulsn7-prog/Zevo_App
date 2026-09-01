import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../widgets/journey_option_card.dart';

class JourneyView extends StatelessWidget {
  const JourneyView({super.key});

  void _chooseJourney(BuildContext context, String choice) {
    context.read<AuthBloc>().add(SetJourneyChoice(choice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.go(resolveJourneyRoute(state.profile.journeyChoice));
            } else if (state is AuthError && state.message.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  Text(
                    'How are you starting\nyour fitness journey?',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose the path that fits you right now.\nYou can always change later.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  JourneyOptionCard(
                    icon: Icons.person_outline_rounded,
                    title: "I'm Starting Alone",
                    description:
                        'Track workouts, build your consistency, and join a squad anytime.',
                    buttonLabel: 'Continue Solo',
                    onPressed: () => _chooseJourney(context, 'solo'),
                  ),
                  const SizedBox(height: 16),
                  JourneyOptionCard(
                    icon: Icons.groups_outlined,
                    title: "I'm Joining Friends",
                    description:
                        'Compete together, earn Division Score, and climb weekly divisions.',
                    buttonLabel: 'Join / Create Squad',
                    onPressed: () => _chooseJourney(context, 'squad'),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
