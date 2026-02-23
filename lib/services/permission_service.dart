import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// Serviço para gerenciar permissões do app
class PermissionService {
  /// Verifica se todas as permissões críticas foram concedidas
  Future<bool> hasCriticalPermissions() async {
    final notification = await Permission.notification.status;

    return notification.isGranted;
  }

  /// Solicita permissão de notificações
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Solicita permissão de câmera
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Solicita permissão de galeria
  Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  /// Verifica status da permissão de notificações
  Future<PermissionStatus> getNotificationStatus() async {
    return await Permission.notification.status;
  }

  /// Abre configurações do app
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Modal para solicitar notificações
  Future<bool?> showNotificationPermissionDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Row(
          children: [
            Icon(
              Icons.notifications_active_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 28.0,
            ),
            SizedBox(width: 12.0),
            Text(
              'Ative as Notificações',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    font: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        content: Text(
          'Você precisa ativar as notificações para receber alertas de novos pedidos em tempo real. Sem isso, você não receberá pedidos!',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Agora não',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          FFButtonWidget(
            onPressed: () async {
              Navigator.of(context).pop(true);
              final granted = await requestNotificationPermission();

              if (!granted) {
                // Mostrar como ativar manualmente
                _showManualPermissionDialog(context, 'notificações');
              }
            },
            text: 'Ativar',
            options: FFButtonOptions(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 24.0, vertical: 12.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra diálogo para ativar permissão manualmente
  void _showManualPermissionDialog(
      BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Text(
          'Permissão Negada',
          style: FlutterFlowTheme.of(context).titleLarge.override(
                font: GoogleFonts.nunito(fontWeight: FontWeight.w700),
                letterSpacing: 0.0,
              ),
        ),
        content: Text(
          'Para usar o app, você precisa ativar $permissionName nas configurações do dispositivo.',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          ),
          FFButtonWidget(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            text: 'Abrir Configurações',
            options: FFButtonOptions(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 16.0, vertical: 12.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ],
      ),
    );
  }

  /// Solicita todas as permissões críticas após login
  Future<Map<String, bool>> requestAllCriticalPermissions(
      BuildContext context) async {
    final results = <String, bool>{};

    // 1. Notificações
    await showNotificationPermissionDialog(context);
    final notificationGranted = await Permission.notification.isGranted;
    results['notification'] = notificationGranted;

    return results;
  }
}
