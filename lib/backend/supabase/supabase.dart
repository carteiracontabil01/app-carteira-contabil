import 'package:supabase_flutter/supabase_flutter.dart';
import '/config/runtime_secrets.dart';

export 'database/database.dart';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();
  static String get supabaseUrl => RuntimeSecrets.supabaseUrl;
  static String get supabaseAnonKey => RuntimeSecrets.supabaseAnonKey;

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() {
    RuntimeSecrets.validateSupabaseConfig();
    return Supabase.initialize(
      url: supabaseUrl,
      headers: {
        'X-Client-Info': 'carteira-contabil-app',
      },
      anonKey: supabaseAnonKey,
      debug: false,
      authOptions:
          FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
    );
  }
}
