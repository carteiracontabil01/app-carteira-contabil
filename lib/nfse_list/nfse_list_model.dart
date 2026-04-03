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
  /// Carregando próxima página (fn_get_company_billing_paginated_v2).
  bool billingLoadingMore = false;
  bool billingHasNext = false;
  /// Última página carregada com sucesso (para pedir a próxima).
  int billingLastLoadedPage = 0;

  /// Lista vinda da API (fn_get_company_billing_paginated_v2, paginada).
  List<Map<String, dynamic>> nfseListFromApi = [];

  List<Map<String, dynamic>> getFilteredNfseList() => nfseListFromApi;

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

