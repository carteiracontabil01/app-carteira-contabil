import '/auth/supabase_auth/auth_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/services/app_login_service.dart';
import '/services/permission_service.dart';
import '/singin/login/models/auth_flow_results.dart';
import '/singin/login/models/sign_up_payload.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginFlowService {
  const LoginFlowService._();

  static Future<AuthFlowResult> loginWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final user = await authManager.signInWithEmail(
      context,
      email,
      password,
    );

    if (user == null || user.uid == null) {
      return const AuthFlowResult(success: false);
    }

    final hasAccess = await AppLoginService.validateAndSaveCompanyContext(
      context,
      user.uid!,
    );

    if (!hasAccess) {
      await authManager.signOut();
      return const AuthFlowResult(success: false);
    }

    try {
      await actions.setFCMToken();
    } catch (_) {
      // Erro não-bloqueante para fluxo de login.
    }

    return const AuthFlowResult(success: true);
  }

  static Future<SignUpFlowResult> signUpWithEmail({
    required BuildContext context,
    required SignUpPayload payload,
    required PermissionService permissionService,
  }) async {
    final user = await authManager.createAccountWithEmail(
      context,
      payload.email,
      payload.password,
    );

    if (user == null || user.uid == null) {
      return const SignUpFlowResult(success: false);
    }

    const showProfileWarning = false;

    try {
      await Supabase.instance.client.from('users').insert({
        'id': user.uid,
        'display_name': payload.fullName.trim(),
        'document': payload.cpf.replaceAll(RegExp(r'[^0-9]'), ''),
        'phone': payload.phone.replaceAll(RegExp(r'[^0-9]'), ''),
      });
    } catch (_) {
      // Não bloqueia o cadastro caso essa escrita falhe.
    }

    if (context.mounted) {
      await permissionService.requestAllCriticalPermissions(context);
    }

    try {
      await actions.setFCMToken();
    } catch (_) {
      // Erro não-bloqueante para fluxo de cadastro.
    }

    return SignUpFlowResult(
      success: true,
      showProfileWarning: showProfileWarning,
    );
  }

  static Future<AuthFlowResult> sendResetPasswordEmail({
    required BuildContext context,
    required String email,
    required String redirectTo,
  }) async {
    try {
      await authManager.resetPassword(
        email: email,
        context: context,
        redirectTo: redirectTo,
      );

      return const AuthFlowResult(
        success: true,
        message: 'E-mail enviado! Verifique sua caixa de entrada.',
      );
    } on AuthException catch (e) {
      if (e.message.contains('rate limit')) {
        return const AuthFlowResult(
          success: false,
          message: 'Muitas tentativas. Aguarde alguns minutos e tente novamente.',
        );
      }

      return const AuthFlowResult(
        success: false,
        message: 'Erro ao enviar e-mail de recuperação',
      );
    } catch (_) {
      return const AuthFlowResult(
        success: false,
        message: 'Erro ao enviar e-mail de recuperação',
      );
    }
  }
}
