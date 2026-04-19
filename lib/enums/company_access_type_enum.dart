enum CompanyAccessTypeEnum {
  legalEntityCertificate(
    'LEGAL_ENTITY_CERTIFICATE',
    'Certificado digital PJ',
    'Certificado PJ',
  ),
  individualCertificate(
    'INDIVIDUAL_CERTIFICATE',
    'Certificado digital PF',
    'Certificado PF',
  ),
  access(
    'ACCESS',
    'Acessos (Usuário/Senha)',
    'Acesso',
  );

  const CompanyAccessTypeEnum(this.value, this.label, this.shortLabel);

  final String value;
  final String label;
  final String shortLabel;

  static CompanyAccessTypeEnum? fromValue(String? raw) {
    final normalized = (raw ?? '').trim().toUpperCase();
    if (normalized.isEmpty) return null;

    for (final type in CompanyAccessTypeEnum.values) {
      if (type.value == normalized) return type;
    }

    // Compatibilidade com payloads legados/sinônimos.
    if (normalized == 'NATURAL_PERSON_CERTIFICATE' ||
        normalized.contains('INDIVIDUAL') ||
        normalized.contains('PERSON') ||
        normalized.contains('PF')) {
      return CompanyAccessTypeEnum.individualCertificate;
    }
    if (normalized.contains('LEGAL_ENTITY') || normalized.contains('PJ')) {
      return CompanyAccessTypeEnum.legalEntityCertificate;
    }
    if (normalized.contains('ACCESS') ||
        normalized.contains('USUARIO') ||
        normalized.contains('SENHA')) {
      return CompanyAccessTypeEnum.access;
    }

    return null;
  }
}
