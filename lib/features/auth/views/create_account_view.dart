import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_input_field.dart';
class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showTermsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Terms & Conditions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: const _TermsContent(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        setState(() => _termsAccepted = true);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('I Accept'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthInputField(
                    controller: _fullNameController,
                    hintText: 'Full Name',
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  AuthInputField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showTermsBottomSheet(context),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                const TextSpan(text: 'I accept the '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AuthButton(
                    label: 'Create Account',
                    isLoading: isLoading,
                    onPressed: isLoading || !_termsAccepted
                        ? null
                        : () {
                            if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                ),
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                              SignupRequested(
                                fullName: _fullNameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                          },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () =>
                        context.go('/login'),
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

  @override
  Widget build(BuildContext context) {
    final headingStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
    const bodyStyle = TextStyle(height: 1.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last updated: August 2026', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),

        Text('1. Acceptance of Terms', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'By creating a ZEVO account, you agree to these Terms & Conditions and our Privacy Policy. '
          'If you do not agree, please do not use ZEVO.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('2. Eligibility', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'You must be at least 16 years old to use ZEVO. By registering, you confirm that you meet this requirement.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('3. Your Account', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'You are responsible for maintaining the confidentiality of your login credentials. '
          'You agree to provide accurate and up-to-date information during registration and to notify us '
          'immediately of any unauthorised use of your account.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('4. Use of the App', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'ZEVO is a fitness and community platform. You agree to use it only for lawful purposes and not to:\n'
          '• Post offensive, misleading, or harmful content.\n'
          '• Attempt to gain unauthorised access to other accounts.\n'
          '• Use automated bots or scrapers on the platform.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('5. Health Disclaimer', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'ZEVO provides fitness tracking and workout tools for informational purposes only. '
          'Always consult a qualified healthcare professional before starting any new exercise programme. '
          'ZEVO is not responsible for any injury or health issue arising from use of the app.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('6. Privacy', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'We collect and process personal data in accordance with our Privacy Policy. '
          'We do not sell your personal data to third parties.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('7. Intellectual Property', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'All content, branding, and features of ZEVO are the intellectual property of ZEVO and its licensors. '
          'You may not copy, modify, or distribute any part of the app without written permission.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('8. Termination', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'We reserve the right to suspend or terminate your account at any time if you violate these terms '
          'or engage in conduct that harms other users or the platform.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('9. Changes to Terms', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'We may update these Terms & Conditions from time to time. Continued use of the app after changes '
          'are posted constitutes your acceptance of the revised terms.',
          style: bodyStyle,
        ),
        const SizedBox(height: 16),

        Text('10. Contact', style: headingStyle),
        const SizedBox(height: 6),
        const Text(
          'For questions about these Terms, contact us at support@zevo.app.',
          style: bodyStyle,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
