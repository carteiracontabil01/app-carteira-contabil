class RuntimeSecrets {
  RuntimeSecrets._();

  static const String _supabaseUrlRaw =
      String.fromEnvironment('SUPABASE_URL');
  static const String _supabaseAnonKeyRaw =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static const String firebaseWebApiKey =
      String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const String firebaseWebAuthDomain =
      String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
  static const String firebaseWebProjectId =
      String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
  static const String firebaseWebStorageBucket =
      String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET');
  static const String firebaseWebMessagingSenderId =
      String.fromEnvironment('FIREBASE_WEB_MESSAGING_SENDER_ID');
  static const String firebaseWebAppId =
      String.fromEnvironment('FIREBASE_WEB_APP_ID');

  static String get supabaseUrl {
    final value = _supabaseUrlRaw.trim();
    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }
    return value;
  }

  static String get supabaseAnonKey => _supabaseAnonKeyRaw.trim();

  static bool get hasFirebaseWebConfig =>
      firebaseWebApiKey.isNotEmpty &&
      firebaseWebAuthDomain.isNotEmpty &&
      firebaseWebProjectId.isNotEmpty &&
      firebaseWebStorageBucket.isNotEmpty &&
      firebaseWebMessagingSenderId.isNotEmpty &&
      firebaseWebAppId.isNotEmpty;

  static void validateSupabaseConfig() {
    final missing = <String>[];
    if (supabaseUrl.isEmpty) {
      missing.add('SUPABASE_URL');
    }
    if (supabaseAnonKey.isEmpty) {
      missing.add('SUPABASE_ANON_KEY');
    }

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required --dart-define values: ${missing.join(', ')}',
      );
    }

    if (!supabaseUrl.startsWith('https://')) {
      throw StateError('SUPABASE_URL must start with https://');
    }
  }
}
