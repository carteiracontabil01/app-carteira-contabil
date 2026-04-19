double nfseBillingToDouble(dynamic v) =>
    v is num ? v.toDouble() : (double.tryParse(v?.toString() ?? '0') ?? 0);

class NfseTaxItem {
  const NfseTaxItem({
    required this.key,
    required this.label,
    required this.value,
    this.aliquot,
  });

  final String key;
  final String label;
  final double value;
  final double? aliquot;
}

class NfseBillingBreakdown {
  const NfseBillingBreakdown({
    required this.grossValue,
    required this.taxTotal,
    required this.netValue,
    required this.taxItems,
  });

  final double grossValue;
  final double taxTotal;
  final double netValue;
  final List<NfseTaxItem> taxItems;
}

DateTime? nfseBillingDate(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  return DateTime.tryParse(raw.toString());
}

String nfseBillingCliente(Map<String, dynamic> m) =>
    m['customer_business_name']?.toString() ??
    m['cliente']?.toString() ??
    '---';

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

NfseBillingBreakdown nfseBillingBreakdown(Map<String, dynamic> billing) {
  final params = nfseParametersMap(billing);

  final grossFromParams = nfseBillingToDouble(params?['gross_value']);
  final grossFromRoot = nfseBillingToDouble(
    billing['nfse_value'] ?? billing['billing_value'] ?? billing['valor'],
  );
  var gross = grossFromParams > 0
      ? grossFromParams
      : (grossFromRoot > 0 ? grossFromRoot : nfseBillingValor(billing));

  var net = nfseBillingToDouble(
    params?['net_value'] ?? billing['net_value'],
  );

  final taxItems = <NfseTaxItem>[];
  void addTax({
    required String key,
    required String label,
    required dynamic value,
    dynamic aliquot,
  }) {
    final taxValue = nfseBillingToDouble(value);
    if (taxValue <= 0) return;
    final aliquotValue = nfseBillingToDouble(aliquot);
    taxItems.add(
      NfseTaxItem(
        key: key,
        label: label,
        value: taxValue,
        aliquot: aliquotValue > 0 ? aliquotValue : null,
      ),
    );
  }

  addTax(
    key: 'iss',
    label: 'ISS',
    value: params?['value_iss'],
    aliquot: params?['aliquot_iss'],
  );
  addTax(
    key: 'inss',
    label: 'INSS',
    value: params?['value_inss'],
    aliquot: params?['aliquot_inss'],
  );
  addTax(
    key: 'irrf',
    label: 'IRRF',
    value: params?['value_irrf'],
    aliquot: params?['aliquot_irrf'],
  );
  addTax(
    key: 'csll',
    label: 'CSLL',
    value: params?['value_csll'],
    aliquot: params?['aliquot_csll'],
  );
  addTax(
    key: 'cofins',
    label: 'COFINS',
    value: params?['value_cofins'],
    aliquot: params?['aliquot_cofins'],
  );
  addTax(
    key: 'pis',
    label: 'PIS',
    value: params?['value_pis'],
    aliquot: params?['aliquot_pis'],
  );

  final knownTaxes = taxItems.fold<double>(0, (sum, item) => sum + item.value);
  final dynamicOtherTax = _extractOutrasRetencoesFromDynamicFields(params);
  final deductions = nfseBillingToDouble(
    params?['deductions_value'] ?? billing['total_tax_value'],
  );
  final otherTax = dynamicOtherTax > 0
      ? dynamicOtherTax
      : ((deductions - knownTaxes) > 0 ? (deductions - knownTaxes) : 0.0);

  if (otherTax > 0) {
    taxItems.add(
      NfseTaxItem(
        key: 'outras_retencoes',
        label: 'Outras Retenções',
        value: otherTax,
      ),
    );
  }

  var taxTotal = nfseBillingToDouble(billing['total_tax_value']);
  if (taxTotal <= 0) {
    taxTotal = deductions > 0
        ? deductions
        : taxItems.fold<double>(0, (sum, item) => sum + item.value);
  }

  if (net <= 0 && gross > 0 && taxTotal > 0) {
    net = gross - taxTotal;
  }
  if (gross <= 0 && net > 0 && taxTotal >= 0) {
    gross = net + taxTotal;
  }

  return NfseBillingBreakdown(
    grossValue: gross,
    taxTotal: taxTotal,
    netValue: net > 0 ? net : gross,
    taxItems: taxItems.where((item) => item.value > 0).toList(),
  );
}

double _extractOutrasRetencoesFromDynamicFields(Map<String, dynamic>? params) {
  if (params == null) return 0;
  final dynamicFields = params['dynamic_fields'];
  if (dynamicFields is! List) return 0;

  var maxValue = 0.0;
  for (final field in dynamicFields) {
    if (field is! Map) continue;
    final map = Map<String, dynamic>.from(field);
    final fieldKey = (map['field'] ?? '').toString().trim().toLowerCase();
    if (fieldKey != 'outras_retencoes') continue;
    final value = nfseBillingToDouble(map['value']);
    if (value > maxValue) maxValue = value;
  }
  return maxValue;
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
  for (final k in [
    'danfse_url',
    'danfse_focus_url',
    'nfse_url',
    'nfse_focus_url'
  ]) {
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
