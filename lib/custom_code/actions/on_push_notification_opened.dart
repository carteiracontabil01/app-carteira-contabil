// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

// Begin custom action code
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/flutter_flow/nav/nav.dart';

// Inicializa o plugin de notificações locais
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future onPushNotificationOpened() async {
  print('🔔 Configurando listeners de notificações...');

  bool contextoDisponivel = appNavigatorKey.currentContext != null;

  if (!contextoDisponivel) {
    print('⚠️  Contexto não disponível inicialmente, configurando listeners básicos...');
  } else {
    print('✅ Contexto disponível, configuração completa...');
  }

  // Configura as notificações locais
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Inicializa com callback de clique
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('📱 Notificação local clicada!');
      print('Payload: ${response.payload}');
      if (response.payload != null) {
        processRedirectUrl(response.payload!);
      }
    },
  );

  // ========== FOREGROUND: App aberto ==========
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('🔔 Notificação recebida em FOREGROUND!');
    print('Título: ${message.notification?.title}');
    print('Corpo: ${message.notification?.body}');
    print('Dados: ${message.data}');

    // Mostra notificação local para aparecer mesmo em foreground
    if (message.notification != null) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'new_orders_channel', // ID do canal
        'Novos Pedidos', // Nome do canal
        channelDescription: 'Notificações de novos pedidos disponíveis',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('alert'),
      );
      
      const DarwinNotificationDetails iosDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'alert.aiff',
      );
      
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Mostra a notificação
      await flutterLocalNotificationsPlugin.show(
        message.hashCode, // ID único
        message.notification!.title,
        message.notification!.body,
        platformDetails,
        payload: message.data['url'],
      );
    }
  });

  // ========== BACKGROUND: App em background, notificação clicada ==========
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📱 App aberto via notificação (estava em background)!');
    print('Dados: ${message.data}');

    if (message.data.containsKey('url')) {
      final redirectUrl = message.data['url'];
      print('🗺️  URL de redirecionamento: $redirectUrl');

      // Construir URL completa se tiver parâmetros
      if (message.data.containsKey('paramname') &&
          message.data.containsKey('itemId') &&
          !redirectUrl.contains('?')) {
        final paramName = message.data['paramname'];
        final itemId = message.data['itemId'];
        final fullUrl = '$redirectUrl?$paramName=$itemId';
        print('🔗 URL completa: $fullUrl');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 100), () {
            processRedirectUrl(fullUrl);
          });
        });
      } else {
        print('🔗 Usando URL original: $redirectUrl');
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 100), () {
            processRedirectUrl(redirectUrl);
          });
        });
      }
    } else {
      print('⚠️  Sem URL, abrindo notificações');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        safeNavigateToNotifications();
      });
    }
  });

  // ========== TERMINATED: App fechado, notificação clicada ==========
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  
  if (initialMessage != null) {
    print('🚀 App aberto por notificação (estava FECHADO)!');
    print('Dados: ${initialMessage.data}');

    if (initialMessage.data.containsKey('url')) {
      final redirectUrl = initialMessage.data['url'];
      print('🗺️  URL de redirecionamento inicial: $redirectUrl');

      // Construir URL completa se tiver parâmetros
      if (initialMessage.data.containsKey('paramname') &&
          initialMessage.data.containsKey('itemId') &&
          !redirectUrl.contains('?')) {
        final paramName = initialMessage.data['paramname'];
        final itemId = initialMessage.data['itemId'];
        final fullUrl = '$redirectUrl?$paramName=$itemId';
        print('🔗 URL completa: $fullUrl');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 1500), () {
            processRedirectUrl(fullUrl);
          });
        });
      } else {
        print('🔗 Usando URL original: $redirectUrl');
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 1500), () {
            processRedirectUrl(redirectUrl);
          });
        });
      }
    } else {
      print('⚠️  Sem URL inicial, abrindo notificações');
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 1500), () {
          safeNavigateToNotifications();
        });
      });
    }
  }

  print('✅ Listeners de notificação configurados!');
}

/// Navega com segurança para as notificações
void safeNavigateToNotifications() {
  try {
    if (appNavigatorKey.currentContext != null) {
      final router = GoRouter.of(appNavigatorKey.currentContext!);
      router.go('/notificacoes');
      print('✅ Navegado para /notificacoes');
    } else {
      print('❌ Contexto não disponível para navegação');
    }
  } catch (e) {
    print('❌ Erro ao navegar para notificações: $e');
  }
}

/// Processa URLs de redirecionamento
void processRedirectUrl(String redirectUrl) {
  print('🔗 Processando URL: $redirectUrl');

  try {
    if (appNavigatorKey.currentContext == null) {
      print('❌ Contexto não disponível para processamento de URL');
      return;
    }

    final router = GoRouter.of(appNavigatorKey.currentContext!);

    // URL interna do app (começa com /)
    if (redirectUrl.startsWith('/')) {
      print('📍 URL interna: $redirectUrl');
      
      try {
        router.go(redirectUrl);
        print('✅ Navegação interna realizada: $redirectUrl');
      } catch (e) {
        print('❌ Erro na navegação interna: $e');
        safeNavigateToNotifications();
      }
    }
    // Deep link do app (ex: carteira-contabil://routeDetails?routeId=xxx)
    else if (redirectUrl.startsWith('carteira-contabil://')) {
      print('🔗 Deep link: $redirectUrl');
      
      final path = redirectUrl.replaceFirst('carteira-contabil://', '');
      final finalRoute = path.startsWith('/') ? path : '/$path';
      
      print('🗺️  Navegando para: $finalRoute');
      router.go(finalRoute);
    }
    // URL externa (http/https)
    else if (redirectUrl.startsWith('http')) {
      print('🌐 URL externa: $redirectUrl');
      
      try {
        launchUrl(Uri.parse(redirectUrl), mode: LaunchMode.externalApplication);
      } catch (e) {
        print('❌ Erro ao abrir URL externa: $e');
      }
    }
    // Route name simples (ex: "routeDetails")
    else {
      print('📌 Route name: $redirectUrl');
      
      try {
        router.go('/$redirectUrl');
        print('✅ Navegado para: /$redirectUrl');
      } catch (e) {
        print('❌ Erro ao navegar: $e');
        safeNavigateToNotifications();
      }
    }
  } catch (e) {
    print('❌ Erro ao processar redirecionamento: $e');
    safeNavigateToNotifications();
  }
}

