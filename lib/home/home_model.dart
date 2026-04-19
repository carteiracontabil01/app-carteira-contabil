import '/flutter_flow/flutter_flow_util.dart';
import '/services/billing_dashboard_service.dart';
import 'models/home_company_option.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  // Estado de filtros
  DateTime selectedMonth = DateTime.now();
  int selectedYear = DateTime.now().year;
  DateTime? rangeStart; // usado quando filterType == 'range'
  DateTime? rangeEnd;
  String filterType = 'month'; // 'month', 'year' ou 'range'
  bool isRevenueVisible = true; // Controla visibilidade do faturamento
  bool isLoading = false;

  // Dados vindos do fn_get_company_billing_dashboard (substitui mock)
  // Fallback mock apenas para desenvolvimento sem API
  final Map<int, Map<int, Map<String, dynamic>>> _mockData = {
    2023: {
      1: {'revenue': 28500.00, 'invoices': 8, 'pending': 2},
      2: {'revenue': 31200.50, 'invoices': 9, 'pending': 1},
      3: {'revenue': 29800.00, 'invoices': 10, 'pending': 3},
      4: {'revenue': 33500.75, 'invoices': 11, 'pending': 2},
      5: {'revenue': 35100.00, 'invoices': 12, 'pending': 1},
      6: {'revenue': 32450.00, 'invoices': 10, 'pending': 4},
      7: {'revenue': 38920.45, 'invoices': 13, 'pending': 2},
      8: {'revenue': 35200.80, 'invoices': 11, 'pending': 3},
      9: {'revenue': 42100.50, 'invoices': 14, 'pending': 1},
      10: {'revenue': 39800.20, 'invoices': 12, 'pending': 2},
      11: {'revenue': 45750.89, 'invoices': 15, 'pending': 3},
      12: {'revenue': 52300.00, 'invoices': 18, 'pending': 2},
    },
    2024: {
      1: {'revenue': 48200.00, 'invoices': 15, 'pending': 3},
      2: {'revenue': 51500.50, 'invoices': 16, 'pending': 2},
      3: {'revenue': 49800.00, 'invoices': 14, 'pending': 4},
      4: {'revenue': 53500.75, 'invoices': 17, 'pending': 1},
      5: {'revenue': 55100.00, 'invoices': 18, 'pending': 2},
      6: {'revenue': 52450.00, 'invoices': 16, 'pending': 3},
      7: {'revenue': 58920.45, 'invoices': 19, 'pending': 2},
      8: {'revenue': 55200.80, 'invoices': 17, 'pending': 5},
      9: {'revenue': 62100.50, 'invoices': 20, 'pending': 1},
      10: {'revenue': 59800.20, 'invoices': 18, 'pending': 3},
      11: {'revenue': 65750.89, 'invoices': 21, 'pending': 2},
      12: {'revenue': 72300.00, 'invoices': 24, 'pending': 4},
    },
    2025: {
      1: {'revenue': 68200.00, 'invoices': 20, 'pending': 3},
      2: {'revenue': 71500.50, 'invoices': 22, 'pending': 2},
      3: {'revenue': 69800.00, 'invoices': 21, 'pending': 4},
      4: {'revenue': 73500.75, 'invoices': 23, 'pending': 1},
      5: {'revenue': 75100.00, 'invoices': 24, 'pending': 3},
      6: {'revenue': 72450.00, 'invoices': 22, 'pending': 2},
      7: {'revenue': 78920.45, 'invoices': 25, 'pending': 3},
      8: {'revenue': 75200.80, 'invoices': 23, 'pending': 2},
      9: {'revenue': 82100.50, 'invoices': 26, 'pending': 1},
      10: {'revenue': 79800.20, 'invoices': 24, 'pending': 3},
      11: {'revenue': 85750.89, 'invoices': 27, 'pending': 2},
      12: {'revenue': 92300.00, 'invoices': 30, 'pending': 4},
    },
  };
  
  // Dados do dashboard (API ou fallback mock)
  double currentRevenue = 0;
  double previousRevenue = 0;
  int invoicesIssued = 0;
  int pendingInvoices = 0;
  int overdueInvoices = 0;
  double totalTaxes = 0;
  double averageTicket = 0;
  List<Map<String, dynamic>> chartData = [];

  /// Lista de empresas do usuário (para dropdown)
  List<HomeCompanyOption> userCompanies = [];

  /// Atualiza os dados a partir da resposta da API
  void setDashboardData(BillingDashboardData data) {
    currentRevenue = data.currentRevenue;
    previousRevenue = data.previousRevenue;
    invoicesIssued = data.invoicesIssued;
    pendingInvoices = data.pendingInvoices;
    overdueInvoices = data.overdueInvoices;
    totalTaxes = data.totalTaxes;
    averageTicket = data.averageTicket;
    chartData = data.chartData;
  }

  /// Quantidade de documentos considerados "pagos" (emitidos e não pendentes/atrasados)
  int get paidInvoices => (invoicesIssued - pendingInvoices - overdueInvoices).clamp(0, 1 << 30);

  /// Usa dados mock quando API não retorna dados (fallback)
  void useMockData() {
    _updateData();
  }

  @override
  void initState(BuildContext context) {
    // Dados serão carregados via API no widget
  }

  @override
  void dispose() {}
  
  // Métodos auxiliares
  double getRevenueGrowth() {
    if (previousRevenue == 0) return 0;
    return ((currentRevenue - previousRevenue) / previousRevenue) * 100;
  }
  
  void updateMonth(DateTime newMonth) {
    selectedMonth = newMonth;
  }

  void updateYear(int newYear) {
    selectedYear = newYear;
  }

  void setFilterType(String type) {
    filterType = type;
    if (type == 'range' && (rangeStart == null || rangeEnd == null)) {
      final now = DateTime.now();
      rangeStart = DateTime(now.year, now.month, 1);
      rangeEnd = DateTime(now.year, now.month + 1, 0);
    }
  }

  void setDateRange(DateTime start, DateTime end) {
    rangeStart = start;
    rangeEnd = end;
  }

  void toggleRevenueVisibility() {
    isRevenueVisible = !isRevenueVisible;
  }
  
  // Atualiza os dados baseado no filtro atual
  void _updateData() {
    if (filterType == 'month') {
      _updateMonthlyData();
    } else {
      _updateYearlyData();
    }
  }
  
  // Atualiza dados para visualização mensal
  void _updateMonthlyData() {
    final year = selectedMonth.year;
    final month = selectedMonth.month;
    
    // Dados do mês atual
    final currentData = _getMonthData(year, month);
    currentRevenue = currentData['revenue'];
    invoicesIssued = currentData['invoices'];
    pendingInvoices = currentData['pending'];
    
    // Dados do mês anterior para cálculo de crescimento
    final previousMonth = month == 1 ? 12 : month - 1;
    final previousYear = month == 1 ? year - 1 : year;
    final previousData = _getMonthData(previousYear, previousMonth);
    previousRevenue = previousData['revenue'];
    
    // Gera dados para gráfico (últimos 6 meses)
    chartData = _generateMonthlyChartData(year, month);
  }
  
  // Atualiza dados para visualização anual
  void _updateYearlyData() {
    final year = selectedYear;
    
    // Calcula total do ano
    double yearRevenue = 0;
    int yearInvoices = 0;
    int yearPending = 0;
    
    if (_mockData.containsKey(year)) {
      _mockData[year]!.forEach((month, data) {
        yearRevenue += data['revenue'] as double;
        yearInvoices += data['invoices'] as int;
        yearPending += data['pending'] as int;
      });
    }
    
    currentRevenue = yearRevenue;
    invoicesIssued = yearInvoices;
    pendingInvoices = yearPending;
    
    // Dados do ano anterior para cálculo de crescimento
    double previousYearRevenue = 0;
    if (_mockData.containsKey(year - 1)) {
      _mockData[year - 1]!.forEach((month, data) {
        previousYearRevenue += data['revenue'] as double;
      });
    }
    previousRevenue = previousYearRevenue;
    
    // Gera dados para gráfico (12 meses do ano selecionado)
    chartData = _generateYearlyChartData(year);
  }
  
  // Obtém dados de um mês específico
  Map<String, dynamic> _getMonthData(int year, int month) {
    if (_mockData.containsKey(year) && _mockData[year]!.containsKey(month)) {
      return _mockData[year]![month]!;
    }
    // Retorna dados padrão se não existir
    return {'revenue': 0.0, 'invoices': 0, 'pending': 0};
  }
  
  // Gera dados para gráfico mensal (últimos 6 meses)
  List<Map<String, dynamic>> _generateMonthlyChartData(int year, int month) {
    final List<Map<String, dynamic>> data = [];
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    
    for (int i = 5; i >= 0; i--) {
      int targetMonth = month - i;
      int targetYear = year;
      
      while (targetMonth <= 0) {
        targetMonth += 12;
        targetYear -= 1;
      }
      
      final monthData = _getMonthData(targetYear, targetMonth);
      data.add({
        'month': months[targetMonth - 1],
        'value': monthData['revenue'],
      });
    }
    
    return data;
  }
  
  // Gera dados para gráfico anual (12 meses)
  List<Map<String, dynamic>> _generateYearlyChartData(int year) {
    final List<Map<String, dynamic>> data = [];
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    
    for (int month = 1; month <= 12; month++) {
      final monthData = _getMonthData(year, month);
      data.add({
        'month': months[month - 1],
        'value': monthData['revenue'],
      });
    }
    
    return data;
  }
}
