import '/flutter_flow/flutter_flow_util.dart';
import 'guias_widget.dart' show GuiasWidget;
import 'package:flutter/material.dart';

class GuiasModel extends FlutterFlowModel<GuiasWidget> {
  // Filtros
  DateTime selectedMonth = DateTime.now();
  int selectedYear = DateTime.now().year;
  String filterType = 'month'; // 'month' ou 'year'
  String selectedCategory = 'Todas'; // 'Todas', 'Honorários', 'Guias', 'Impostos'
  
  // Estado
  bool isLoading = false;
  
  // Dados mockados de guias e cobranças
  List<Map<String, dynamic>> getAllGuiasList() {
    return [
      {
        'titulo': 'Honorários Contábeis - Novembro/2025',
        'categoria': 'Honorários',
        'descricao': 'Serviços de contabilidade mensal',
        'valor': 850.00,
        'vencimento': DateTime(2025, 11, 10),
        'status': 'Pendente',
        'arquivo': 'boleto_honorarios_nov.pdf',
      },
      {
        'titulo': 'DARF - IRPJ',
        'categoria': 'Impostos',
        'descricao': 'Imposto de Renda Pessoa Jurídica',
        'valor': 3200.00,
        'vencimento': DateTime(2025, 11, 20),
        'status': 'Pendente',
        'arquivo': 'darf_irpj_nov.pdf',
      },
      {
        'titulo': 'GPS - INSS',
        'categoria': 'Guias',
        'descricao': 'Guia da Previdência Social',
        'valor': 1580.00,
        'vencimento': DateTime(2025, 11, 15),
        'status': 'Pendente',
        'arquivo': 'gps_nov.pdf',
      },
      {
        'titulo': 'DAS - Simples Nacional',
        'categoria': 'Impostos',
        'descricao': 'Documento de Arrecadação do Simples',
        'valor': 2450.00,
        'vencimento': DateTime(2025, 11, 25),
        'status': 'Pendente',
        'arquivo': 'das_nov.pdf',
      },
      {
        'titulo': 'Honorários Contábeis - Outubro/2025',
        'categoria': 'Honorários',
        'descricao': 'Serviços de contabilidade mensal',
        'valor': 850.00,
        'vencimento': DateTime(2025, 10, 10),
        'status': 'Pago',
        'arquivo': 'boleto_honorarios_out.pdf',
      },
      {
        'titulo': 'DARF - CSLL',
        'categoria': 'Impostos',
        'descricao': 'Contribuição Social sobre o Lucro',
        'valor': 1890.00,
        'vencimento': DateTime(2025, 10, 20),
        'status': 'Pago',
        'arquivo': 'darf_csll_out.pdf',
      },
      {
        'titulo': 'FGTS',
        'categoria': 'Guias',
        'descricao': 'Fundo de Garantia por Tempo de Serviço',
        'valor': 980.00,
        'vencimento': DateTime(2025, 10, 7),
        'status': 'Pago',
        'arquivo': 'fgts_out.pdf',
      },
    ];
  }
  
  // Filtra guias por período e categoria
  List<Map<String, dynamic>> getFilteredGuiasList() {
    final allGuias = getAllGuiasList();
    
    return allGuias.where((guia) {
      final vencimento = guia['vencimento'] as DateTime;
      
      // Filtro por período
      bool matchesPeriod = false;
      if (filterType == 'month') {
        matchesPeriod = vencimento.year == selectedMonth.year && 
                       vencimento.month == selectedMonth.month;
      } else {
        matchesPeriod = vencimento.year == selectedYear;
      }
      
      // Filtro por categoria
      bool matchesCategory = selectedCategory == 'Todas' || 
                            guia['categoria'] == selectedCategory;
      
      return matchesPeriod && matchesCategory;
    }).toList();
  }
  
  // Calcula total
  double getTotalValue() {
    final filtered = getFilteredGuiasList();
    return filtered.fold(0.0, (sum, guia) => sum + (guia['valor'] as double));
  }
  
  double getTotalPendente() {
    final filtered = getFilteredGuiasList();
    return filtered
        .where((guia) => guia['status'] == 'Pendente')
        .fold(0.0, (sum, guia) => sum + (guia['valor'] as double));
  }
  
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
  
  void updateMonth(DateTime newMonth) {
    selectedMonth = newMonth;
  }
  
  void updateYear(int newYear) {
    selectedYear = newYear;
  }
  
  void setFilterType(String type) {
    filterType = type;
  }
  
  void setCategory(String category) {
    selectedCategory = category;
  }
}

