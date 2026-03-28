import '/flutter_flow/flutter_flow_util.dart';
import 'nfse_list_widget.dart' show NfseListWidget;
import 'package:flutter/material.dart';

class NfseListModel extends FlutterFlowModel<NfseListWidget> {
  // Filtros
  DateTime selectedMonth = DateTime.now();
  int selectedYear = DateTime.now().year;
  String filterType = 'month'; // 'month', 'year' ou 'range'
  DateTime? rangeStart;
  DateTime? rangeEnd;

  // Estado
  bool isLoading = false;
  String searchQuery = '';

  /// Lista vinda da API (fn_get_company_nfse_list). Quando preenchida, a tela usa ela em vez do mock.
  List<Map<String, dynamic>> nfseListFromApi = [];

  // Dados mockados de NFS-e emitidas (fallback quando não há companyId)
  List<Map<String, dynamic>> getAllNfseList() {
    return [
      {
        'numero': 'NFS-e 1234',
        'cliente': 'Empresa ABC Ltda',
        'servico': 'Consultoria Financeira',
        'valor': 5500.00,
        'data': DateTime(2025, 11, 15),
        'status': 'Emitida',
      },
      {
        'numero': 'NFS-e 1235',
        'cliente': 'Tech Solutions S.A.',
        'servico': 'Desenvolvimento de Software',
        'valor': 12800.00,
        'data': DateTime(2025, 11, 10),
        'status': 'Emitida',
      },
      {
        'numero': 'NFS-e 1236',
        'cliente': 'Marketing Digital Pro',
        'servico': 'Consultoria de Marketing',
        'valor': 3200.00,
        'data': DateTime(2025, 11, 5),
        'status': 'Emitida',
      },
      {
        'numero': 'NFS-e 1233',
        'cliente': 'Construtora XYZ',
        'servico': 'Auditoria Contábil',
        'valor': 8900.00,
        'data': DateTime(2025, 10, 28),
        'status': 'Emitida',
      },
      {
        'numero': 'NFS-e 1232',
        'cliente': 'Indústria Alpha',
        'servico': 'Consultoria Tributária',
        'valor': 6700.00,
        'data': DateTime(2025, 10, 15),
        'status': 'Emitida',
      },
      {
        'numero': 'NFS-e 1231',
        'cliente': 'Comércio Beta',
        'servico': 'Assessoria Fiscal',
        'valor': 4200.00,
        'data': DateTime(2025, 10, 8),
        'status': 'Emitida',
      },
      {
        'numero': 'NFS-e 1230',
        'cliente': 'Startup Gamma',
        'servico': 'Planejamento Tributário',
        'valor': 9500.00,
        'data': DateTime(2025, 9, 22),
        'status': 'Emitida',
      },
    ];
  }
  
  // Filtra notas por período (usa lista da API se houver; senão mock filtrado)
  List<Map<String, dynamic>> getFilteredNfseList() {
    if (nfseListFromApi.isNotEmpty) return nfseListFromApi;

    final allNfse = getAllNfseList();
    return allNfse.where((nfse) {
      final data = nfse['data'] as DateTime;
      final date = DateTime(data.year, data.month, data.day);

      if (filterType == 'range' && rangeStart != null && rangeEnd != null) {
        final start = DateTime(rangeStart!.year, rangeStart!.month, rangeStart!.day);
        final end = DateTime(rangeEnd!.year, rangeEnd!.month, rangeEnd!.day);
        return !date.isBefore(start) && !date.isAfter(end);
      }
      if (filterType == 'month') {
        return data.year == selectedMonth.year && data.month == selectedMonth.month;
      }
      return data.year == selectedYear;
    }).toList();
  }

  void setDateRange(DateTime start, DateTime end) {
    filterType = 'range';
    rangeStart = start;
    rangeEnd = end;
  }

  void clearDateRange() {
    filterType = 'month';
    selectedMonth = DateTime.now();
    selectedYear = DateTime.now().year;
    rangeStart = null;
    rangeEnd = null;
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
}

