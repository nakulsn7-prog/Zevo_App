import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState { const AuthInitial(); }

class AuthCheckingSession extends AuthState { const AuthCheckingSession(); }

class Unauthenticated extends AuthState { const Unauthenticated(); }

class Authenticating extends AuthState { const Authenticating(); }

class Authenticated extends AuthState { const Authenticated(); }

class SignupSuccess extends AuthState { const SignupSuccess(); }

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoggingOut extends AuthState { const LoggingOut(); }
