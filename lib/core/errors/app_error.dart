/// Base exception class for all errors in the Zevo application.
abstract class AppError implements Exception {
  final String message;
  final dynamic originalException;

  AppError(this.message, [this.originalException]);

  @override
  String toString() => message;
}

/// Authentication-related errors.
class AuthError extends AppError {
  AuthError(super.message, [super.originalException]);
}

/// Network-related/connectivity errors.
class NetworkError extends AppError {
  NetworkError(super.message, [super.originalException]);
}

/// Database-related errors (e.g. Supabase, PostgreSQL).
class DatabaseError extends AppError {
  DatabaseError(super.message, [super.originalException]);
}

/// Validation-related errors (e.g. input forms validation).
class ValidationError extends AppError {
  ValidationError(super.message, [super.originalException]);
}

/// Squad-related business logic errors.
class SquadError extends AppError {
  SquadError(super.message, [super.originalException]);
}

/// Workout-related business logic errors.
class WorkoutError extends AppError {
  WorkoutError(super.message, [super.originalException]);
}
