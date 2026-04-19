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
      return;
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    // O Firebase já foi inicializado no main.dart
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      criticalAlert: true,
    );

    FFAppState().fcmToken = "Verificando permissões de notificação...";

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      FFAppState().fcmToken = "Permissões autorizadas, obtendo token...";

      try {
        String? fcmToken = await messaging.getToken();

        if (fcmToken != null && fcmToken.isNotEmpty) {
          FFAppState().fcmToken = fcmToken;

          // Salvar token no banco (tabela users)
          await _saveFCMTokenToDatabase(fcmToken);
        } else {
          FFAppState().fcmToken = "Token FCM não disponível";
        }
      } catch (e) {
        FFAppState().fcmToken = "Erro ao obter token: $e";
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      FFAppState().fcmToken = "Permissões de notificação negadas";
    } else {
      FFAppState().fcmToken =
          "Status de permissão: ${settings.authorizationStatus}";
    }

    // Listener para token refresh (quando token muda)
    messaging.onTokenRefresh.listen((newToken) {
      FFAppState().fcmToken = newToken;
      _saveFCMTokenToDatabase(newToken);
    });
  } catch (e) {
    FFAppState().fcmToken = "Erro na configuração FCM: $e";
  }
}

/// Salva o FCM token no banco de dados
Future<void> _saveFCMTokenToDatabase(String token) async {
  try {
    final userId = currentUserUid;

    if (userId == null || userId.isEmpty) {
      return;
    }

    await Supabase.instance.client
        .from('users')
        .update({'fcm_token': token}).eq('id', userId);
  } catch (e) {
    // Erro não-bloqueante: token pode ser salvo em tentativa futura.
  }
}
