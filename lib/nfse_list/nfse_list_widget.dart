import '/app_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/nfse_list_service.dart';
import 'nfse_billing_helpers.dart';
import 'nfse_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
      _model.selectedMonth = DateTime(widget.initialYear!, widget.initialMonth!, 1);
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
    if (_model.filterType == 'range' && _model.rangeStart != null && _model.rangeEnd != null) {
      start = _model.rangeStart!;
      end = _model.rangeEnd!;
    } else if (_model.filterType == 'month') {
      start = DateTime(_model.selectedMonth.year, _model.selectedMonth.month, 1);
      end = DateTime(_model.selectedMonth.year, _model.selectedMonth.month + 1, 0);
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
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
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
            'Minhas NFS-e',
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
                Icons.tune_rounded,
                size: 24,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              onPressed: () => _showFiltersBottomSheet(context),
            ),
            IconButton(
              icon: Icon(
                Icons.search_rounded,
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
            children: [
              // Filtros
              _buildFilters(context),
              
              // Lista de NFS-e
              Expanded(
                child: _buildNfseList(context, currencyFormat, dateFormat),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFilters(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      color: theme.secondaryBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Abas estilo Itaú: Mensal | Anual | Intervalo
          Row(
            children: [
              Expanded(
                child: _buildBankTab(
                  context,
                  'Mensal',
                  _model.filterType == 'month',
                  () {
                    setState(() => _model.setFilterType('month'));
                    _loadNfseList();
                  },
                ),
              ),
              Expanded(
                child: _buildBankTab(
                  context,
                  'Anual',
                  _model.filterType == 'year',
                  () {
                    setState(() => _model.setFilterType('year'));
                    _loadNfseList();
                  },
                ),
              ),
              Expanded(
                child: _buildBankTab(
                  context,
                  'Intervalo',
                  _model.filterType == 'range',
                  () => _showFiltersBottomSheet(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Linha do período: < Março 2025 > ou "dd/MM/yyyy - dd/MM/yyyy" quando intervalo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_model.filterType != 'range') ...[
                InkWell(
                  onTap: () {
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
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: theme.primaryText.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  _model.filterType == 'range' &&
                          _model.rangeStart != null &&
                          _model.rangeEnd != null
                      ? '${DateFormat('dd/MM/yyyy').format(_model.rangeStart!)} - ${DateFormat('dd/MM/yyyy').format(_model.rangeEnd!)}'
                      : _model.filterType == 'month'
                          ? DateFormat('MMMM yyyy', 'pt_BR')
                              .format(_model.selectedMonth)
                          : '${_model.selectedYear}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText,
                  ),
                ),
              ),
              if (_model.filterType != 'range') ...[
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
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
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: theme.primaryText.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: theme.primaryText.withValues(alpha: 0.08)),
        ],
      ),
    );
  }

  Widget _buildBankTab(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
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
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? theme.primaryText
                    : theme.primaryText.withValues(alpha: 0.6),
              ),
            ),
          ),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: isSelected ? theme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    DateTime filterStart = _model.rangeStart ?? DateTime(_model.selectedMonth.year, _model.selectedMonth.month, 1);
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewPadding.bottom),
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
                          icon: Icon(Icons.close, size: 24, color: theme.primaryText),
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
                      if (picked != null) setSheetState(() => filterStart = picked);
                    },
                  ),
                  Divider(height: 1, color: theme.primaryText.withValues(alpha: 0.08)),
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
                      if (picked != null) setSheetState(() => filterEnd = picked);
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
                              side: BorderSide(color: theme.secondaryText.withValues(alpha: 0.4)),
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
                                color: Colors.white,
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

  Widget _buildNfseList(BuildContext context, NumberFormat currencyFormat, DateFormat dateFormat) {
    final nfseList = _model.getFilteredNfseList();

    if (_model.isLoading && nfseList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (nfseList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 80,
              color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma NFS-e encontrada',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma nota fiscal emitida no período selecionado',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
      );
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
          child: _buildNfseCard(context, nfse, currencyFormat, dateFormat),
        );
      },
    );
  }

  Widget _buildNfseCard(
    BuildContext context,
    Map<String, dynamic> nfse,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
  ) {
    final theme = FlutterFlowTheme.of(context);
    final cliente = nfseBillingCliente(nfse);
    final numero = nfseBillingNumeroDisplay(nfse);
    final data = nfseBillingDate(nfse['emission_date']) ??
        nfseBillingDate(nfse['data']) ??
        DateTime.now();
    final valorNum = nfseBillingValor(nfse);

    final subtitle = StringBuffer(dateFormat.format(data));
    if (numero.isNotEmpty && numero != '—') {
      subtitle.write(' · ');
      subtitle.write(numero);
    }

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            NfseDetailWidget.routeName,
            extra: Map<String, dynamic>.from(nfse),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.primaryText.withValues(alpha: 0.07),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              cliente,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                                color: theme.primaryText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            currencyFormat.format(valorNum),
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: theme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: theme.secondaryText.withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

