import '../models/user_profile.dart';

/// Repository interface for managing authentication and user profiles in Zevo.
abstract class AuthRepository {
  /// Stream of authentication state changes.
  Stream<UserProfile?> get authStateChanges;

  /// Gets the currently authenticated user's profile, if any.
  UserProfile? get currentUserProfile;

  /// Signs up a user with email, password, and full name.
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  /// Logs in a user with email and password.
  Future<UserProfile> logIn({
    required String email,
    required String password,
  });

  /// Logs out the current user.
  Future<void> logOut();

  /// Fetches the user profile for a given user ID.
  Future<UserProfile?> fetchUserProfile(String userId);
}
