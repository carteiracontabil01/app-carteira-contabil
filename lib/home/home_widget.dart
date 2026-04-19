import '/app_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/billing_dashboard_service.dart';
import '/services/company_profile_service.dart';
import '/services/company_user_profile_service.dart';
import '/certificados_digitais/certificados_digitais_widget.dart';
import '/company_documents/company_documents_widget.dart';
import 'models/home_company_option.dart';
import 'models/home_period_selection.dart';
import 'widgets/home_company_switcher_menu.dart';
import 'widgets/home_metrics_grid.dart';
import 'widgets/home_payment_status_section.dart';
import 'widgets/home_period_bottom_sheet.dart';
import 'widgets/home_quick_actions_menu.dart';
import 'widgets/home_revenue_card.dart';
import 'widgets/home_revenue_chart_section.dart';
import 'widgets/home_welcome_section.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _syncCompanyProfileIfNeeded();
      await _loadUserCompanies();
      await _loadDashboardData();
    });
  }

  /// Garante snapshot da view da empresa alinhado ao [FFAppState] (cold start / prefs).
  Future<void> _syncCompanyProfileIfNeeded() async {
    final appState = context.read<FFAppState>();
    final cid = appState.companyId;
    final cuid = appState.companyUserId;
    if (cid == null || cid.isEmpty || cuid == null || cuid.isEmpty) return;
    final prof = appState.companyProfile;
    if (prof != null && prof['id']?.toString() == cid) return;
    await CompanyProfileService.refreshIntoAppState(
      companyId: cid,
      companyUserId: cuid,
    );
    if (mounted) safeSetState(() {});
  }

  /// Carrega lista de empresas do usuário para o dropdown
  Future<void> _loadUserCompanies() async {
    final appState = context.read<FFAppState>();
    final companies = appState.userCompanies
        .map((e) => HomeCompanyOption.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    _model.userCompanies = companies;

    if ((appState.companyName == null || appState.companyName!.isEmpty) &&
        companies.isNotEmpty &&
        appState.companyId != null) {
      for (final item in companies) {
        if (item.companyId == appState.companyId) {
          appState.companyName = item.businessName;
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

    if (companyId == null || companyId.isEmpty) {
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
    final theme = FlutterFlowTheme.of(context);
    final currencyFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final percentFormat = NumberFormat.decimalPattern('pt_BR');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.grayscale20,
        appBar: AppBar(
          backgroundColor: theme.primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 68,
          titleSpacing: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: SizedBox(
            width: 182,
            height: 40,
            child: ClipRect(
              child: Transform.translate(
                offset: const Offset(-16, 0),
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.cover,
                  child: Image.asset(
                    'assets/images/ic_carteira_contabil_white.png',
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
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
                color: theme.tertiary,
                size: 21,
              ),
            ),
            IconButton(
              tooltip: 'Chat',
              onPressed: () => context.pushNamed('chat'),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: theme.tertiary,
                size: 21,
              ),
            ),
            IconButton(
              onPressed: () => context.pushNamed('notificacoes'),
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.tertiary,
                size: 21,
              ),
            ),
          ],
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: theme.tertiary.withOpacity(0.22)),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.grayscale10,
                    theme.grayscale20,
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(context),
                      const SizedBox(height: 16),
                      HomeRevenueCard(
                        revenueLabel:
                            currencyFormat.format(_model.currentRevenue),
                        isRevenueVisible: _model.isRevenueVisible,
                        growthLabel: _growthLabel(percentFormat),
                        isGrowthPositive: _model.getRevenueGrowth() >= 0,
                        comparisonLabel: _model.filterType == 'month'
                            ? 'vs mês anterior'
                            : 'vs ano anterior',
                        periodSubtitle: _periodSubtitle(),
                        onPeriodTap: () => _showPeriodBottomSheet(context),
                      ),
                      const SizedBox(height: 16),
                      _buildHomeQuickActionsMenu(context),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Indicadores financeiros',
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Resumo do desempenho da empresa no período',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMetricsRow(context, currencyFormat),
                      const SizedBox(height: 20),
                      HomeRevenueChartSection(
                        chartData: _model.chartData,
                        filterType: _model.filterType,
                        selectedMonth: _model.selectedMonth,
                        selectedYear: _model.selectedYear,
                        isRevenueVisible: _model.isRevenueVisible,
                        onBarTap: (year, month) {
                          context.pushNamed(
                            'nfseList',
                            extra: {
                              'year': year,
                              'month': month,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      HomePaymentStatusSection(
                        paidInvoices: _model.paidInvoices,
                        pendingInvoices: _model.pendingInvoices,
                        overdueInvoices: _model.overdueInvoices,
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
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
    final appState = context.watch<FFAppState>();
    final companies = _model.userCompanies;
    final companyName =
        (appState.companyName != null && appState.companyName!.isNotEmpty)
            ? appState.companyName!
            : 'Empresa';
    final companyPhotoUrl = _resolveCompanyPhotoUrl(appState.companyProfile);

    return Builder(
      builder: (buttonContext) => HomeWelcomeSection(
        key: ValueKey<String>(
          'tenant_menu_${appState.companyId ?? (companies.isNotEmpty ? companies.first.companyId : 'none')}',
        ),
        companyName: companyName,
        companyPhotoUrl: companyPhotoUrl,
        hasCompanySwitcher: companies.isNotEmpty,
        onAvatarTap: () => context.pushNamed('perfil'),
        onCompanyTap: companies.isNotEmpty
            ? () => _handleCompanySwitcherTap(
                  buttonContext,
                  companies,
                )
            : null,
      ),
    );
  }

  String? _resolveCompanyPhotoUrl(Map<String, dynamic>? profile) {
    if (profile == null || !profile.containsKey('photo_url')) return null;

    final raw = profile['photo_url']?.toString().trim() ?? '';
    if (raw.isEmpty || raw == 'null') return null;
    return raw;
  }

  Future<void> _handleCompanySwitcherTap(
    BuildContext buttonContext,
    List<HomeCompanyOption> companies,
  ) async {
    final item = await showHomeCompanySwitcherMenu(buttonContext, companies);
    if (!mounted || item == null) return;
    final st = context.read<FFAppState>();
    st.setCompanyContext(
      item.companyUserId,
      item.companyId,
      item.businessName.isEmpty ? 'Empresa' : item.businessName,
    );
    await CompanyUserProfileService.refreshIntoAppState(
      companyUserId: item.companyUserId,
    );
    // O setCompanyContext já dispara rebuild global e recria a Home (key por companyId).
    // O bootstrap da nova instância (_sync -> _loadUserCompanies -> _loadDashboardData)
    // deve ser o único caminho de refresh para evitar chamadas duplicadas.
  }

  /// Atalhos com ícone abaixo do faturamento; acrescente novos [SizedBox] no [Wrap].
  Widget _buildHomeQuickActionsMenu(BuildContext context) {
    return HomeQuickActionsMenu(
      actions: [
        HomeQuickActionItem(
          icon: Icons.badge_outlined,
          label: 'Certificados',
          onTap: () => context.pushNamed(CertificadosDigitaisWidget.routeName),
        ),
        HomeQuickActionItem(
          icon: Icons.folder_copy_outlined,
          label: 'Documentos',
          onTap: () => context.pushNamed(CompanyDocumentsWidget.routeName),
        ),
        HomeQuickActionItem(
          icon: Icons.warning_amber_rounded,
          label: 'Pendências',
          onTap: () => context.pushNamed('notificacoes'),
        ),
        HomeQuickActionItem(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Guias e Impostos',
          onTap: () => context.pushNamed('guias'),
        ),
      ],
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

  String _growthLabel(NumberFormat percentFormat) {
    final growth = _model.getRevenueGrowth();
    final signal = growth >= 0 ? '+' : '';
    return '$signal${percentFormat.format(growth.abs())}%';
  }

  void _showPeriodBottomSheet(BuildContext context) {
    _handlePeriodBottomSheetResult(context);
  }

  Future<void> _handlePeriodBottomSheetResult(BuildContext context) async {
    final selection = await showHomePeriodBottomSheet(
      context,
      currentFilterType: _model.filterType,
      currentMonth: _model.selectedMonth,
      currentYear: _model.selectedYear,
      currentRangeStart: _model.rangeStart,
      currentRangeEnd: _model.rangeEnd,
    );
    if (!mounted || selection == null) return;

    _applyPeriodSelection(selection);
    await _loadDashboardData();
  }

  void _applyPeriodSelection(HomePeriodSelection selection) {
    setState(() {
      if (selection.filterType == 'month') {
        _model.setFilterType('month');
        _model.updateMonth(selection.selectedMonth);
      } else if (selection.filterType == 'year') {
        _model.setFilterType('year');
        _model.updateYear(selection.selectedYear);
      } else {
        _model.setFilterType('range');
        _model.setDateRange(selection.rangeStart!, selection.rangeEnd!);
      }
    });
  }

  // Cards de métricas (Faturamento, NFS-e, Ticket Médio, Impostos) — 2x2 como na web
  Widget _buildMetricsRow(BuildContext context, NumberFormat currencyFormat) {
    final growth = _model.getRevenueGrowth();
    return HomeMetricsGrid(
      metrics: [
        HomeMetricItem(
          label: 'Faturamento Mensal',
          value: _model.isRevenueVisible
              ? currencyFormat.format(_model.currentRevenue)
              : 'R\$ •••••',
          iconAssetPath: 'assets/images/ic_cash_green.png',
          iconColor: FlutterFlowTheme.of(context).primary,
          trend: _model.isRevenueVisible && growth != 0
              ? '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%'
              : null,
          trendUp: growth >= 0,
        ),
        HomeMetricItem(
          label: 'NFS-e Emitidas',
          value: '${_model.invoicesIssued}',
          iconAssetPath: 'assets/images/ic_nfse_green.png',
          iconColor: FlutterFlowTheme.of(context).success,
        ),
        HomeMetricItem(
          label: 'Ticket Médio',
          value: _model.isRevenueVisible
              ? currencyFormat.format(_model.averageTicket)
              : 'R\$ •••••',
          iconAssetPath: 'assets/images/ic_porcentagem_green.png',
          iconColor: FlutterFlowTheme.of(context).secondary,
        ),
        HomeMetricItem(
          label: 'Impostos',
          value: _model.isRevenueVisible
              ? currencyFormat.format(_model.totalTaxes)
              : 'R\$ •••••',
          iconAssetPath: 'assets/images/ic_payin_green.png',
          iconColor: FlutterFlowTheme.of(context).primary,
        ),
      ],
    );
  }
}
