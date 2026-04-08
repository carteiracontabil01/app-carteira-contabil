import 'dart:convert';

import '/app_state.dart';
import '/backend/supabase/supabase.dart';

/// Carrega [api.vw_company_by_id] via RPC e atualiza [FFAppState].
class CompanyProfileService {
  static final _supabase = Supabase.instance.client;

  /// Busca o JSON da view (null se sem permissão ou sem linha).
  static Future<Map<String, dynamic>?> fetchCompanyProfile({
    required String companyId,
    required String companyUserId,
  }) async {
    if (companyId.isEmpty || companyUserId.isEmpty) return null;
    try {
      final response = await _supabase.rpc(
        'fn_get_company_profile_view',
        params: {
          'p_company_id': companyId,
          'p_company_user_id': companyUserId,
        },
      );
      if (response == null) return null;
      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      if (response is String && response.isNotEmpty) {
        final decoded = jsonDecode(response);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }
      return null;
    } catch (e) {
      print('⚠️ CompanyProfileService.fetchCompanyProfile: $e');
      return null;
    }
  }

  /// Atualiza o app state se ainda for a mesma empresa (evita corrida ao trocar tenant rápido).
  static Future<void> refreshIntoAppState({
    required String companyId,
    required String companyUserId,
  }) async {
    final appState = FFAppState();
    final row = await fetchCompanyProfile(
      companyId: companyId,
      companyUserId: companyUserId,
    );
    if (appState.companyId != companyId) return;
    appState.setCompanyProfile(row);
  }
}
