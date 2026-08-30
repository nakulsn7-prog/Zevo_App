import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthSession extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  const SignupRequested({required this.fullName, required this.email, required this.password});

  @override
  List<Object?> get props => [fullName, email, password];
}

class LogoutRequested extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final bool isAuthenticated;

  const AuthStateChanged(this.isAuthenticated);

  @override
  List<Object?> get props => [isAuthenticated];
}
