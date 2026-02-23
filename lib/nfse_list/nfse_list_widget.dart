import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'nfse_list_model.dart';
export 'nfse_list_model.dart';

class NfseListWidget extends StatefulWidget {
  const NfseListWidget({super.key});

  static String routeName = 'nfseList';
  static String routePath = 'nfse-list';

  @override
  State<NfseListWidget> createState() => _NfseListWidgetState();
}

class _NfseListWidgetState extends State<NfseListWidget> {
  late NfseListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NfseListModel());
  }

  @override
  void dispose() {
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
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Minhas NFS-e',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 26,
              ),
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
    return Container(
      padding: const EdgeInsets.all(16),
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFilterButton(
                  context,
                  'Mensal',
                  Icons.calendar_month,
                  _model.filterType == 'month',
                  () {
                    setState(() {
                      _model.setFilterType('month');
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterButton(
                  context,
                  'Anual',
                  Icons.calendar_today,
                  _model.filterType == 'year',
                  () {
                    setState(() {
                      _model.setFilterType('year');
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 20,
                  buttonSize: 36,
                  icon: Icon(
                    Icons.chevron_left,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_model.filterType == 'month') {
                        _model.updateMonth(
                          DateTime(_model.selectedMonth.year, _model.selectedMonth.month - 1),
                        );
                      } else {
                        _model.updateYear(_model.selectedYear - 1);
                      }
                    });
                  },
                ),
                Text(
                  _model.filterType == 'month'
                      ? DateFormat('MMMM yyyy', 'pt_BR').format(_model.selectedMonth)
                      : '${_model.selectedYear}',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 20,
                  buttonSize: 36,
                  icon: Icon(
                    Icons.chevron_right,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_model.filterType == 'month') {
                        _model.updateMonth(
                          DateTime(_model.selectedMonth.year, _model.selectedMonth.month + 1),
                        );
                      } else {
                        _model.updateYear(_model.selectedYear + 1);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNfseList(BuildContext context, NumberFormat currencyFormat, DateFormat dateFormat) {
    final nfseList = _model.getFilteredNfseList();
    
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
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: nfseList.length,
      itemBuilder: (context, index) {
        final nfse = nfseList[index];
        return _buildNfseCard(context, nfse, currencyFormat, dateFormat);
      },
    );
  }
  
  Widget _buildNfseCard(
    BuildContext context,
    Map<String, dynamic> nfse,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Abrir detalhes da NFS-e
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nfse['numero'],
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nfse['cliente'],
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        nfse['status'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  nfse['servico'],
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateFormat.format(nfse['data']),
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      currencyFormat.format(nfse['valor']),
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

