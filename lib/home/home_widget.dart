import '/app_state.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/app_login_service.dart';
import '/services/billing_dashboard_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static String routeName = 'home';
  static String routePath = 'home';

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
      _loadUserCompanies();
    });
  }

  /// Carrega lista de empresas do usuário para o dropdown
  Future<void> _loadUserCompanies() async {
    final list = await AppLoginService.getUserCompanies(currentUserUid);
    if (!mounted) return;
    final listMap = list.map((e) => Map<String, dynamic>.from(e)).toList();
    _model.userCompanies = listMap;
    final appState = context.read<FFAppState>();
    if ((appState.companyName == null || appState.companyName!.isEmpty) &&
        listMap.isNotEmpty &&
        appState.companyId != null) {
      for (final item in listMap) {
        if (item['company_id'] == appState.companyId) {
          appState.companyName = (item['business_name'] ?? '').toString();
          break;
        }
      }
    }
    safeSetState(() {});
  }

  /// Carrega dados do fn_get_company_billing_dashboard_v2
  Future<void> _loadDashboardData() async {
    final appState = context.read<FFAppState>();
    final companyId = appState.companyId;
    final companyUserId = appState.companyUserId;

    print('📊 Home _loadDashboardData - companyId: $companyId');

    if (companyId == null || companyId.isEmpty) {
      print(
          '⚠️ Home: companyId vazio - usando mock (usuário sem contexto de empresa)');
      _model.useMockData();
      safeSetState(() {});
      return;
    }

    _model.isLoading = true;
    safeSetState(() {});

    String startDate;
    String endDate;

    if (_model.filterType == 'month') {
      final m = _model.selectedMonth;
      startDate = '${m.year}-${m.month.toString().padLeft(2, '0')}-01';
      endDate =
          '${m.year}-${m.month.toString().padLeft(2, '0')}-${DateTime(m.year, m.month + 1, 0).day.toString().padLeft(2, '0')}';
    } else if (_model.filterType == 'range' &&
        _model.rangeStart != null &&
        _model.rangeEnd != null) {
      final s = _model.rangeStart!;
      final e = _model.rangeEnd!;
      startDate =
          '${s.year}-${s.month.toString().padLeft(2, '0')}-${s.day.toString().padLeft(2, '0')}';
      endDate =
          '${e.year}-${e.month.toString().padLeft(2, '0')}-${e.day.toString().padLeft(2, '0')}';
    } else {
      final y = _model.selectedYear;
      startDate = '$y-01-01';
      endDate = '$y-12-31';
    }

    final data = await BillingDashboardService.getCompanyBillingDashboard(
      companyId: companyId,
      startDate: startDate,
      endDate: endDate,
      companyUserId: companyUserId,
    );

    _model.setDashboardData(data);

    _model.isLoading = false;
    if (mounted) safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final percentFormat = NumberFormat.decimalPattern('pt_BR');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Image.asset(
            'assets/images/logo-colorida.png',
            height: 44,
            fit: BoxFit.contain,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _model.toggleRevenueVisibility();
                safeSetState(() {});
              },
              icon: Icon(
                _model.isRevenueVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24,
              ),
            ),
            IconButton(
              tooltip: 'Chat',
              onPressed: () => context.pushNamed('chat'),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () => context.pushNamed('notificacoes'),
              icon: Icon(
                Icons.notifications_outlined,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24,
              ),
            ),
          ],
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seção de boas-vindas: avatar + "Seja bem vindo" + nome da empresa (clicável para trocar)
                    _buildWelcomeSection(context),
                    const SizedBox(height: 20),
                    // Faturamento (com seletor de período integrado)
                    _buildRevenueCard(context, currencyFormat, percentFormat),

                    const SizedBox(height: 20),

                // Cards de métricas (estilo dashboard web)
                _buildMetricsRow(context, currencyFormat),

                    const SizedBox(height: 24),

                    // Seção: Gráfico em barras
                    _buildBarChartSection(context),

                    const SizedBox(height: 24),

                    // Seção: Gráfico circular Pago / Pendente / Atrasado
                    _buildPaymentPieSection(context),

                const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            if (_model.isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final appState = context.read<FFAppState>();
    final companies = _model.userCompanies;
    final currentId = appState.companyId ?? (companies.isNotEmpty ? companies.first['company_id']?.toString() : null);
    final companyName =
        (appState.companyName != null && appState.companyName!.isNotEmpty)
            ? appState.companyName!
            : 'Empresa';

    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.pushNamed('perfil'),
              customBorder: const CircleBorder(),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: theme.primary.withValues(alpha: 0.15),
                backgroundImage: currentUserPhoto.isNotEmpty
                    ? CachedNetworkImageProvider(currentUserPhoto)
                    : null,
                child: currentUserPhoto.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 32,
                        color: theme.primary,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seja bem vindo',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                if (companies.isEmpty)
                  Text(
                    companyName,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Builder(
                    builder: (buttonContext) {
                      return InkWell(
                        key: ValueKey<String>('tenant_menu_$currentId'),
                        onTap: () => _showTenantMenuFullWidth(
                          buttonContext,
                          companies,
                          theme,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  companyName,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 24,
                                color: theme.secondaryText,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Menu de tenant na largura útil da tela (alinhado ao padding horizontal).
  Future<void> _showTenantMenuFullWidth(
    BuildContext buttonContext,
    List<dynamic> companies,
    FlutterFlowTheme theme,
  ) async {
    final overlay =
        Overlay.of(buttonContext).context.findRenderObject() as RenderBox;
    final box = buttonContext.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero);
    final o = overlay.size;
    const pad = 20.0;
    final menuTop = topLeft.dy + box.size.height + 4;
    final menuWidth = o.width - 2 * pad;

    final selected = await showMenu<String>(
      context: buttonContext,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          pad,
          menuTop,
          menuWidth,
          o.height - menuTop - pad,
        ),
        Offset.zero & o,
      ),
      elevation: 8,
      color: theme.secondaryBackground,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: companies.map((item) {
        final cid = (item['company_id'] ?? '').toString();
        final name = (item['business_name'] ?? 'Empresa').toString();
        return PopupMenuItem<String>(
          value: cid,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: menuWidth - 32,
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
              ),
            ),
          ),
        );
      }).toList(),
    );

    if (!mounted || selected == null) return;
    final item = companies.cast<Map<String, dynamic>>().firstWhere(
          (e) => (e['company_id'] ?? '').toString() == selected,
          orElse: () => <String, dynamic>{},
        );
    if (item.isEmpty) return;
    final st = context.read<FFAppState>();
    st.setCompanyContext(
      (item['company_user_id'] ?? '').toString(),
      (item['company_id'] ?? '').toString(),
      (item['business_name'] ?? 'Empresa').toString(),
    );
    _loadDashboardData();
    safeSetState(() {});
  }

  // Faturamento: valor em destaque no topo + seletor de período abaixo
  Widget _buildRevenueCard(BuildContext context, NumberFormat currencyFormat,
      NumberFormat percentFormat) {
    final growth = _model.getRevenueGrowth();
    final isPositive = growth >= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Valor (toque abre seletor de período) e indicador comparativo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _showPeriodBottomSheet(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 250),
                            firstChild: Text(
                              currencyFormat.format(_model.currentRevenue),
                              style: GoogleFonts.nunito(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: -1,
                              ),
                            ),
                            secondChild: Text(
                              '••••••',
                              style: GoogleFonts.nunito(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 4,
                              ),
                            ),
                            crossFadeState: _model.isRevenueVisible
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedOpacity(
                opacity: _model.isRevenueVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: isPositive
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFFF5252),
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isPositive ? '+' : ''}${percentFormat.format(growth.abs())}%',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isPositive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF5252),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _model.filterType == 'month'
                          ? 'vs mês anterior'
                          : 'vs ano anterior',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          InkWell(
            onTap: () => _showPeriodBottomSheet(context),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.only(top: 0, right: 4, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Período de ',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      children: [
                        TextSpan(
                          text: _periodSubtitle(),
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Toque para alterar',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _periodSubtitle() {
    if (_model.filterType == 'month') {
      return DateFormat('MMMM yyyy', 'pt_BR').format(_model.selectedMonth);
    }
    if (_model.filterType == 'year') return '${_model.selectedYear}';
    if (_model.rangeStart != null && _model.rangeEnd != null) {
      return '${DateFormat('dd/MM/yyyy', 'pt_BR').format(_model.rangeStart!)} - ${DateFormat('dd/MM/yyyy', 'pt_BR').format(_model.rangeEnd!)}';
    }
    return '';
  }

  void _showPeriodBottomSheet(BuildContext context) {
    String sheetType = _model.filterType;
    DateTime sheetMonth = _model.selectedMonth;
    int sheetYear = _model.selectedYear;
    DateTime? sheetRangeStart = _model.rangeStart;
    DateTime? sheetRangeEnd = _model.rangeEnd;
    if (sheetRangeStart == null || sheetRangeEnd == null) {
      final now = DateTime.now();
      sheetRangeStart = DateTime(now.year, now.month, 1);
      sheetRangeEnd = DateTime(now.year, now.month + 1, 0);
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final theme = FlutterFlowTheme.of(ctx);
          return Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 8,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.secondaryText.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Período',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _periodTab(ctx, 'Mensal', sheetType == 'month',
                        () => setModalState(() => sheetType = 'month'), theme),
                    _periodTab(ctx, 'Anual', sheetType == 'year',
                        () => setModalState(() => sheetType = 'year'), theme),
                    _periodTab(ctx, 'Intervalo', sheetType == 'range',
                        () => setModalState(() => sheetType = 'range'), theme),
                  ],
                ),
                const SizedBox(height: 24),
                if (sheetType == 'month')
                  _periodMonthYearBlock(
                    ctx,
                    DateFormat('MMMM yyyy', 'pt_BR').format(sheetMonth),
                    () => setModalState(() => sheetMonth =
                        DateTime(sheetMonth.year, sheetMonth.month - 1)),
                    () => setModalState(() => sheetMonth =
                        DateTime(sheetMonth.year, sheetMonth.month + 1)),
                    theme,
                  )
                else if (sheetType == 'year')
                  _periodMonthYearBlock(
                    ctx,
                    '$sheetYear',
                    () => setModalState(() => sheetYear--),
                    () => setModalState(() => sheetYear++),
                    theme,
                  )
                else
                  _periodRangeBlock(
                    ctx,
                    sheetRangeStart!,
                    sheetRangeEnd!,
                    (DateTime d) => setModalState(() => sheetRangeStart = d),
                    (DateTime d) => setModalState(() => sheetRangeEnd = d),
                    theme,
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      setState(() {
                        if (sheetType == 'month') {
                          _model.setFilterType('month');
                          _model.updateMonth(sheetMonth);
                        } else if (sheetType == 'year') {
                          _model.setFilterType('year');
                          _model.updateYear(sheetYear);
                        } else {
                          _model.setFilterType('range');
                          _model.setDateRange(sheetRangeStart!, sheetRangeEnd!);
                        }
                      });
                      await _loadDashboardData();
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: theme.primaryText,
                      foregroundColor: theme.primaryBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Aplicar',
                        style: GoogleFonts.nunito(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _periodTab(BuildContext context, String label, bool selected,
      VoidCallback onTap, FlutterFlowTheme theme) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? theme.primaryText : theme.secondaryText,
                ),
              ),
            ),
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: selected ? theme.primaryText : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodMonthYearBlock(
    BuildContext context,
    String label,
    VoidCallback onPrev,
    VoidCallback onNext,
    FlutterFlowTheme theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPrev,
            icon: Icon(Icons.chevron_left_rounded,
                color: theme.primaryText, size: 28),
            style: IconButton.styleFrom(
                padding: EdgeInsets.zero, minimumSize: const Size(44, 44)),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: theme.primaryText),
          ),
          IconButton(
            onPressed: onNext,
            icon: Icon(Icons.chevron_right_rounded,
                color: theme.primaryText, size: 28),
            style: IconButton.styleFrom(
                padding: EdgeInsets.zero, minimumSize: const Size(44, 44)),
          ),
        ],
      ),
    );
  }

  Widget _periodRangeBlock(
    BuildContext context,
    DateTime start,
    DateTime end,
    void Function(DateTime) onStartPicked,
    void Function(DateTime) onEndPicked,
    FlutterFlowTheme theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: start,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) onStartPicked(picked);
              },
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      'Data inicial',
                      style: GoogleFonts.nunito(
                          fontSize: 15, color: theme.secondaryText),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy', 'pt_BR').format(start),
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right_rounded,
                        size: 22, color: theme.secondaryText),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 1, color: theme.primaryText.withValues(alpha: 0.08)),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: end,
                  firstDate: start,
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) onEndPicked(picked);
              },
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      'Data final',
                      style: GoogleFonts.nunito(
                          fontSize: 15, color: theme.secondaryText),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy', 'pt_BR').format(end),
                      style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right_rounded,
                        size: 22, color: theme.secondaryText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Cards de métricas (Faturamento, NFS-e, Ticket Médio, Impostos) — 2x2 como na web
  Widget _buildMetricsRow(BuildContext context, NumberFormat currencyFormat) {
    final growth = _model.getRevenueGrowth();
    const spacing = 10.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Faturamento Mensal',
                  currencyFormat.format(_model.currentRevenue),
                  Icons.attach_money_rounded,
                  const Color(0xFF7C4DFF),
                  trend: growth != 0 ? '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%' : null,
                  trendUp: growth >= 0,
                ),
              ),
              const SizedBox(width: spacing),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'NFS-e Emitidas',
                  '${_model.invoicesIssued}',
                  Icons.receipt_long_rounded,
                  const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Ticket Médio',
                  currencyFormat.format(_model.averageTicket),
                  Icons.show_chart_rounded,
                  const Color(0xFF2196F3),
                ),
              ),
              const SizedBox(width: spacing),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Impostos',
                  currencyFormat.format(_model.totalTaxes),
                  Icons.percent_rounded,
                  const Color(0xFFFF9800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor, {
    String? trend,
    bool trendUp = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (trendUp ? const Color(0xFF4CAF50) : const Color(0xFFE53935))
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: trendUp ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: trendUp ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 10,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Seção com gráfico em barras (após os atalhos)
  Widget _buildBarChartSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faturamento por período',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(height: 12),
          _buildRevenueChart(context),
        ],
      ),
    );
  }

  // Seção com gráfico circular (Pago / Pendente / Atrasado)
  Widget _buildPaymentPieSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status dos pagamentos',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentPieChart(context),
        ],
      ),
    );
  }

  // Gráfico circular (donut): Pago, Pendente, Atrasado
  Widget _buildPaymentPieChart(BuildContext context) {
    final paid = _model.paidInvoices;
    final pending = _model.pendingInvoices;
    final overdue = _model.overdueInvoices;
    final total = paid + pending + overdue;

    if (total == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Nenhum título no período',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ),
      );
    }

    const double size = 200;
    final List<_PieSegment> segments = [
      _PieSegment(
        value: paid.toDouble(),
        color: const Color(0xFF4CAF50),
        label: 'Pago',
      ),
      _PieSegment(
        value: pending.toDouble(),
        color: const Color(0xFFFF9800),
        label: 'Pendente',
      ),
      _PieSegment(
        value: overdue.toDouble(),
        color: const Color(0xFFE53935),
        label: 'Atrasado',
      ),
    ].where((s) => s.value > 0).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  segments: segments,
                  total: total.toDouble(),
                  strokeWidth: 28,
                ),
                size: Size(size, size),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...segments.map((s) {
            final pct = total > 0 ? (s.value / total * 100) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: s.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${s.label} — ${pct.toStringAsFixed(0)}%',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ),
                  Text(
                    s.value.toInt().toString(),
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Gráfico de Faturamento em barras
  Widget _buildRevenueChart(BuildContext context) {
    if (_model.chartData.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Nenhum dado para exibir no período',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ),
      );
    }

    final maxValue = _model.chartData
        .map((e) => e['value'] as double)
        .fold(0.0, (a, b) => a > b ? a : b);
    final safeMax = maxValue > 0 ? maxValue : 1.0;
    // Escala “nice” para o eixo Y (ex.: 0, 10K, 20K, 30K)
    double niceMax = safeMax;
    if (niceMax > 1000) {
      niceMax = (niceMax / 1000).ceil() * 1000.0;
    } else if (niceMax > 0) {
      niceMax = niceMax.ceilToDouble();
    }
    const int tickCount = 5;
    final List<double> yTicks = List.generate(
        tickCount, (i) => niceMax * (tickCount - 1 - i) / (tickCount - 1));
    String formatY(double v) {
      if (v >= 1000)
        return '${(v / 1000).toStringAsFixed(v >= 10000 ? 0 : 1)}K';
      return v.toStringAsFixed(0);
    }

    const double chartBarHeight = 160.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimos 6 meses',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Eixo Y: valores (0, 10K, 20K, 30K...)
                SizedBox(
                  height: chartBarHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: yTicks.map((tick) {
                      return Text(
                        formatY(tick),
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _model.chartData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final value = data['value'] as double;
                      final month = data['month'] as String;
                      final heightPercent =
                          niceMax > 0 ? (value / niceMax) : 0.0;
                      // Últimos 6 meses: índice 0 = mais antigo, 5 = mais recente
                      final ref = _model.filterType == 'year'
                          ? DateTime(_model.selectedYear, 12, 1)
                          : DateTime(
                              _model.selectedMonth.year,
                              _model.selectedMonth.month,
                              1,
                            );
                      final target = DateTime(
                        ref.year,
                        ref.month - (5 - index),
                        1,
                      );

                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            context.pushNamed(
                              'nfseList',
                              extra: {
                                'year': target.year,
                                'month': target.month,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: chartBarHeight *
                                      heightPercent.clamp(0.0, 1.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        FlutterFlowTheme.of(context).primary,
                                        FlutterFlowTheme.of(context)
                                            .primary
                                            .withValues(alpha: 0.75),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  month,
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PieSegment {
  final double value;
  final Color color;
  final String label;
  _PieSegment({required this.value, required this.color, required this.label});
}

class _DonutChartPainter extends CustomPainter {
  final List<_PieSegment> segments;
  final double total;
  final double strokeWidth;

  _DonutChartPainter({
    required this.segments,
    required this.total,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - strokeWidth / 2;
    double startAngle = -3.14159265359 / 2;

    for (final s in segments) {
      if (s.value <= 0) continue;
      final sweepAngle = 2 * 3.14159265359 * (s.value / total);
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.total != total;
}
