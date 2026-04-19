// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

// Begin custom action code
import 'package:firebase_messaging/firebase_messaging.dart';
import '/flutter_flow/nav/nav.dart';
import 'index.dart'; // Imports setFCMToken and onPushNotificationOpened
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Variável global para controlar se já foi inicializado
bool _pushNotificationsInitialized = false;

Future inicializarPushNotificationsSeguro() async {
  // ⚠️ Push notifications só devem ser configuradas em MOBILE (Android/iOS)
  if (kIsWeb) {
    return;
  }

  if (!Platform.isAndroid && !Platform.isIOS) {
    return;
  }

  // Evita múltiplas inicializações
  if (_pushNotificationsInitialized) {
    return;
  }

  try {
    // Aguarda um tempo para garantir que o app esteja pronto
    await Future.delayed(Duration(milliseconds: 1000));

    // Verifica se o contexto está disponível
    if (appNavigatorKey.currentContext == null) {
      // Agenda nova tentativa após delay maior
      Future.delayed(Duration(seconds: 3), () async {
        if (!_pushNotificationsInitialized) {
          await _tentarInicializarComRetry();
        }
      });
      return;
    }

    // Se chegou aqui, o contexto está disponível
    await _executarInicializacao();
  } catch (e) {
    // Tenta novamente após um delay
    Future.delayed(Duration(seconds: 5), () async {
      if (!_pushNotificationsInitialized) {
        await _tentarInicializarComRetry();
      }
    });
  }
}

Future _tentarInicializarComRetry() async {
  int tentativas = 0;
  const maxTentativas = 5;

  while (tentativas < maxTentativas && !_pushNotificationsInitialized) {
    tentativas++;

    try {
      // Aguarda progressivamente mais tempo a cada tentativa
      await Future.delayed(Duration(seconds: tentativas * 2));

      if (appNavigatorKey.currentContext != null) {
        await _executarInicializacao();
        break;
      }
    } catch (e) {}
  }
}

Future _executarInicializacao() async {
  // Primeiro configura os listeners
  await onPushNotificationOpened();

  // Depois configura o FCM token
  await setFCMToken();

  _pushNotificationsInitialized = true;
}

/// Verifica se já foi inicializado (útil para debugging)
bool isPushNotificationsInitialized() {
  return _pushNotificationsInitialized;
}

/// Força reinicialização (útil para debugging)
Future reinicializarPushNotifications() async {
  _pushNotificationsInitialized = false;
  await inicializarPushNotificationsSeguro();
}
