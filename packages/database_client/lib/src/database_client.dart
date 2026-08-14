import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized database client that wraps the Supabase initialization and client instance.
class DatabaseClient {
  /// The underlying Supabase client instance.
  final SupabaseClient client;

  DatabaseClient(this.client);

  /// Initializes Supabase with the provided URL and anon key.
  static Future<DatabaseClient> initialize({
    required String url,
    required String anonKey,
  }) async {
    final supabase = await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    return DatabaseClient(supabase.client);
  }
}
