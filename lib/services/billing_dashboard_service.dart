import '/backend/supabase/supabase.dart';

/// Dados retornados pelo dashboard de faturamento
class BillingDashboardData {
  final double currentRevenue;
  final double previousRevenue;
  final int invoicesIssued;
  final int pendingInvoices;
  final int overdueInvoices;
  final double totalTaxes;
  final double averageTicket;
  final List<Map<String, dynamic>> chartData;

  const BillingDashboardData({
    required this.currentRevenue,
    required this.previousRevenue,
    required this.invoicesIssued,
    required this.pendingInvoices,
    required this.overdueInvoices,
    required this.totalTaxes,
    required this.averageTicket,
    required this.chartData,
  });

  factory BillingDashboardData.empty() => BillingDashboardData(
        currentRevenue: 0,
        previousRevenue: 0,
        invoicesIssued: 0,
        pendingInvoices: 0,
        overdueInvoices: 0,
        totalTaxes: 0,
        averageTicket: 0,
        chartData: [],
      );
}

/// Serviço para buscar dados do dashboard de faturamento da empresa
class BillingDashboardService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Busca dados do dashboard para o período informado.
  /// Usa fn_get_company_billing_dashboard_v2 (valida acesso via company_user_companies quando companyUserId é informado).
  static Future<BillingDashboardData> getCompanyBillingDashboard({
    required String companyId,
    required String startDate,
    required String endDate,
    String? companyUserId,
  }) async {
    try {
      final params = <String, dynamic>{
        'p_company_id': companyId,
        'p_start_date': startDate,
        'p_end_date': endDate,
      };
      if (companyUserId != null && companyUserId.isNotEmpty) {
        params['p_company_user_id'] = companyUserId;
      }
      final response = await _supabase.rpc(
        'fn_get_company_billing_dashboard_v2',
        params: params,
      );

      if (response == null) return BillingDashboardData.empty();

      return _parseResponse(response);
    } catch (_) {
      return BillingDashboardData.empty();
    }
  }

  static BillingDashboardData _parseResponse(dynamic response) {
    if (response is List && response.isNotEmpty) {
      final first = response[0];
      if (first is Map) {
        var data = Map<String, dynamic>.from(first);
        if (data.containsKey('fn_get_company_billing_dashboard')) {
          data = Map<String, dynamic>.from(data['fn_get_company_billing_dashboard'] as Map);
        }
        if (data.containsKey('totalBilling') ||
            data.containsKey('total_billing') ||
            data.containsKey('totalDocuments') ||
            data.containsKey('total_documents')) {
          return _parseMap(data);
        }
      }
      final chartData = response
          .map((e) => Map<String, dynamic>.from(e as Map))
          .map((item) => {
                'month': item['month'] ?? item['month_name'] ?? '',
                'value': _toDouble(item['value'] ?? item['revenue'] ?? 0),
              })
          .toList();
      final totalRevenue =
          chartData.fold<double>(0, (sum, e) => sum + _toDouble(e['value']));
      return BillingDashboardData(
        currentRevenue: totalRevenue,
        previousRevenue: 0,
        invoicesIssued: 0,
        pendingInvoices: 0,
        overdueInvoices: 0,
        totalTaxes: 0,
        averageTicket: 0,
        chartData: chartData,
      );
    }

    if (response is! Map) {
      return BillingDashboardData.empty();
    }

    final data = Map<String, dynamic>.from(response);
    return _parseMap(data);
  }

  static BillingDashboardData _parseMap(Map<String, dynamic> data) {
    final currentRevenue = _toDouble(
        data['totalBilling'] ??
        data['total_billing'] ??
        data['totalNetValue'] ??
        data['total_net_value'] ??
        data['current_revenue'] ??
        data['revenue'] ??
        data['total_revenue'] ??
        0);
    final previousRevenue =
        _toDouble(data['previous_revenue'] ?? data['previousBilling'] ?? 0);
    final invoicesIssued = _toInt(
        data['totalDocuments'] ??
        data['total_documents'] ??
        data['invoices_issued'] ??
        data['invoices_count'] ??
        data['invoices'] ??
        0);
    final pendingInvoices = _toInt(
        data['pending_invoices'] ?? data['pending'] ?? data['pending_count'] ?? 0);
    final overdueInvoices = _toInt(
        data['overdue_invoices'] ?? data['overdue'] ?? data['overdue_count'] ?? 0);
    final totalTaxes = _toDouble(
        data['totalTaxes'] ?? data['total_taxes'] ?? data['taxes'] ?? 0);
    final averageTicket = _toDouble(
        data['averageTicket'] ?? data['average_ticket'] ?? 0);

    List<Map<String, dynamic>> chartData = [];
    final chartRaw = data['chart_data'] ??
        data['monthly_data'] ??
        data['monthly_breakdown'] ??
        data['months'] ??
        data['monthlyBilling'];
    if (chartRaw is List) {
      chartData = chartRaw.map((e) {
        final item = Map<String, dynamic>.from(e as Map);
        return {
          'month': item['month'] ?? item['month_name'] ?? item['label'] ?? '',
          'value': _toDouble(item['value'] ?? item['revenue'] ?? item['total'] ?? 0),
        };
      }).toList();
    }

    return BillingDashboardData(
      currentRevenue: currentRevenue,
      previousRevenue: previousRevenue,
      invoicesIssued: invoicesIssued,
      pendingInvoices: pendingInvoices,
      overdueInvoices: overdueInvoices,
      totalTaxes: totalTaxes,
      averageTicket: averageTicket,
      chartData: chartData,
    );
  }

  static double _toDouble(dynamic v) =>
      v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '0') ?? 0);

  static int _toInt(dynamic v) =>
      v is int ? v : (int.tryParse(v?.toString() ?? '0') ?? 0);
}
