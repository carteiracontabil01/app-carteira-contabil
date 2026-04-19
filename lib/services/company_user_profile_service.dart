import '/app_state.dart';
import '/backend/supabase/supabase.dart';

class CompanyUserProfileService {
  static final _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>?> fetchCompanyUserProfile({
    required String companyUserId,
  }) async {
    if (companyUserId.isEmpty) return null;
    try {
      final response = await _supabase.rpc(
        'rpc_get_company_user_profile_app',
        params: {
          'p_company_user_id': companyUserId,
        },
      );

      if (response == null) return null;
      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> refreshIntoAppState({
    required String companyUserId,
  }) async {
    final appState = FFAppState();
    final row = await fetchCompanyUserProfile(companyUserId: companyUserId);
    if (appState.companyUserId != companyUserId) return;
    appState.setCompanyUserProfile(row);
  }
}
