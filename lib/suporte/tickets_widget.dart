import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tickets_model.dart';
export 'tickets_model.dart';

class TicketsWidget extends StatefulWidget {
  const TicketsWidget({super.key});

  static String routeName = 'tickets';
  static String routePath = 'tickets';

  @override
  State<TicketsWidget> createState() => _TicketsWidgetState();
}

class _TicketsWidgetState extends State<TicketsWidget> {
  late TicketsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TicketsModel());
    _loadTickets();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Carrega os tickets do usuário
  Future<void> _loadTickets() async {
    try {
      final userId = currentUserUid;

      final response = await Supabase.instance.client
          .from('support_tickets')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _model.tickets = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      print('Erro ao carregar tickets: $e');
    }
  }

  /// Retorna a cor do status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return FlutterFlowTheme.of(context).warning;
      case 'in_progress':
        return FlutterFlowTheme.of(context).info;
      case 'resolved':
        return FlutterFlowTheme.of(context).success;
      case 'closed':
        return FlutterFlowTheme.of(context).grayscale60;
      default:
        return FlutterFlowTheme.of(context).grayscale60;
    }
  }

  /// Retorna o texto do status em português
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Aberto';
      case 'in_progress':
        return 'Em Andamento';
      case 'resolved':
        return 'Resolvido';
      case 'closed':
        return 'Fechado';
      default:
        return status;
    }
  }

  /// Retorna o ícone do status
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Icons.access_time_rounded;
      case 'in_progress':
        return Icons.work_rounded;
      case 'resolved':
        return Icons.check_circle_rounded;
      case 'closed':
        return Icons.lock_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Meus Tickets',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22,
                  letterSpacing: 0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: _loadTickets,
            child: _model.tickets.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _model.tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = _model.tickets[index];
                      return _buildTicketCard(ticket);
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent_rounded,
              size: 80,
              color: FlutterFlowTheme.of(context).grayscale40,
            ),
            SizedBox(height: 24),
            Text(
              'Nenhum ticket encontrado',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 12),
            Text(
              'Você ainda não criou nenhuma solicitação de suporte.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.nunito(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed('suporte');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.add_rounded),
              label: Text('Criar Ticket'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).grayscale20,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).grayscale20,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showTicketDetails(ticket);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket['subject'] ?? 'Sem assunto',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Código: ${ticket['id']}',
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // Status
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket['status'])
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(ticket['status']),
                          size: 16,
                          color: _getStatusColor(ticket['status']),
                        ),
                        SizedBox(width: 4),
                        Text(
                          _getStatusText(ticket['status']),
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    color: _getStatusColor(ticket['status']),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Category
              if (ticket['category'] != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).grayscale20,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    ticket['category'],
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.nunito(
                            fontWeight: FontWeight.w500,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                SizedBox(height: 12),
              ],

              // Description preview
              if (ticket['description'] != null) ...[
                Text(
                  ticket['description'].length > 100
                      ? '${ticket['description'].substring(0, 100)}...'
                      : ticket['description'],
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.nunito(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: 12),
              ],

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: FlutterFlowTheme.of(context).grayscale40,
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(ticket['created_at']),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.nunito(),
                          color: FlutterFlowTheme.of(context).grayscale40,
                          letterSpacing: 0.0,
                        ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: FlutterFlowTheme.of(context).grayscale40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket['subject'] ?? 'Sem assunto',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                              ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket['status'])
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(ticket['status']),
                          size: 16,
                          color: _getStatusColor(ticket['status']),
                        ),
                        SizedBox(width: 4),
                        Text(
                          _getStatusText(ticket['status']),
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    color: _getStatusColor(ticket['status']),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Ticket Info
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).grayscale20,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Código', ticket['id']),
                    _buildInfoRow('Categoria', ticket['category']),
                    _buildInfoRow(
                        'Criado em', _formatDate(ticket['created_at'])),
                    if (ticket['contact_info'] != null)
                      _buildInfoRow('Contato', ticket['contact_info']),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Description
              Text(
                'Descrição',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                      ),
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    ticket['description'] ?? 'Nenhuma descrição fornecida.',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.nunito(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Fechar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w500,
                    ),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.nunito(),
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Data não disponível';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Data inválida';
    }
  }
}
