import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/nfse_list_service.dart';
import 'nfse_detail_widget.dart';
import 'widgets/nfse_list_empty_state.dart';
import 'widgets/nfse_list_filter_panel.dart';
import 'widgets/nfse_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'nfse_list_model.dart';
export 'nfse_list_model.dart';

class NfseListWidget extends StatefulWidget {
  const NfseListWidget({
    super.key,
    this.initialYear,
    this.initialMonth,
  });

  static String routeName = 'nfseList';
  static String routePath = 'nfse-list';

  /// Ao abrir a partir do gráfico da home (clique no mês), filtra por este ano/mês.
  final int? initialYear;
  final int? initialMonth;

  @override
  State<NfseListWidget> createState() => _NfseListWidgetState();
}

class _NfseListWidgetState extends State<NfseListWidget> {
  late NfseListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NfseListModel());
    if (widget.initialYear != null && widget.initialMonth != null) {
      _model.selectedYear = widget.initialYear!;
      _model.selectedMonth =
          DateTime(widget.initialYear!, widget.initialMonth!, 1);
      _model.setFilterType('month');
    }
    _scrollController.addListener(_onBillingScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadNfseList());
  }

  void _onBillingScroll() {
    if (!_scrollController.hasClients) return;
    final companyId = context.read<FFAppState>().companyId;
    if (companyId == null || companyId.isEmpty) return;
    if (!_model.billingHasNext ||
        _model.billingLoadingMore ||
        _model.isLoading) {
      return;
    }
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 280) {
      _loadNfseList(append: true);
    }
  }

  /// Carrega NFS-e via [fn_get_company_billing_paginated_v2]. Sem `companyId` a lista fica vazia.
  Future<void> _loadNfseList({bool append = false}) async {
    final appState = context.read<FFAppState>();
    final companyId = appState.companyId;
    if (companyId == null || companyId.isEmpty) {
      _model.nfseListFromApi = [];
      _model.billingHasNext = false;
      _model.billingLastLoadedPage = 0;
      if (mounted) setState(() {});
      return;
    }
    if (append) {
      if (!_model.billingHasNext ||
          _model.billingLoadingMore ||
          _model.isLoading) {
        return;
      }
    }

    DateTime start;
    DateTime end;
    if (_model.filterType == 'range' &&
        _model.rangeStart != null &&
        _model.rangeEnd != null) {
      start = _model.rangeStart!;
      end = _model.rangeEnd!;
    } else if (_model.filterType == 'month') {
      start =
          DateTime(_model.selectedMonth.year, _model.selectedMonth.month, 1);
      end = DateTime(
          _model.selectedMonth.year, _model.selectedMonth.month + 1, 0);
    } else {
      start = DateTime(_model.selectedYear, 1, 1);
      end = DateTime(_model.selectedYear, 12, 31);
    }

    final page = append ? _model.billingLastLoadedPage + 1 : 1;

    if (append) {
      _model.billingLoadingMore = true;
    } else {
      _model.isLoading = true;
      _model.billingLastLoadedPage = 0;
    }
    if (mounted) setState(() {});

    final result = await NfseListService.getCompanyBillingPaginated(
      companyId: companyId,
      page: page,
      pageSize: NfseListService.defaultPageSize,
      startDate: start,
      endDate: end,
      companyUserId: appState.companyUserId,
    );

    if (!mounted) return;

    if (append) {
      _model.nfseListFromApi.addAll(result.rows);
      _model.billingLoadingMore = false;
    } else {
      _model.nfseListFromApi = List<Map<String, dynamic>>.from(result.rows);
      _model.isLoading = false;
    }
    _model.billingLastLoadedPage = result.page;
    _model.billingHasNext = result.hasNext;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onBillingScroll);
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).grayscale20,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 68,
          titleSpacing: 16,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Minhas NFS-e',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: FlutterFlowTheme.of(context).tertiary,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Chat',
              onPressed: () => context.pushNamed('chat'),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 24,
                color: FlutterFlowTheme.of(context).tertiary,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.tune_rounded,
                size: 24,
                color: FlutterFlowTheme.of(context).tertiary,
              ),
              onPressed: () => _showFiltersBottomSheet(context),
            ),
            IconButton(
              icon: Icon(
                Icons.search_rounded,
                size: 24,
                color: FlutterFlowTheme.of(context).tertiary,
              ),
              onPressed: () {},
            ),
          ],
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color:
                  FlutterFlowTheme.of(context).tertiary.withValues(alpha: 0.22),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  FlutterFlowTheme.of(context).grayscale10,
                  FlutterFlowTheme.of(context).grayscale20,
                ],
              ),
            ),
            child: Column(
              children: [
                _buildFilters(context),
                Expanded(
                  child: _buildNfseList(context, currencyFormat, dateFormat),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return NfseListFilterPanel(
      filterType: _model.filterType,
      selectedMonth: _model.selectedMonth,
      selectedYear: _model.selectedYear,
      rangeStart: _model.rangeStart,
      rangeEnd: _model.rangeEnd,
      onSelectMonth: () {
        setState(() => _model.setFilterType('month'));
        _loadNfseList();
      },
      onSelectYear: () {
        setState(() => _model.setFilterType('year'));
        _loadNfseList();
      },
      onSelectRange: () => _showFiltersBottomSheet(context),
      onPreviousPeriod: () {
        setState(() {
          if (_model.filterType == 'month') {
            _model.updateMonth(DateTime(
              _model.selectedMonth.year,
              _model.selectedMonth.month - 1,
            ));
          } else {
            _model.updateYear(_model.selectedYear - 1);
          }
        });
        _loadNfseList();
      },
      onNextPeriod: () {
        setState(() {
          if (_model.filterType == 'month') {
            _model.updateMonth(DateTime(
              _model.selectedMonth.year,
              _model.selectedMonth.month + 1,
            ));
          } else {
            _model.updateYear(_model.selectedYear + 1);
          }
        });
        _loadNfseList();
      },
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    DateTime filterStart = _model.rangeStart ??
        DateTime(_model.selectedMonth.year, _model.selectedMonth.month, 1);
    DateTime filterEnd = _model.rangeEnd ?? DateTime.now();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewPadding.bottom),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.secondaryText.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filtros',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme.primaryText,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close,
                              size: 24, color: theme.primaryText),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Personalizar período',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Defina a data inicial e final para filtrar as NFS-e.',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterDateRow(
                    ctx,
                    theme,
                    'Data inicial',
                    filterStart,
                    () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: filterStart,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null)
                        setSheetState(() => filterStart = picked);
                    },
                  ),
                  Divider(
                      height: 1,
                      color: theme.primaryText.withValues(alpha: 0.08)),
                  _buildFilterDateRow(
                    ctx,
                    theme,
                    'Data final',
                    filterEnd,
                    () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: filterEnd,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null)
                        setSheetState(() => filterEnd = picked);
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _model.clearDateRange();
                              setState(() {});
                              _loadNfseList();
                              Navigator.of(ctx).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                  color: theme.secondaryText
                                      .withValues(alpha: 0.4)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Redefinir',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              if (filterStart.isAfter(filterEnd)) {
                                final t = filterStart;
                                filterStart = filterEnd;
                                filterEnd = t;
                              }
                              _model.setDateRange(filterStart, filterEnd);
                              setState(() {});
                              _loadNfseList();
                              Navigator.of(ctx).pop();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Filtrar',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: theme.tertiary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterDateRow(
    BuildContext context,
    FlutterFlowTheme theme,
    String label,
    DateTime value,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 20,
                color: theme.secondaryText,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('dd/MM/yyyy').format(value),
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: theme.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNfseList(BuildContext context, NumberFormat currencyFormat,
      DateFormat dateFormat) {
    final nfseList = _model.getFilteredNfseList();

    if (_model.isLoading && nfseList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (nfseList.isEmpty) {
      return const NfseListEmptyState();
    }

    final extraFooter = _model.billingLoadingMore ? 1 : 0;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: nfseList.length + extraFooter,
      itemBuilder: (context, index) {
        if (index >= nfseList.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          );
        }
        final nfse = nfseList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NfseListItemCard(
            nfse: nfse,
            currencyFormat: currencyFormat,
            dateFormat: dateFormat,
            onTap: () {
              context.pushNamed(
                NfseDetailWidget.routeName,
                extra: Map<String, dynamic>.from(nfse),
              );
            },
          ),
        );
      },
    );
  }
}
