import '/flutter_flow/flutter_flow_util.dart';
import 'notificacoes_widget.dart' show NotificacoesWidget;
import 'package:flutter/material.dart';

class NotificacoesModel extends FlutterFlowModel<NotificacoesWidget> {
  ///  Local state fields for this page.

  List<Map<String, dynamic>> notifications = [];
  void addToNotifications(Map<String, dynamic> item) => notifications.add(item);
  void removeFromNotifications(Map<String, dynamic> item) =>
      notifications.remove(item);
  void removeAtIndexFromNotifications(int index) =>
      notifications.removeAt(index);
  void insertAtIndexInNotifications(int index, Map<String, dynamic> item) =>
      notifications.insert(index, item);
  void updateNotificationsAtIndex(
          int index, Function(Map<String, dynamic>) updateFn) =>
      notifications[index] = updateFn(notifications[index]);

  int unreadCount = 0;
  bool isLoading = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
