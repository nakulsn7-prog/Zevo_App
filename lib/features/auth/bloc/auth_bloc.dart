import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:auth/auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitial()) {
    // Subscribe to auth state changes from Supabase
    _authRepository.authStateChanges.listen((profile) {
      add(AuthStateChanged(profile));
    });

    on<CheckAuthSession>((event, emit) async {
      emit(const AuthCheckingSession());
      try {
        // Check live Supabase session — works correctly on cold start
        final session = _authRepository is AuthRepositoryImpl
            ? await (_authRepository as AuthRepositoryImpl).hasActiveSession()
            : _authRepository.currentUserProfile != null;
        if (session) {
          final profile = _authRepository.currentUserProfile;
          // The auth-state subscription also emits Authenticated(profile) with
          // the fetched profile on cold start; prefer it when already loaded.
          if (profile != null) {
            emit(Authenticated(profile));
          }
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
        final profile = await _authRepository.logIn(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated(profile));
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
        final profile = await _authRepository.logIn(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated(profile));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(const LoggingOut());
      await _authRepository.logOut();
      emit(const Unauthenticated());
    });

    on<SetJourneyChoice>((event, emit) async {
      final currentProfile = _authRepository.currentUserProfile;
      if (currentProfile == null) {
        emit(const AuthError('You must be signed in to choose a journey.'));
        return;
      }
      if (event.choice != 'solo' && event.choice != 'squad') {
        emit(const AuthError('Invalid journey choice.'));
        return;
      }
      try {
        await _authRepository.setJourneyChoice(currentProfile.id, event.choice);
        emit(Authenticated(_authRepository.currentUserProfile ?? currentProfile));
      } catch (_) {
        emit(const AuthError('Could not save your journey choice. Please try again.'));
      }
    });

    on<AuthStateChanged>((event, emit) {
      if (event.profile != null) {
        emit(Authenticated(event.profile!));
      } else {
        emit(const Unauthenticated());
      }
    });
  }
}
