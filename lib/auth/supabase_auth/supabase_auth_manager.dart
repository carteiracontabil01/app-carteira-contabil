import 'dart:async';

import 'package:flutter/material.dart';
import '/auth/auth_manager.dart';
import '/app_state.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'email_auth.dart';

import 'supabase_user_provider.dart';

export '/auth/base_auth_user_provider.dart';

class SupabaseAuthManager extends AuthManager with EmailSignInManager {
  @override
  Future signOut() async {
    FFAppState().clearCompanyContext();
    return SupaFlow.client.auth.signOut();
  }

  @override
  Future deleteUser(BuildContext context) async {
    try {
      if (!loggedIn) {
        return;
      }
      await currentUser?.delete();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message}')),
      );
    }
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        return;
      }
      await currentUser?.updateEmail(email);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message}')),
      );
      return;
    }
    // Não exibir snackbar aqui - será exibido no alterar_email_widget
  }

  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        return;
      }
      await currentUser?.updatePassword(newPassword);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message}')),
      );
      return;
    }
    // Não exibir snackbar aqui - será exibido no widget
  }

  @override
  Future resetPassword({
    required String email,
    required BuildContext context,
    String? redirectTo,
  }) async {
    try {
      await SupaFlow.client.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
    } on AuthException {
      // Lançar exceção para ser tratada na camada superior
      rethrow;
    }
    // Não exibir snackbar aqui - será exibido no login_widget
  }

  /// Traduz mensagens de erro do Supabase para português
  String _translateAuthError(String errorMessage) {
    final message = errorMessage.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials') ||
        message.contains('wrong password') ||
        message.contains('incorrect password')) {
      return 'E-mail ou senha incorretos';
    }

    if (message.contains('user already registered') ||
        message.contains('email already exists') ||
        message.contains('already registered')) {
      return 'Este e-mail já está em uso por outra conta';
    }

    if (message.contains('user not found') ||
        message.contains('email not found')) {
      return 'Usuário não encontrado';
    }

    if (message.contains('invalid email') ||
        message.contains('email is invalid')) {
      return 'E-mail inválido';
    }

    if (message.contains('password is too short') ||
        message.contains('password should be at least')) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }

    if (message.contains('password is too weak') ||
        message.contains('weak password')) {
      return 'Senha muito fraca. Use uma senha mais forte';
    }

    if (message.contains('too many requests') ||
        message.contains('rate limit') ||
        message.contains('too many attempts')) {
      return 'Muitas tentativas. Aguarde alguns minutos e tente novamente';
    }

    if (message.contains('email not confirmed') ||
        message.contains('email confirmation required')) {
      return 'E-mail não confirmado. Verifique sua caixa de entrada';
    }

    if (message.contains('token expired') ||
        message.contains('expired') ||
        message.contains('invalid token')) {
      return 'Link expirado. Solicite um novo e-mail de recuperação';
    }

    if (message.contains('network') ||
        message.contains('connection') ||
        message.contains('timeout')) {
      return 'Erro de conexão. Verifique sua internet';
    }

    return errorMessage;
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailSignInFunc(email, password),
      );

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailCreateAccountFunc(email, password),
      );

  /// Tries to sign in or create an account using Supabase Auth.
  /// Returns the User object if sign in was successful.
  Future<BaseAuthUser?> _signInOrCreateAccount(
    BuildContext context,
    Future<User?> Function() signInFunc,
  ) async {
    try {
      final user = await signInFunc();
      final authUser = user == null ? null : DeliverySupabaseUser(user);

      // Update currentUser here in case user info needs to be used immediately
      // after a user is signed in. This should be handled by the user stream,
      // but adding here too in case of a race condition where the user stream
      // doesn't assign the currentUser in time.
      if (authUser != null) {
        currentUser = authUser;
        AppStateNotifier.instance.update(authUser);
      }
      return authUser;
    } on AuthException catch (e) {
      // Traduzir mensagem de erro para português
      final errorMsg = _translateAuthError(e.message);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red[700],
          duration: Duration(seconds: 4),
        ),
      );
      return null;
    }
  }
}
