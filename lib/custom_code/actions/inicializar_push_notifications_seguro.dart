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
    print('🌐 Plataforma WEB detectada - Push notifications ignoradas');
    return;
  }

  if (!Platform.isAndroid && !Platform.isIOS) {
    print('💻 Plataforma Desktop detectada - Push notifications ignoradas');
    return;
  }

  // Evita múltiplas inicializações
  if (_pushNotificationsInitialized) {
    print('🔔 Push notifications já inicializadas');
    return;
  }

  print('🚀 Iniciando configuração segura de push notifications MOBILE...');

  try {
    // Aguarda um tempo para garantir que o app esteja pronto
    await Future.delayed(Duration(milliseconds: 1000));

    // Verifica se o contexto está disponível
    if (appNavigatorKey.currentContext == null) {
      print(
          '⚠️  Contexto não disponível na primeira tentativa, reagendando...');

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
    print('❌ Erro na inicialização segura: $e');

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
    print(
        '🔄 Tentativa $tentativas de $maxTentativas para inicializar push notifications');

    try {
      // Aguarda progressivamente mais tempo a cada tentativa
      await Future.delayed(Duration(seconds: tentativas * 2));

      if (appNavigatorKey.currentContext != null) {
        await _executarInicializacao();
        break;
      } else {
        print('⚠️  Contexto ainda não disponível na tentativa $tentativas');
      }
    } catch (e) {
      print('❌ Erro na tentativa $tentativas: $e');
    }
  }

  if (!_pushNotificationsInitialized) {
    print(
        '❌ Falha ao inicializar push notifications após $maxTentativas tentativas');
  }
}

Future _executarInicializacao() async {
  try {
    print('⚙️  Executando inicialização das push notifications...');

    // Primeiro configura os listeners
    await onPushNotificationOpened();

    // Depois configura o FCM token
    await setFCMToken();

    _pushNotificationsInitialized = true;
    print('✅ Push notifications inicializadas com sucesso!');
  } catch (e) {
    print('❌ Erro na execução da inicialização: $e');
    throw e;
  }
}

/// Verifica se já foi inicializado (útil para debugging)
bool isPushNotificationsInitialized() {
  return _pushNotificationsInitialized;
}

/// Força reinicialização (útil para debugging)
Future reinicializarPushNotifications() async {
  print('🔄 Forçando reinicialização das push notifications...');
  _pushNotificationsInitialized = false;
  await inicializarPushNotificationsSeguro();
}
