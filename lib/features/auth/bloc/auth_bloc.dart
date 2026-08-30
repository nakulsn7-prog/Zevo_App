import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:auth/auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    // Subscribe to auth state changes from Supabase
    _authRepository.authStateChanges.listen((profile) {
      add(AuthStateChanged(profile != null));
    });

    on<CheckAuthSession>((event, emit) async {
      emit(const AuthCheckingSession());
      try {
        // Check live Supabase session — works correctly on cold start
        final session = _authRepository is AuthRepositoryImpl
            ? await (_authRepository as AuthRepositoryImpl).hasActiveSession()
            : _authRepository.currentUserProfile != null;
        if (session) {
          emit(const Authenticated());
        } else {
          emit(const Unauthenticated());
        }
      } catch (_) {
        emit(const Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(const Authenticating());
      try {
        await _authRepository.logIn(email: event.email, password: event.password);
        emit(const Authenticated());
      } catch (e) {
        // Print full error for debugging
        // ignore: avoid_print
        print('[AuthBloc] Login error: $e');
        // Extract clean message (strip Exception("...") wrapper if present)
        final raw = e.toString();
        final msg = raw.startsWith('Exception: ') ? raw.substring(11) : raw;
        emit(AuthError(msg));
      }
    });

    on<SignupRequested>((event, emit) async {
      emit(const Authenticating());
      try {
        await _authRepository.signUp(email: event.email, password: event.password, fullName: event.fullName);
        // After successful signup, automatically log in
        await _authRepository.logIn(email: event.email, password: event.password);
        emit(const Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(const LoggingOut());
      await _authRepository.logOut();
      emit(const Unauthenticated());
    });

    on<AuthStateChanged>((event, emit) {
      if (event.isAuthenticated) {
        emit(const Authenticated());
      } else {
        emit(const Unauthenticated());
      }
    });
  }
}
