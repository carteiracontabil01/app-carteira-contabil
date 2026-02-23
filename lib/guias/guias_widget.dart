import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
            'Guias e Cobranças',
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
                Icons.description,
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
              // Resumo
              _buildSummary(context, currencyFormat),
              
              // Filtros
              _buildFilters(context),
              
              // Lista de Guias
              Expanded(
                child: _buildGuiasList(context, currencyFormat, dateFormat),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSummary(BuildContext context, NumberFormat currencyFormat) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Pendente',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(_model.getTotalPendente()),
            style: GoogleFonts.nunito(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Column(
        children: [
          // Filtro de período
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
          // Seletor de mês/ano
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
          const SizedBox(height: 12),
          // Filtro de categoria
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('Todas'),
                _buildCategoryChip('Honorários'),
                _buildCategoryChip('Guias'),
                _buildCategoryChip('Impostos'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildCategoryChip(String category) {
    final isSelected = _model.selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _model.setCategory(category);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            category,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ),
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
  
  Widget _buildGuiasList(BuildContext context, NumberFormat currencyFormat, DateFormat dateFormat) {
    final guiasList = _model.getFilteredGuiasList();
    
    if (guiasList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma guia encontrada',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhum documento no período selecionado',
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
      itemCount: guiasList.length,
      itemBuilder: (context, index) {
        final guia = guiasList[index];
        return _buildGuiaCard(context, guia, currencyFormat, dateFormat);
      },
    );
  }
  
  Widget _buildGuiaCard(
    BuildContext context,
    Map<String, dynamic> guia,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
  ) {
    final isPendente = guia['status'] == 'Pendente';
    final statusColor = isPendente ? const Color(0xFFFF9800) : const Color(0xFF4CAF50);
    
    Color categoryColor;
    IconData categoryIcon;
    
    switch (guia['categoria']) {
      case 'Honorários':
        categoryColor = const Color(0xFF2196F3);
        categoryIcon = Icons.person_outline;
        break;
      case 'Guias':
        categoryColor = const Color(0xFF9C27B0);
        categoryIcon = Icons.receipt_long;
        break;
      case 'Impostos':
        categoryColor = const Color(0xFFFF5722);
        categoryIcon = Icons.account_balance;
        break;
      default:
        categoryColor = FlutterFlowTheme.of(context).primary;
        categoryIcon = Icons.description;
    }
    
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
            // Abrir/baixar PDF
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        categoryIcon,
                        size: 24,
                        color: categoryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guia['titulo'],
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            guia['descricao'],
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Venc: ${dateFormat.format(guia['vencimento'])}',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            guia['status'],
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(guia['valor']),
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.download,
                              size: 14,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'PDF',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ],
                        ),
                      ],
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

