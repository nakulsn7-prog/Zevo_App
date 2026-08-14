/// Configuration class for Zevo environment variables.
class AppConfig {
  /// The URL of the Supabase backend.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://dkroghcqwzdrdflqouqu.supabase.co',
  );

  /// The public anonymous key for the Supabase API.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Validates that the configurations are not empty.
  static void validate() {
    if (supabaseUrl.isEmpty) {
      throw StateError('SUPABASE_URL is missing. Please define it using --dart-define or config files.');
    }
    if (supabaseAnonKey.isEmpty) {
      throw StateError('SUPABASE_ANON_KEY is missing. Please define it using --dart-define or config files.');
    }
  }
}
