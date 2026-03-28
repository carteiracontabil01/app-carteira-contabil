import '/backend/supabase/supabase.dart';

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
}

class NfseListService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Busca a lista de NFS-e da empresa no período (usa fn_get_company_nfse_list).
  /// Retorna lista vazia se companyId for null ou em caso de erro.
  static Future<List<NfseListItem>> getCompanyNfseList({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? companyUserId,
  }) async {
    try {
      final start = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      final end = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

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
          valor: _toDouble(map['valor']),
          data: data,
          status: map['status']?.toString() ?? 'Emitida',
        ));
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  static double _toDouble(dynamic v) =>
      v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '0') ?? 0);
}
