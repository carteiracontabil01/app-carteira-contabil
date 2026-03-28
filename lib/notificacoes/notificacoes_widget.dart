import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'notificacoes_model.dart';
export 'notificacoes_model.dart';

class NotificacoesWidget extends StatefulWidget {
  const NotificacoesWidget({super.key});

  static String routeName = 'notificacoes';
  static String routePath = 'notificacoes';

  @override
  State<NotificacoesWidget> createState() => _NotificacoesWidgetState();
}

class _NotificacoesWidgetState extends State<NotificacoesWidget> {
  late NotificacoesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificacoesModel());
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    _loadNotifications();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ==================== DATA LOADING ====================

  Future<void> _loadNotifications() async {
    if (!mounted) return;

    setState(() => _model.isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('user_notifications')
          .select('*')
          .eq('user_id', currentUserUid)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _model.notifications = List<Map<String, dynamic>>.from(response);
          _model.unreadCount = _calculateUnreadCount();
          _model.isLoading = false;
        });
      }
    } catch (e) {
      _handleError('Erro ao carregar notificações', e);
      if (mounted) {
        setState(() => _model.isLoading = false);
      }
    }
  }

  int _calculateUnreadCount() {
    return _model.notifications.where((n) => n['is_read'] == false).length;
  }

  // ==================== NOTIFICATION ACTIONS ====================

  Future<void> _markAsRead(Map<String, dynamic> notification) async {
    if (notification['is_read'] == true) return;

    try {
      await Supabase.instance.client.rpc(
        'mark_notification_as_read',
        params: {
          'p_notification_id': notification['id'],
          'p_user_id': currentUserUid,
        },
      );

      _updateNotificationLocally(notification, isRead: true);
    } catch (e) {
      _handleError('Erro ao marcar como lida', e);
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await Supabase.instance.client.rpc(
        'mark_all_notifications_as_read',
        params: {'p_user_id': currentUserUid},
      );

      setState(() {
        for (var notification in _model.notifications) {
          notification['is_read'] = true;
          notification['read_at'] = DateTime.now().toIso8601String();
        }
        _model.unreadCount = 0;
      });

      _showSuccessMessage('Todas as notificações foram marcadas como lidas');
    } catch (e) {
      _handleError('Erro ao marcar todas como lidas', e);
    }
  }

  Future<void> _deleteNotification(Map<String, dynamic> notification) async {
    try {
      await Supabase.instance.client
          .from('user_notifications')
          .delete()
          .eq('id', notification['id'])
          .eq('user_id', currentUserUid);

      _removeNotificationLocally(notification);
      _showSuccessMessage('Notificação excluída');
    } catch (e) {
      _handleError('Erro ao excluir notificação', e);
      _showErrorMessage('Erro ao excluir notificação');
    }
  }

  Future<bool?> _confirmDeletion() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir notificação'),
        content: const Text('Deseja realmente excluir esta notificação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Excluir',
              style: TextStyle(color: FlutterFlowTheme.of(context).error),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== LOCAL STATE UPDATES ====================

  void _updateNotificationLocally(
    Map<String, dynamic> notification, {
    required bool isRead,
  }) {
    setState(() {
      final index = _model.notifications.indexOf(notification);
      if (index != -1) {
        _model.notifications[index]['is_read'] = isRead;
        _model.notifications[index]['read_at'] =
            DateTime.now().toIso8601String();
        _model.unreadCount = _calculateUnreadCount();
      }
    });
  }

  void _removeNotificationLocally(Map<String, dynamic> notification) {
    setState(() {
      _model.notifications.remove(notification);
      if (notification['is_read'] == false) {
        _model.unreadCount--;
      }
    });
  }

  // ==================== NAVIGATION ====================

  void _handleNotificationTap(Map<String, dynamic> notification) {
    _markAsRead(notification);

    final url = notification['url'];
    final paramName = notification['param_name'];
    final itemId = notification['item_id'];

    if (url != null && url.isNotEmpty) {
      _navigateToNotificationDestination(url, paramName, itemId);
    }
  }

  void _navigateToNotificationDestination(
    String url,
    String? paramName,
    String? itemId,
  ) {
    if (paramName != null && itemId != null) {
      context.pushNamed(url, pathParameters: {paramName: itemId});
    } else {
      context.pushNamed(url);
    }
  }

  // ==================== UI HELPERS ====================

  IconData _getNotificationIcon(String? type) {
    return switch (type?.toLowerCase()) {
      'order' => Icons.shopping_bag_rounded,
      'promotion' => Icons.local_offer_rounded,
      'system' => Icons.info_rounded,
      'support' => Icons.support_agent_rounded,
      _ => Icons.notifications_rounded,
    };
  }

  Color _getNotificationColor(String? type) {
    final theme = FlutterFlowTheme.of(context);
    return switch (type?.toLowerCase()) {
      'order' => theme.primary,
      'promotion' => theme.success,
      'system' => theme.info,
      'support' => theme.warning,
      _ => theme.grayscale60,
    };
  }

  // ==================== FEEDBACK MESSAGES ====================

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FlutterFlowTheme.of(context).success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }

  void _handleError(String message, Object error) {
    debugPrint('$message: $error');
  }

  // ==================== BUILD METHODS ====================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = FlutterFlowTheme.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: theme.primaryText,
          size: 24,
        ),
        onPressed: () => context.safePop(),
      ),
      title: Text(
        'Notificações',
        style: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.primaryText,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          tooltip: 'Chat',
          onPressed: () => context.pushNamed('chat'),
          icon: Icon(
            Icons.chat_bubble_outline_rounded,
            size: 24,
            color: theme.primaryText,
          ),
        ),
        if (_model.unreadCount > 0)
          IconButton(
            icon: Icon(
              Icons.done_all_rounded,
              color: theme.primaryText,
              size: 24,
            ),
            onPressed: _markAllAsRead,
            tooltip: 'Marcar todas como lidas',
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (_model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: _model.notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationsList(),
    );
  }

  Widget _buildNotificationsList() {
    return Column(
      children: [
        if (_model.unreadCount > 0) _buildUnreadHeader(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _model.notifications.length,
            itemBuilder: (context, index) =>
                _buildNotificationCard(_model.notifications[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildUnreadHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: FlutterFlowTheme.of(context).grayscale20,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: FlutterFlowTheme.of(context).primary,
            size: 12,
          ),
          const SizedBox(width: 8),
          Text(
            _getUnreadCountText(),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                  color: FlutterFlowTheme.of(context).primary,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  String _getUnreadCountText() {
    final count = _model.unreadCount;
    return '$count ${count == 1 ? 'notificação não lida' : 'notificações não lidas'}';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: FlutterFlowTheme.of(context).grayscale40,
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma notificação',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Você não tem notificações no momento.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.nunito(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['is_read'] == true;
    final hasImage = notification['big_image'] != null &&
        notification['big_image'].toString().isNotEmpty;

    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDeletion(),
      onDismissed: (_) => _deleteNotification(notification),
      background: _buildDismissBackground(),
      child: _buildNotificationCardContent(notification, isRead, hasImage),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).error,
        border: Border(
          bottom: BorderSide(
            color: FlutterFlowTheme.of(context).grayscale20,
            width: 1.0,
          ),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_rounded, color: Colors.white, size: 28),
          SizedBox(height: 4),
          Text(
            'Excluir',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCardContent(
    Map<String, dynamic> notification,
    bool isRead,
    bool hasImage,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isRead
            ? FlutterFlowTheme.of(context).secondaryBackground
            : FlutterFlowTheme.of(context).primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: FlutterFlowTheme.of(context).grayscale20,
            width: 1.0,
          ),
        ),
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(notification),
              const SizedBox(width: 12),
              Expanded(
                child:
                    _buildNotificationContent(notification, isRead, hasImage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(Map<String, dynamic> notification) {
    final type = notification['notification_type'];
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getNotificationColor(type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        _getNotificationIcon(type),
        color: _getNotificationColor(type),
        size: 24,
      ),
    );
  }

  Widget _buildNotificationContent(
    Map<String, dynamic> notification,
    bool isRead,
    bool hasImage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNotificationTitle(notification, isRead),
        const SizedBox(height: 4),
        _buildNotificationBody(notification),
        if (hasImage) ...[
          const SizedBox(height: 8),
          _buildNotificationImage(notification),
        ],
        const SizedBox(height: 8),
        _buildNotificationTimestamp(notification),
      ],
    );
  }

  Widget _buildNotificationTitle(
    Map<String, dynamic> notification,
    bool isRead,
  ) {
    return Row(
      children: [
        if (!isRead) _buildUnreadIndicator(),
        Expanded(
          child: Text(
            notification['title'] ?? 'Notificação',
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNotificationBody(Map<String, dynamic> notification) {
    return Text(
      notification['content'] ?? '',
      style: FlutterFlowTheme.of(context).bodySmall.override(
            font: GoogleFonts.nunito(),
            color: FlutterFlowTheme.of(context).secondaryText,
            letterSpacing: 0.0,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNotificationImage(Map<String, dynamic> notification) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Image.network(
          notification['big_image'],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: FlutterFlowTheme.of(context).grayscale20,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: FlutterFlowTheme.of(context).grayscale20,
            child: Icon(
              Icons.broken_image_rounded,
              color: FlutterFlowTheme.of(context).grayscale40,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTimestamp(Map<String, dynamic> notification) {
    return Text(
      timeago.format(
        DateTime.parse(notification['created_at']),
        locale: 'pt_BR',
      ),
      style: FlutterFlowTheme.of(context).bodySmall.override(
            font: GoogleFonts.nunito(),
            color: FlutterFlowTheme.of(context).grayscale40,
            fontSize: 11,
            letterSpacing: 0.0,
          ),
    );
  }
}
