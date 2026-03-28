import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'servicos_catalog.dart';
import 'servicos_model.dart';
import 'servicos_repository.dart';
import 'solicitar_servico_widget.dart';
export 'servicos_catalog.dart';
export 'servicos_model.dart';

class ServicosWidget extends StatefulWidget {
  const ServicosWidget({
    super.key,
    /// Quando `true` (aba do [NavBarPage]), oculta o botão voltar do AppBar.
    this.embeddedInBottomNav = false,
  });

  final bool embeddedInBottomNav;

  static String routeName = 'servicos';
  static String routePath = 'servicos';

  @override
  State<ServicosWidget> createState() => _ServicosWidgetState();
}

class _ServicosWidgetState extends State<ServicosWidget> {
  late ServicosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ServicosRepository.instance.initMockIfEmpty();
    _model = createModel(context, () => ServicosModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');
    final repo = ServicosRepository.instance;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: widget.embeddedInBottomNav
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: theme.primaryText,
                    size: 24,
                  ),
                  onPressed: () => context.safePop(),
                ),
          title: Text(
            'Serviços',
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
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text(
                  'Suas solicitações',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              Expanded(
                child: repo.solicitacoes.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Nenhuma solicitação ainda.\nToque em “Solicitar serviço” para começar.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              height: 1.4,
                              color: theme.secondaryText,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        itemCount: repo.solicitacoes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final s = repo.solicitacoes[index];
                          return _SolicitacaoCard(
                            s: s,
                            currency: currency,
                            dateFmt: dateFmt,
                            theme: theme,
                          );
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  16 + (widget.embeddedInBottomNav ? 88 : 0),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () async {
                      await context.pushNamed(
                        SolicitarServicoWidget.routeName,
                      );
                      if (mounted) setState(() {});
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Solicitar serviço',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SolicitacaoCard extends StatelessWidget {
  const _SolicitacaoCard({
    required this.s,
    required this.currency,
    required this.dateFmt,
    required this.theme,
  });

  final SolicitacaoServico s;
  final NumberFormat currency;
  final DateFormat dateFmt;
  final FlutterFlowTheme theme;

  Color _statusColor() {
    switch (s.status) {
      case 'Pendente':
        return const Color(0xFFE65100);
      case 'Em análise':
        return const Color(0xFF1565C0);
      case 'Aprovado':
      case 'Concluído':
        return const Color(0xFF2E7D32);
      default:
        return theme.secondaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.primaryText.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  s.servicoNome,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s.status,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            dateFmt.format(s.solicitadoEm),
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: theme.secondaryText,
            ),
          ),
          if (s.precoCatalogo != null) ...[
            const SizedBox(height: 8),
            Text(
              'Valor: ${currency.format(s.precoCatalogo)}',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.primary,
              ),
            ),
          ] else if (s.valorInformadoOpcional != null) ...[
            const SizedBox(height: 8),
            Text(
              'Valor indicado: ${currency.format(s.valorInformadoOpcional)}',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: theme.primaryText,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            s.observacao,
            style: GoogleFonts.nunito(
              fontSize: 13,
              height: 1.35,
              color: theme.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
