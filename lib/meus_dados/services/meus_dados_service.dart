import '/app_state.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/auth/supabase_auth/supabase_user_provider.dart';
import '/backend/supabase/supabase.dart';
import '/meus_dados/formatters/profile_input_formatters.dart';
import '/meus_dados/models/profile_form_data.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class MeusDadosService {
  MeusDadosService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const String _avatarBucket = 'carteiracontabil';
  static const int _signedUrlTtlSeconds = 31536000; // 365 dias

  ProfileFormData loadFromCurrentUser() {
    final appState = FFAppState();
    final companyUser = appState.companyUserProfile;
    final user = _client.auth.currentUser;
    final metadata = (user?.userMetadata ?? <String, dynamic>{})
        .map((key, value) => MapEntry(key.toString(), value));

    final fullName = ((companyUser?['name'] ??
                metadata['display_name'] ??
                metadata['full_name'] ??
                metadata['name'] ??
                currentUserDisplayName))
            ?.toString() ??
        '';
    final phone =
        ((companyUser?['phone'] ?? metadata['phone'] ?? currentPhoneNumber))
                ?.toString() ??
            '';
    final hasCompanyUserImageField =
        companyUser != null && companyUser.containsKey('profile_img_url');
    final imageSource = hasCompanyUserImageField
        ? companyUser['profile_img_url']
        : (metadata['image_url'] ?? metadata['avatar_url'] ?? currentUserPhoto);
    final imageUrl = imageSource?.toString() ?? '';
    final email = ((companyUser?['email'] ?? user?.email ?? currentUserEmail))
            ?.toString() ??
        '';

    return ProfileFormData(
      fullName: fullName,
      email: email,
      phone: formatPhoneWithDynamicMask(phone),
      imageUrl: imageUrl.trim().isEmpty || imageUrl.trim() == 'null'
          ? null
          : imageUrl.trim(),
    );
  }

  Future<void> saveProfile(ProfileFormData profile) async {
    final appState = FFAppState();
    final companyUserId = appState.companyUserId;
    if (companyUserId != null && companyUserId.isNotEmpty) {
      final response = await _client.rpc(
        'rpc_update_company_user_profile_app',
        params: {
          'p_company_user_id': companyUserId,
          'p_name': profile.fullName,
          'p_phone': profile.phone,
          'p_profile_img_url': profile.imageUrl,
        },
      );
      if (response is Map) {
        appState.setCompanyUserProfile(Map<String, dynamic>.from(response));
      }
    }

    // Sincronização com auth metadata não deve quebrar o fluxo principal
    // (company_users já foi atualizado via RPC).
    try {
      await _client.auth.updateUser(
        UserAttributes(
          data: <String, dynamic>{
            'display_name': profile.fullName,
            'phone': profile.phone,
            'image_url': profile.imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          },
        ),
      );
      await _syncAuthUserInMemory();
    } catch (_) {
      // Não bloqueante: mantém sucesso para o usuário quando RPC já concluiu.
    }
  }

  Future<String> uploadAvatar({
    required String companyUserId,
    required Uint8List fileBytes,
    String fileExtension = 'jpg',
  }) async {
    final storageCompanyFolder = await _resolveStorageCompanyFolder();
    if (storageCompanyFolder.isEmpty) {
      throw Exception('Company cnpj not available for storage path');
    }

    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}_$companyUserId.$fileExtension';
    final storagePath =
        '$storageCompanyFolder/app_profile/$companyUserId/$fileName';

    await _client.storage.from(_avatarBucket).uploadBinary(
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

    return _client.storage.from(_avatarBucket).createSignedUrl(
          storagePath,
          _signedUrlTtlSeconds,
        );
  }

  Future<String> _resolveStorageCompanyFolder() async {
    final appState = FFAppState();
    final companyProfile = appState.companyProfile;
    final companyUser = appState.companyUserProfile;

    String sanitize(String? value) =>
        (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');

    final fromProfile = sanitize(companyProfile?['cnpj']?.toString());
    if (fromProfile.isNotEmpty) return fromProfile;

    final fromCompanyUser = sanitize(companyUser?['company_cnpj']?.toString());
    if (fromCompanyUser.isNotEmpty) return fromCompanyUser;

    final companyId = appState.companyId;
    if (companyId != null && companyId.isNotEmpty) {
      try {
        final fallback = await _client.rpc(
          'rpc_get_company_profile_app',
          params: {'p_company_id': companyId},
        );
        if (fallback is Map) {
          final value = sanitize(fallback['cnpj']?.toString());
          if (value.isNotEmpty) return value;
        }
      } catch (_) {}
    }

    return '';
  }

  Future<void> _syncAuthUserInMemory() async {
    final refreshed = await _client.auth.refreshSession();
    final updatedUser = refreshed.user ?? _client.auth.currentUser;
    if (updatedUser != null) {
      currentUser = DeliverySupabaseUser(updatedUser);
    }
  }
}
