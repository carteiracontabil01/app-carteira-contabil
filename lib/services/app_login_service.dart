import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/app_state.dart';
import '/services/company_profile_service.dart';
import '/services/company_user_profile_service.dart';

/// Resultado da validação de login do app
class AppLoginValidationResult {
  final bool success;
  final String? companyUserId;
  final String? companyId;
  final String? companyName;
  final String? errorMessage;

  const AppLoginValidationResult({
    required this.success,
    this.companyUserId,
    this.companyId,
    this.companyName,
    this.errorMessage,
  });
}

/// Serviço para validar se o usuário tem permissão para acessar o app.
/// Verifica: role APP_ONLY, company_users.status=active, companies.status=active
class AppLoginService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Valida o login do usuário autenticado e retorna company_user_id e company_id
  /// se tiver permissão (role APP_ONLY, status active).
  static Future<AppLoginValidationResult> validateAppLogin(
    String authUserId,
  ) async {
    try {
      final response = await _supabase.rpc(
        'validate_login',
        params: {'p_auth_user_id': authUserId},
      );

      if (response == null) {
        return const AppLoginValidationResult(
          success: false,
          errorMessage: 'Erro ao validar permissão de acesso.',
        );
      }

      final data = Map<String, dynamic>.from(response as Map);

      if (data['success'] != true) {
        final errorMsg = data['error'] as String? ??
            'Usuário sem permissão para acessar o aplicativo.';
        return AppLoginValidationResult(
          success: false,
          errorMessage: errorMsg,
        );
      }

      final companyUserId = data['company_user_id']?.toString();
      final companyId = data['company_id']?.toString();
      final companyName = data['company_name']?.toString();

      if (companyUserId == null || companyId == null) {
        return const AppLoginValidationResult(
          success: false,
          errorMessage: 'Dados inválidos retornados do servidor.',
        );
      }

      return AppLoginValidationResult(
        success: true,
        companyUserId: companyUserId,
        companyId: companyId,
        companyName: companyName,
      );
    } catch (e) {
      return AppLoginValidationResult(
        success: false,
        errorMessage: 'Erro ao validar permissão. Tente novamente.',
      );
    }
  }

  /// Faz login completo: valida auth, chama validate_app_login, salva no app state
  /// Retorna true se sucesso, false caso contrário (exibe mensagem via ScaffoldMessenger)
  static Future<bool> validateAndSaveCompanyContext(
    BuildContext context,
    String authUserId,
  ) async {
    final result = await validateAppLogin(authUserId);

    if (!result.success) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Erro ao validar acesso'),
            backgroundColor: Colors.red[700],
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return false;
    }

    // Salvar no app state (IDs e nome da empresa já vêm do validate_login)
    final appState = FFAppState();
    appState.setCompanyContext(
      result.companyUserId!,
      result.companyId!,
      result.companyName,
    );

    await CompanyUserProfileService.refreshIntoAppState(
      companyUserId: result.companyUserId!,
    );

    await CompanyProfileService.refreshIntoAppState(
      companyId: result.companyId!,
      companyUserId: result.companyUserId!,
    );

    return true;
  }
}
