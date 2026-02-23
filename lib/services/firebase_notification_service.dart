import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';

/// Serviço para gerenciar Firebase Cloud Messaging
///
/// Nota: antes de habilitar o FCM, adicione firebase_core e firebase_messaging
/// ao pubspec e configure os arquivos google-services.json / GoogleService-Info.plist.
class FirebaseNotificationService {
  /// Inicializa o Firebase e solicita permissão de notificações
  Future<void> initialize() async {
    print('🔔 Inicializando Firebase Cloud Messaging...');

    // Nota: descomente após configurar Firebase no projeto
    // await Firebase.initializeApp();
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicitar permissão
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   print('✅ Permissão de notificações concedida');
    //   await _getAndSaveFCMToken();
    // }

    print('⚠️  Firebase não configurado ainda');
  }

  /// Obtém o FCM token e salva no banco
  Future<String?> getAndSaveFCMToken() async {
    try {
      // Nota: descomentar ao ativar Firebase
      // FirebaseMessaging messaging = FirebaseMessaging.instance;
      // String? token = await messaging.getToken();

      String token = 'mock-fcm-token-${DateTime.now().millisecondsSinceEpoch}';

      print('🔑 FCM Token obtido: ${token.substring(0, 20)}...');

      // Salvar no banco (tabela users)
      await _saveFCMToken(token);

      return token;
    } catch (e) {
      print('❌ Erro ao obter FCM token: $e');
    }

    return null;
  }

  /// Salva o FCM token no banco
  Future<void> _saveFCMToken(String token) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        print('⚠️  Usuário não autenticado, não pode salvar FCM token');
        return;
      }

      await Supabase.instance.client
          .from('users')
          .update({'fcm_token': token}).eq('id', userId);

      print('✅ FCM Token salvo no banco');
    } catch (e) {
      print('❌ Erro ao salvar FCM token: $e');
    }
  }

  /// Escuta mensagens em foreground
  void listenToForegroundMessages(Function(Map<String, dynamic>) onMessage) {
    print('👂 Escutando mensagens em foreground...');

    // Nota: implementar quando Firebase estiver habilitado
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('🔔 Mensagem recebida em foreground: ${message.notification?.title}');
    //
    //   final data = {
    //     'title': message.notification?.title,
    //     'body': message.notification?.body,
    //     'data': message.data,
    //   };
    //
    //   onMessage(data);
    // });
  }

  /// Escuta quando o app é aberto via notificação
  void listenToNotificationOpenedApp(Function(Map<String, dynamic>) onOpen) {
    print('👂 Escutando cliques em notificações...');

    // Nota: implementar quando Firebase estiver habilitado
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('📱 App aberto via notificação: ${message.data}');
    //   onOpen(message.data);
    // });
  }

  /// Escuta mensagens em background
  static Future<void> handleBackgroundMessage(dynamic message) async {
    print('🔔 Mensagem recebida em background');

    // Nota: adicionar lógica de background conforme necessidade
  }

  /// Marca notificação como lida
  Future<void> markAsRead(String notificationRecipientId) async {
    try {
      await Supabase.instance.client.from('notification_recipients').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationRecipientId);

      print('✅ Notificação marcada como lida');
    } catch (e) {
      print('❌ Erro ao marcar notificação como lida: $e');
    }
  }

  /// Busca notificações do usuário
  Future<List<Map<String, dynamic>>> getUserNotifications() async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return [];
      }

      final result = await Supabase.instance.client
          .from('notification_recipients')
          .select('''
            id,
            is_read,
            read_at,
            created_at,
            notifications!notification_recipients_notification_id_fkey (
              id,
              title,
              content,
              big_image,
              url,
              paramname,
              itemid,
              created_at
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      print('❌ Erro ao buscar notificações: $e');
      return [];
    }
  }

  /// Envia notificação para um usuário específico
  Future<String?> sendNotificationToUser({
    required String userId,
    required String title,
    required String content,
    String? url,
    String? paramname,
    String? itemid,
    String? bigImage,
  }) async {
    try {
      final result = await Supabase.instance.client.rpc(
        'send_notification_to_user',
        params: {
          'p_user_id': userId,
          'p_title': title,
          'p_content': content,
          'p_url': url,
          'p_paramname': paramname,
          'p_itemid': itemid,
          'p_big_image': bigImage,
        },
      );

      print('✅ Notificação enviada: $result');
      return result as String?;
    } catch (e) {
      print('❌ Erro ao enviar notificação: $e');
      return null;
    }
  }
}
