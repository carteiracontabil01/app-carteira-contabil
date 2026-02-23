import 'package:supabase_flutter/supabase_flutter.dart';

export 'database/database.dart';

// Configuração do Supabase - Carteira Contábil
String _kSupabaseUrl = 'https://mzazdlelnaarvfnertjd.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16YXpkbGVsbmFhcnZmbmVydGpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY2MTg5NzQsImV4cCI6MjA2MjE5NDk3NH0.gUaEgPX5WBlzY87ZmMuL26A0zaKRfI-s4nm3CEu_Yyc';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'carteira-contabil-app',
        },
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
