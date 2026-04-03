import '/backend/supabase/supabase.dart';

double _nfseToDouble(dynamic v) =>
    v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '0') ?? 0);

/// Retorno: lista de NFS-e para a tela Minhas NFS-e
class NfseListItem {
  final String id;
  final String numero;
  final String cliente;
  final String servico;
  final double valor;
  final DateTime data;
  final String status;

  NfseListItem({
    required this.id,
    required this.numero,
    required this.cliente,
    required this.servico,
    required this.valor,
    required this.data,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'numero': numero,
        'cliente': cliente,
        'servico': servico,
        'valor': valor,
        'data': data,
        'status': status,
      };

  /// Mapeia um item de [fn_get_company_billing_paginated_v2] (campo `data`[]).
  factory NfseListItem.fromBillingRow(Map<String, dynamic> map) {
    final params = map['parameters'];
    String servico = '';
    if (params is Map) {
      final p = Map<String, dynamic>.from(params);
      servico = p['service_description']?.toString() ?? '';
    }
    final emission = map['emission_date'];
    DateTime data;
    if (emission is DateTime) {
      data = emission;
    } else {
      final s = emission?.toString();
      data = (s != null && s.isNotEmpty) ? (DateTime.tryParse(s) ?? DateTime.now()) : DateTime.now();
    }
    final nfseNum = map['nfse_number']?.toString();
    final idStr = map['id']?.toString() ?? '';
    return NfseListItem(
      id: idStr,
      numero: (nfseNum != null && nfseNum.isNotEmpty) ? nfseNum : 'NFS-e ${idStr.length >= 8 ? idStr.substring(0, 8) : idStr}',
      cliente: map['customer_business_name']?.toString() ?? '---',
      servico: servico,
      valor: _nfseToDouble(map['nfse_value'] ?? map['billing_value'] ?? map['net_value']),
      data: data,
      status: map['status']?.toString() ?? '',
    );
  }
}

/// Resposta de [fn_get_company_billing_paginated_v2].
class NfseBillingPaginatedResult {
  NfseBillingPaginatedResult({
    required this.rows,
    required this.totalItems,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  /// Linhas completas retornadas pela RPC (para lista e tela de detalhes).
  final List<Map<String, dynamic>> rows;
  final int totalItems;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  static NfseBillingPaginatedResult empty({int page = 1, int pageSize = 20}) =>
      NfseBillingPaginatedResult(
        rows: [],
        totalItems: 0,
        page: page,
        pageSize: pageSize,
        totalPages: 0,
        hasNext: false,
        hasPrevious: false,
      );
}

class NfseListService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static const int defaultPageSize = 20;

  /// Billing paginado (fn_get_company_billing_paginated_v2).
  static Future<NfseBillingPaginatedResult> getCompanyBillingPaginated({
    required String companyId,
    required int page,
    int pageSize = defaultPageSize,
    required DateTime startDate,
    required DateTime endDate,
    String? companyUserId,
    String? customerId,
    String? fiscalDocumentType,
    String? status,
  }) async {
    try {
      final start =
          '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      final end =
          '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

      final params = <String, dynamic>{
        'p_company_id': companyId,
        'p_page': page,
        'p_page_size': pageSize,
        'p_start_date': start,
        'p_end_date': end,
        'p_customer_id': customerId,
        'p_fiscal_document_type': fiscalDocumentType,
        'p_status': status,
      };
      if (companyUserId != null && companyUserId.isNotEmpty) {
        params['p_company_user_id'] = companyUserId;
      }

      final response = await _supabase.rpc(
        'fn_get_company_billing_paginated_v2',
        params: params,
      );

      if (response == null) {
        return NfseBillingPaginatedResult.empty(page: page, pageSize: pageSize);
      }

      if (response is! Map) {
        return NfseBillingPaginatedResult.empty(page: page, pageSize: pageSize);
      }

      final root = Map<String, dynamic>.from(response);
      final dataRaw = root['data'];
      final list = dataRaw is List ? dataRaw : <dynamic>[];

      final pagRaw = root['pagination'];
      final pag = pagRaw is Map ? Map<String, dynamic>.from(pagRaw) : <String, dynamic>{};

      final rows = <Map<String, dynamic>>[];
      for (final e in list) {
        if (e is Map) {
          rows.add(Map<String, dynamic>.from(e));
        }
      }

      return NfseBillingPaginatedResult(
        rows: rows,
        totalItems: _toInt(pag['total_items']),
        page: _toInt(pag['page'], fallback: page),
        pageSize: _toInt(pag['page_size'], fallback: pageSize),
        totalPages: _toInt(pag['total_pages']),
        hasNext: pag['has_next'] == true || pag['has_next'] == 'true',
        hasPrevious: pag['has_previous'] == true || pag['has_previous'] == 'true',
      );
    } catch (_) {
      return NfseBillingPaginatedResult.empty(page: page, pageSize: pageSize);
    }
  }

  static int _toInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  /// Busca a lista de NFS-e da empresa no período (usa fn_get_company_nfse_list).
  /// Retorna lista vazia se companyId for null ou em caso de erro.
  static Future<List<NfseListItem>> getCompanyNfseList({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? companyUserId,
  }) async {
    try {
      final start =
          '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      final end =
          '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

      final params = <String, dynamic>{
        'p_company_id': companyId,
        'p_start_date': start,
        'p_end_date': end,
      };
      if (companyUserId != null && companyUserId.isNotEmpty) {
        params['p_company_user_id'] = companyUserId;
      }

      final response = await _supabase.rpc(
        'fn_get_company_nfse_list',
        params: params,
      );

      if (response == null) return [];

      final list = response is List ? response : [];
      final List<NfseListItem> result = [];
      for (final e in list) {
        final map = e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{};
        final dataStr = map['data']?.toString();
        DateTime data;
        if (dataStr != null && dataStr.isNotEmpty) {
          data = DateTime.tryParse(dataStr) ?? DateTime.now();
        } else {
          data = DateTime.now();
        }
        result.add(NfseListItem(
          id: map['id']?.toString() ?? '',
          numero: map['numero']?.toString() ?? 'NFS-e',
          cliente: map['cliente']?.toString() ?? 'Cliente',
          servico: map['servico']?.toString() ?? 'NFS-e',
          valor: _nfseToDouble(map['valor']),
          data: data,
          status: map['status']?.toString() ?? 'Emitida',
        ));
      }
      return result;
    } catch (_) {
      return [];
    }
  }
}
