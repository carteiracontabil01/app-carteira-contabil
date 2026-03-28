import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'guias_model.dart';
export 'guias_model.dart';

class GuiasWidget extends StatefulWidget {
  const GuiasWidget({super.key});

  static String routeName = 'guias';
  static String routePath = 'guias';

  @override
  State<GuiasWidget> createState() => _GuiasWidgetState();
}

class _GuiasWidgetState extends State<GuiasWidget> {
  late GuiasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GuiasModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  List<int> get _years {
    final y = DateTime.now().year;
    return List.generate(11, (i) => y - 5 + i);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'Guias e Cobranças',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Chat',
              onPressed: () => context.pushNamed('chat'),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 24,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.description_outlined,
                size: 24,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              onPressed: () {},
            ),
          ],
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryTabs(context),
              if (GuiasModel.tabShowsPeriodFilters(_model.selectedTab))
                _buildPeriodAndStatusFilters(context),
              Expanded(
                child: _buildTabBody(context, dateFormat),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBody(BuildContext context, DateFormat dateFormat) {
    switch (_model.selectedTab) {
      case GuiasModel.tabPgdas:
        return _buildPgdasList(context, dateFormat);
      case GuiasModel.tabCertidoes:
        return _buildCertidoesList(context, dateFormat);
      case GuiasModel.tabComprovantes:
        return _buildComprovantesList(context, dateFormat);
      case GuiasModel.tabCaixas:
        return _buildCaixasPostaisContent(context, dateFormat);
      default:
        return _buildPgdasList(context, dateFormat);
    }
  }

  /// Abas horizontais
  Widget _buildCategoryTabs(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      color: theme.secondaryBackground,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: GuiasModel.categoryTabs.map((tab) {
            final isSelected = _model.selectedTab == tab;
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () => setState(() => _model.setTab(tab)),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? theme.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    tab,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? theme.primaryText
                          : theme.primaryText.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Apenas aba Guias - PGDAS
  Widget _buildPeriodAndStatusFilters(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final months = List.generate(12, (i) => i + 1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Período',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ano',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: theme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _dropdownContainer(
                      context,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _model.filterYear,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: theme.secondaryText, size: 20),
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                          items: _years
                              .map((y) => DropdownMenuItem(
                                    value: y,
                                    child: Text('$y'),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _model.setFilterYear(v));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mês',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: theme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _dropdownContainer(
                      context,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _model.filterMonth,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded,
                              color: theme.secondaryText, size: 20),
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                          items: months.map((m) {
                            final name = DateFormat.MMMM('pt_BR')
                                .format(DateTime(2000, m, 1));
                            return DropdownMenuItem(
                              value: m,
                              child: Text(
                                '${name[0].toUpperCase()}${name.substring(1)}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _model.setFilterMonth(v));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Status',
            style: GoogleFonts.nunito(
              fontSize: 11,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          _dropdownContainer(
            context,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _model.statusFilter,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: theme.secondaryText, size: 20),
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                ),
                items: const [
                  DropdownMenuItem(value: 'Todas', child: Text('Todas')),
                  DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                  DropdownMenuItem(value: 'Pago', child: Text('Pago')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _model.setStatusFilter(v));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownContainer(BuildContext context, {required Widget child}) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.primaryText.withValues(alpha: 0.1),
        ),
      ),
      child: child,
    );
  }

  Widget _buildPgdasList(
    BuildContext context,
    DateFormat dateFormat,
  ) {
    final guiasList = _model.getFilteredPgdasList();

    if (guiasList.isEmpty) {
      return _emptyState(
        context,
        'Nenhum registro no período',
        'Ajuste ano, mês ou status',
      );
    }

    final theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Período',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Pgto',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Venc.',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  'Decl.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  'Baixar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Divider(height: 1, color: theme.primaryText.withValues(alpha: 0.08)),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: guiasList.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: theme.primaryText.withValues(alpha: 0.06),
            ),
            itemBuilder: (context, index) {
              return _buildPgdasTableRow(
                context,
                guiasList[index],
                dateFormat,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPgdasTableRow(
    BuildContext context,
    Map<String, dynamic> guia,
    DateFormat dateFormat,
  ) {
    final theme = FlutterFlowTheme.of(context);
    final vencimento = guia['vencimento'] as DateTime;
    final periodo = vencimento.month.toString().padLeft(2, '0');
    final isPendente = guia['status'] == 'Pendente';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              periodo,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPendente
                      ? const Color(0xFFFFE0B2).withValues(alpha: 0.7)
                      : const Color(0xFFB2DFDB).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  guia['status'] as String,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isPendente
                        ? const Color(0xFFE65100)
                        : const Color(0xFF00695C),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              dateFormat.format(vencimento),
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: theme.primaryText,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: Icon(
                Icons.search_rounded,
                size: 20,
                color: theme.secondaryText,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF00897B).withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(
                Icons.download_rounded,
                size: 20,
                color: Color(0xFF00897B),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertidoesList(
    BuildContext context,
    DateFormat dateFormat,
  ) {
    final list = _model.getCertidoesList();
    if (list.isEmpty) {
      return _emptyState(context, 'Nenhum documento', '');
    }
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Documento',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Emissão',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  'Baixar',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: theme.primaryText.withValues(alpha: 0.08)),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: theme.primaryText.withValues(alpha: 0.06),
            ),
            itemBuilder: (context, index) {
              final row = list[index];
              final emissao = row['emissao'] as DateTime;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        row['titulo'] as String,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        dateFormat.format(emissao),
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 44,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                            minWidth: 40, minHeight: 40),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF00897B).withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(
                          Icons.download_rounded,
                          size: 20,
                          color: Color(0xFF00897B),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Mesmo padrão das outras abas: cabeçalho + lista (sem card)
  Widget _buildComprovantesList(
    BuildContext context,
    DateFormat dateFormat,
  ) {
    final list = _model.getComprovantesList();
    if (list.isEmpty) {
      return _emptyState(context, 'Nenhum comprovante', '');
    }
    final theme = FlutterFlowTheme.of(context);
    const navyButton = Color(0xFF1A237E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Código',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Vencimento',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  'Detalhes',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: theme.primaryText.withValues(alpha: 0.08)),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: theme.primaryText.withValues(alpha: 0.06),
            ),
            itemBuilder: (context, index) {
              final row = list[index];
              final codigo = '${row['codigo']}';
              final venc = row['vencimento'] as DateTime;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        codigo,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        dateFormat.format(venc),
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: navyButton,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Caixas postais: apenas cabeçalho da tabela + lista (como Certidões/Comprovantes)
  Widget _buildCaixasPostaisContent(
    BuildContext context,
    DateFormat dateFormat,
  ) {
    final theme = FlutterFlowTheme.of(context);
    final list = _model.getCaixasPostaisList();

    if (list.isEmpty) {
      return _emptyState(context, 'Nenhuma mensagem', '');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                child: Text(
                  'Recebida',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Assunto',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        Divider(height: 1, color: theme.primaryText.withValues(alpha: 0.08)),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: theme.primaryText.withValues(alpha: 0.06),
            ),
            itemBuilder: (context, index) {
              final row = list[index];
              final recebida = row['recebida'] as DateTime;
              final assunto = row['assunto'] as String;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 88,
                      child: Text(
                        dateFormat.format(recebida),
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        assunto,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: theme.primaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: Text(
                        'Ler',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _emptyState(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: FlutterFlowTheme.of(context)
                .secondaryText
                .withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
