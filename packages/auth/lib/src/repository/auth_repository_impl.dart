import 'dart:async';
import 'package:database_client/database_client.dart';
import '../models/user_profile.dart';
import 'auth_repository.dart';

/// Implementation of [AuthRepository] using the [DatabaseClient] (Supabase).
class AuthRepositoryImpl implements AuthRepository {
  final DatabaseClient _dbClient;
  final StreamController<UserProfile?> _authStateController = StreamController<UserProfile?>.broadcast();
  UserProfile? _currentUserProfile;
  StreamSubscription? _authSubscription;

  AuthRepositoryImpl(this._dbClient) {
    // Listen to Supabase auth state changes and update the controller.
    _authSubscription = _dbClient.client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      final user = session?.user;
      if (user == null) {
        _currentUserProfile = null;
        _authStateController.add(null);
      } else {
        final profile = await fetchUserProfile(user.id);
        _currentUserProfile = profile;
        _authStateController.add(profile);
      }
    });
  }

  @override
  Stream<UserProfile?> get authStateChanges => _authStateController.stream;

  @override
  UserProfile? get currentUserProfile => _currentUserProfile;

  @override
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _dbClient.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Sign up failed: User is null');
      }

      // Return a temporary user profile (with input fields) since the DB trigger runs asynchronously
      return UserProfile(
        id: user.id,
        fullName: fullName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfile> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dbClient.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Log in failed: User is null');
      }

      final profile = await fetchUserProfile(user.id);
      if (profile == null) {
        throw Exception('User profile not found after login');
      }

      _currentUserProfile = profile;
      return profile;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _dbClient.client.auth.signOut();
    _currentUserProfile = null;
  }

  @override
  Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      final data = await _dbClient.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;
      return UserProfile.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Cleans up resources.
  void dispose() {
    _authSubscription?.cancel();
    _authStateController.close();
  }
}
