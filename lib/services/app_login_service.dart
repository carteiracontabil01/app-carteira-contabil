import 'dart:convert';

import 'package:flutter/material.dart';
import '/backend/supabase/supabase.dart';
import '/app_state.dart';

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
      print('🔐 Validando login para auth_user_id: $authUserId');

      final response = await _supabase.rpc(
        'validate_login',
        params: {'p_auth_user_id': authUserId},
      );

      if (response == null) {
        print('❌ validate_login retornou null');
        return const AppLoginValidationResult(
          success: false,
          errorMessage: 'Erro ao validar permissão de acesso.',
        );
      }

      final data = Map<String, dynamic>.from(response as Map);
      print('📋 Resposta validate_login: $data');

      if (data['success'] != true) {
        final errorMsg = data['error'] as String? ??
            'Usuário sem permissão para acessar o aplicativo.';
        print('❌ Validação falhou: $errorMsg');
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
      print('❌ Erro ao validar login do app: $e');
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

    return true;
  }

  /// Lista empresas que o usuário pode acessar (para troca de empresa)
  static Future<List<Map<String, String>>> getUserCompanies(String authUserId) async {
    try {
      print('📋 getUserCompanies chamado com authUserId: $authUserId');
      final response = await _supabase.rpc(
        'get_user_companies',
        params: {'p_auth_user_id': authUserId},
      );
      print('📋 get_user_companies resposta: tipo=${response.runtimeType}');
      if (response == null) {
        print('📋 get_user_companies retornou null');
        return [];
      }

      List<dynamic> list;
      if (response is List) {
        list = response;
        print('📋 get_user_companies: lista com ${list.length} itens');
      } else if (response is String) {
        final decoded = jsonDecode(response);
        list = decoded is List ? decoded : [];
        print('📋 get_user_companies: parseado de String, ${list.length} itens');
      } else if (response is Map && response.containsKey('company_id')) {
        list = [response];
        print('📋 get_user_companies: único objeto em Map');
      } else if (response is Map) {
        final data = response['data'];
        list = data is List ? data : [];
        print('📋 get_user_companies: Map com chave data, ${list.length} itens');
      } else {
        print('📋 get_user_companies: formato não tratado, response=$response');
        return [];
      }

      final result = list.map((e) {
        final m = e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{};
        return {
          'company_id': m['company_id']?.toString() ?? '',
          'company_user_id': m['company_user_id']?.toString() ?? '',
          'business_name': m['business_name']?.toString() ?? '',
        };
      }).toList();
      print('📋 getUserCompanies retornando ${result.length} empresas');
      return result;
    } catch (e, st) {
      print('❌ Erro ao listar empresas do usuário: $e');
      print('❌ Stack: $st');
      return [];
    }
  }
}
