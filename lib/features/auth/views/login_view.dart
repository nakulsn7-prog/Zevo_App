import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_input_field.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.go('/authenticated');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is Authenticating;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthInputField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                AuthInputField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                AuthButton(
                  label: 'Continue',
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            ),
                          );
                        },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      context.go('/signup'),
                  child: const Text('Create Account'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
