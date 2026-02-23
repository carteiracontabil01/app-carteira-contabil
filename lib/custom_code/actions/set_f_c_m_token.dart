// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

// Begin custom action code
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

Future setFCMToken() async {
  try {
    // ⚠️ FCM Token só deve ser configurado em MOBILE (Android/iOS)
    if (kIsWeb) {
      print('🌐 Plataforma WEB detectada - FCM Token ignorado');
      return;
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      print('💻 Plataforma Desktop detectada - FCM Token ignorado');
      return;
    }

    print('📱 Plataforma MOBILE detectada - Configurando FCM Token...');

    // O Firebase já foi inicializado no main.dart
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    print('📱 Solicitando permissões de notificação...');
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      criticalAlert: true,
    );

    FFAppState().fcmToken = "Verificando permissões de notificação...";
    print('✅ Status das permissões: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      FFAppState().fcmToken = "Permissões autorizadas, obtendo token...";
      print('🔑 Permissões autorizadas, obtendo FCM token...');

      try {
        String? fcmToken = await messaging.getToken();

        if (fcmToken != null && fcmToken.isNotEmpty) {
          FFAppState().fcmToken = fcmToken;
          print('✅ FCM Token obtido: ${fcmToken.substring(0, 30)}...');

          // Salvar token no banco (tabela users)
          await _saveFCMTokenToDatabase(fcmToken);
        } else {
          FFAppState().fcmToken = "Token FCM não disponível";
          print('⚠️  FCM Token não disponível');
        }
      } catch (e) {
        FFAppState().fcmToken = "Erro ao obter token: $e";
        print('❌ Erro ao obter FCM token: $e');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      FFAppState().fcmToken = "Permissões de notificação negadas";
      print('❌ Permissões de notificação negadas pelo usuário');
    } else {
      FFAppState().fcmToken =
          "Status de permissão: ${settings.authorizationStatus}";
      print('⚠️  Status de permissão: ${settings.authorizationStatus}');
    }

    // Listener para token refresh (quando token muda)
    messaging.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token atualizado: ${newToken.substring(0, 30)}...');
      FFAppState().fcmToken = newToken;
      _saveFCMTokenToDatabase(newToken);
    });
  } catch (e) {
    FFAppState().fcmToken = "Erro na configuração FCM: $e";
    print('❌ Erro geral na configuração FCM: $e');
  }
}

/// Salva o FCM token no banco de dados
Future<void> _saveFCMTokenToDatabase(String token) async {
  try {
    final userId = currentUserUid;

    if (userId == null || userId.isEmpty) {
      print('⚠️  Usuário não autenticado, não pode salvar FCM token');
      return;
    }

    await Supabase.instance.client
        .from('users')
        .update({'fcm_token': token}).eq('id', userId);

    print('✅ FCM Token salvo no banco de dados');
  } catch (e) {
    print('❌ Erro ao salvar FCM token no banco: $e');
  }
}
