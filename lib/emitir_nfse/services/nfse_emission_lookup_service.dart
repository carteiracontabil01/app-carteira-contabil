import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class NfseMunicipioOption {
  const NfseMunicipioOption({
    required this.id,
    required this.ibgeCode,
    required this.label,
  });

  final String id;
  final String ibgeCode;
  final String label;
}

class NfseTaxField {
  const NfseTaxField({
    required this.field,
    required this.label,
    required this.type,
    required this.required,
    this.observation,
  });

  final String field;
  final String label;
  final String type;
  final bool required;
  final String? observation;
}

class NfseTaxResolution {
  const NfseTaxResolution({
    required this.fields,
    required this.hasMunicipalityTaxConfig,
  });

  final List<NfseTaxField> fields;
  final bool hasMunicipalityTaxConfig;
}

class NfseEmissionLookupService {
  NfseEmissionLookupService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const List<String> _fallbackTaxOrder = <String>[
    'aliquota_iss',
    'aliquota_inss',
    'aliquota_irrf',
    'aliquota_csll',
    'aliquota_cofins',
    'aliquota_pis',
  ];

  static const Map<String, String> _fallbackTaxLabels = <String, String>{
    'aliquota_iss': 'ISS (%)',
    'aliquota_inss': 'INSS (%)',
    'aliquota_irrf': 'IRRF (%)',
    'aliquota_csll': 'CSLL (%)',
    'aliquota_cofins': 'COFINS (%)',
    'aliquota_pis': 'PIS (%)',
    'outras_retencoes': 'Outras retencoes (R\$)',
  };

  List<Map<String, dynamic>> extractCompanyCustomers(
    Map<String, dynamic>? profile,
  ) {
    final rawCustomers = profile?['company_customers'];
    if (rawCustomers is! Map) return const [];
    final data = rawCustomers['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<Map<String, dynamic>> extractCnaes(
    Map<String, dynamic>? profile,
  ) {
    final raw = profile?['cnaes'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<Map<String, dynamic>> extractServicesFromCnae(
    Map<String, dynamic>? cnae,
  ) {
    final services = cnae?['serviceItemsLc116'];
    if (services is! List) return const [];
    return services
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<Map<String, dynamic>>> searchCompanyCustomers({
    required String companyId,
    required String query,
    int limit = 10,
  }) async {
    final q = query.trim();
    if (companyId.isEmpty || q.length < 3) return const [];

    final response = await _client.rpc(
      'search_company_customers',
      params: <String, dynamic>{
        'p_company_id': companyId,
        'p_query': q,
        'p_limit': limit,
      },
    );

    if (response is! List) return const [];
    return response
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<NfseMunicipioOption>> searchMunicipios({
    required String query,
    int limit = 20,
  }) async {
    final q = query.trim();
    if (q.length < 2) return const [];

    final response = await _client.rpc(
      'fn_search_municipios',
      params: <String, dynamic>{
        'p_search': q,
        'p_limit': limit,
      },
    );

    if (response is! List) return const [];
    return response.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      final name = (map['name'] ?? '').toString().trim();
      final uf = (map['uf'] ?? '').toString().trim();
      return NfseMunicipioOption(
        id: (map['id'] ?? '').toString(),
        ibgeCode: (map['ibge_code'] ?? '').toString(),
        label: uf.isEmpty ? name : '$name - $uf',
      );
    }).toList();
  }

  NfseTaxResolution resolveTaxFields({
    required Map<String, dynamic>? profile,
    required Map<String, dynamic>? selectedService,
    required String naturezaOperacao,
  }) {
    final municipalityConfig = profile?['municipality_nfse_specific_fields'];
    final municipalityFields = municipalityConfig is Map
        ? (municipalityConfig['fields'] is List
            ? (municipalityConfig['fields'] as List)
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList()
            : const <Map<String, dynamic>>[])
        : const <Map<String, dynamic>>[];

    final requiredFields =
        _normalizeRequiredFields(selectedService?['required_fields']);
    final requiredSet =
        requiredFields.map((item) => item.toLowerCase()).toSet();

    final dynamicTaxFields = <NfseTaxField>[];
    for (final raw in municipalityFields) {
      final field = (raw['field'] ?? '').toString().trim();
      if (field.isEmpty) continue;

      final fieldLower = field.toLowerCase();
      if (!requiredSet.contains(fieldLower)) continue;
      if (!_isTaxField(fieldLower)) continue;

      final dynamicValue = _toBool(raw['dynamic_value']);
      if (!dynamicValue) continue;

      final section = (raw['section'] ?? '').toString().trim().toLowerCase();
      if (section.isNotEmpty && section != 'tax') continue;

      final tributacao =
          (raw['tributacao'] ?? '').toString().trim().toLowerCase();
      if (tributacao.isNotEmpty) {
        final selectedTributacao = naturezaOperacao == '2'
            ? 'fora_do_municipio'
            : 'dentro_do_municipio';
        if (tributacao != selectedTributacao) continue;
      }

      dynamicTaxFields.add(
        NfseTaxField(
          field: field,
          label: (raw['label'] ?? _fallbackTaxLabels[fieldLower] ?? field)
              .toString(),
          type: (raw['type'] ?? 'number').toString(),
          required: _toBool(raw['required']),
          observation: raw['observation']?.toString(),
        ),
      );
    }

    final hasMunicipalityTaxConfig = municipalityConfig is Map ||
        municipalityFields.any(
          (field) =>
              _isTaxField((field['field'] ?? '').toString().toLowerCase()),
        );

    if (dynamicTaxFields.isNotEmpty || hasMunicipalityTaxConfig) {
      return NfseTaxResolution(
        fields: dynamicTaxFields,
        hasMunicipalityTaxConfig: hasMunicipalityTaxConfig,
      );
    }

    final fallback = _resolveFallbackTaxesByRegime(
      (profile?['tax_regime'] ?? '').toString(),
    );
    return NfseTaxResolution(
      fields: fallback,
      hasMunicipalityTaxConfig: false,
    );
  }

  List<NfseTaxField> _resolveFallbackTaxesByRegime(String taxRegimeRaw) {
    final regime = taxRegimeRaw.trim().toUpperCase();
    final fields = <String>[
      if (regime.contains('SIMPLES')) 'aliquota_iss',
      if (!regime.contains('SIMPLES')) ..._fallbackTaxOrder,
    ];

    final normalized = fields.isEmpty ? _fallbackTaxOrder : fields;
    return normalized
        .map(
          (field) => NfseTaxField(
            field: field,
            label: _fallbackTaxLabels[field] ?? field,
            type: 'number',
            required: false,
          ),
        )
        .toList();
  }

  List<String> _normalizeRequiredFields(dynamic raw) {
    if (raw is List) {
      return raw
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) return const [];
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is List) {
            return decoded
                .map((item) => item.toString().trim())
                .where((item) => item.isNotEmpty)
                .toList();
          }
        } catch (_) {
          // Ignore malformed JSON and fallback to comma split.
        }
      }
      return trimmed
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  bool _isTaxField(String field) =>
      field == 'outras_retencoes' ||
      field.startsWith('aliquota_') ||
      field.startsWith('aliquot_');

  bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    final normalized = (value ?? '').toString().trim().toLowerCase();
    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'y';
  }
}
