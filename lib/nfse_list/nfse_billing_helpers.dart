double nfseBillingToDouble(dynamic v) =>
    v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '0') ?? 0);

DateTime? nfseBillingDate(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  return DateTime.tryParse(raw.toString());
}

String nfseBillingCliente(Map<String, dynamic> m) =>
    m['customer_business_name']?.toString() ?? m['cliente']?.toString() ?? '---';

String nfseBillingNumeroDisplay(Map<String, dynamic> m) {
  final n = m['nfse_number']?.toString();
  if (n != null && n.isNotEmpty) return n;
  final id = m['id']?.toString() ?? '';
  return id.length >= 8 ? id.substring(0, 8) : (id.isEmpty ? '—' : id);
}

double nfseBillingValor(Map<String, dynamic> m) => nfseBillingToDouble(
      m['nfse_value'] ?? m['billing_value'] ?? m['net_value'] ?? m['valor'],
    );

String nfseStatusLabel(String? status) {
  final s = status?.toUpperCase() ?? '';
  switch (s) {
    case 'AUTHORIZED':
      return 'Autorizada';
    case 'CANCELLED':
    case 'CANCELED':
      return 'Cancelada';
    default:
      return status ?? '—';
  }
}

String nfseOriginLabel(String? origin) {
  final o = origin?.toUpperCase() ?? '';
  if (o.contains('SYSTEM') || o == 'SYSTEM') return 'Sistema';
  return origin ?? '—';
}

Map<String, dynamic>? nfseParametersMap(Map<String, dynamic> billing) {
  final p = billing['parameters'];
  if (p is Map) return Map<String, dynamic>.from(p);
  return null;
}

double nfseSumTaxesFromParameters(Map<String, dynamic>? p) {
  if (p == null) return 0;
  return nfseBillingToDouble(p['value_iss']) +
      nfseBillingToDouble(p['value_inss']) +
      nfseBillingToDouble(p['value_irrf']) +
      nfseBillingToDouble(p['value_csll']) +
      nfseBillingToDouble(p['value_cofins']) +
      nfseBillingToDouble(p['value_pis']);
}

String? nfsePdfUrl(Map<String, dynamic> m) {
  for (final k in ['danfse_url', 'danfse_focus_url', 'nfse_url', 'nfse_focus_url']) {
    final u = m[k]?.toString();
    if (u != null && u.isNotEmpty && u.startsWith('http')) return u;
  }
  return null;
}

String? nfseXmlUrl(Map<String, dynamic> m) {
  for (final k in ['xml_url', 'xml_focus_url']) {
    final u = m[k]?.toString();
    if (u != null && u.isNotEmpty && u.startsWith('http')) return u;
  }
  return null;
}
