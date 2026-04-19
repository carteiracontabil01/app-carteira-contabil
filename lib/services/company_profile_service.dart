import 'dart:convert';
import 'dart:typed_data';

import '/app_state.dart';
import '/backend/supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Carrega dados da company via RPC e atualiza [FFAppState].
class CompanyProfileService {
  static final _supabase = Supabase.instance.client;
  static const String _companyBucket = 'carteiracontabil';
  static const int _signedUrlTtlSeconds = 31536000; // 365 dias

  /// Busca o JSON no formato de `api.vw_company_by_id`.
  /// A RPC valida o usuário logado via auth.uid() e garante acesso apenas
  /// à empresa vinculada (inclusive quando usuário tem múltiplas companies).
  static Future<Map<String, dynamic>?> fetchCompanyProfile({
    required String companyId,
    required String companyUserId,
  }) async {
    if (companyId.isEmpty || companyUserId.isEmpty) return null;
    try {
      final response = await _supabase.rpc(
        'rpc_get_company_profile_app',
        params: {
          'p_company_id': companyId,
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

  static Future<String> uploadCompanyPhoto({
    required String companyId,
    required String cnpj,
    required Uint8List fileBytes,
    String fileExtension = 'jpg',
  }) async {
    final sanitizedCnpj = _sanitizeDigits(cnpj);
    if (sanitizedCnpj.isEmpty) {
      throw Exception('Company cnpj not available for storage path');
    }

    final fileName =
        'company_${DateTime.now().millisecondsSinceEpoch}_$companyId.$fileExtension';
    final storagePath = '$sanitizedCnpj/company_profile/$companyId/$fileName';

    await _supabase.storage.from(_companyBucket).uploadBinary(
          storagePath,
          fileBytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: switch (fileExtension.toLowerCase()) {
              'png' => 'image/png',
              'webp' => 'image/webp',
              _ => 'image/jpeg',
            },
          ),
        );

    return _supabase.storage.from(_companyBucket).createSignedUrl(
          storagePath,
          _signedUrlTtlSeconds,
        );
  }

  static Future<Map<String, dynamic>?> updateCompanyPhoto({
    required String companyId,
    required String? photoUrl,
  }) async {
    final response = await _supabase.rpc(
      'rpc_update_company_photo_url_app',
      params: {
        'p_company_id': companyId,
        'p_photo_url': photoUrl,
      },
    );

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return null;
  }

  static String _sanitizeDigits(String value) =>
      value.replaceAll(RegExp(r'[^0-9]'), '');
}
