enum CompanySegmentEnum {
  commerce('COMMERCE', 'Comércio'),
  industry('INDUSTRY', 'Indústria'),
  service('SERVICE', 'Prestação de Serviço'),
  transport('TRANSPORT', 'Transporte');

  const CompanySegmentEnum(this.value, this.label);
  final String value;
  final String label;

  static CompanySegmentEnum? fromValue(String? raw) {
    final normalized = (raw ?? '').trim().toUpperCase();
    for (final item in values) {
      if (item.value == normalized) return item;
    }
    return null;
  }
}

enum CompanySizeEnum {
  mei('MEI', 'Micro Empreendedor Individual'),
  me('ME', 'Microempresa'),
  epp('EPP', 'Empresa de Pequeno Porte'),
  empMedio('EMP_MEDIO', 'Empresa de Médio Porte'),
  empGrande('EMP_GRANDE', 'Empresa de Grande Porte');

  const CompanySizeEnum(this.value, this.label);
  final String value;
  final String label;

  static CompanySizeEnum? fromValue(String? raw) {
    final normalized = (raw ?? '').trim().toUpperCase();
    for (final item in values) {
      if (item.value == normalized) return item;
    }
    return null;
  }
}

enum CompanyOperationTypeEnum {
  foraEstab(
    'FORA_ESTAB',
    'Atividade Desenvolvida Fora do Estabelecimento',
  ),
  correio('CORREIO', 'Correio'),
  foraFixo('FORA_FIXO', 'Em Local Fixo Fora de Loja'),
  fixo('FIXO', 'Estabelecimento Fixo'),
  internet('INTERNET', 'Internet'),
  maquinas('MAQUINAS', 'Máquinas Automáticas'),
  portaPorta('PORTA_PORTA', 'Porta a Porta, Postos Móveis ou por Ambulantes'),
  televendas('TELEVENDAS', 'Televendas');

  const CompanyOperationTypeEnum(this.value, this.label);
  final String value;
  final String label;

  static CompanyOperationTypeEnum? fromValue(String? raw) {
    final normalized = (raw ?? '').trim().toUpperCase();
    for (final item in values) {
      if (item.value == normalized) return item;
    }
    return null;
  }
}

enum CompanyTaxRegimeEnum {
  simplesNacional('SIMPLES_NACIONAL', 'Simples Nacional'),
  simplesNacionalExcessoSublimite(
    'SIMPLES_NACIONAL_EXCESSO_SUBLIMITE',
    'Simples Nacional - Excesso de sublimite de receita bruta',
  ),
  lucroPresumido('LUCRO_PRESUMIDO', 'Lucro Presumido'),
  lucroReal('LUCRO_REAL', 'Lucro Real'),
  mei('MEI', 'MEI');

  const CompanyTaxRegimeEnum(this.value, this.label);
  final String value;
  final String label;

  static CompanyTaxRegimeEnum? fromValue(String? raw) {
    final normalized = (raw ?? '').trim().toUpperCase();
    for (final item in values) {
      if (item.value == normalized) return item;
    }
    return null;
  }
}

enum AddressTypeEnum {
  headquarters('HEADQUARTERS', 'Sede'),
  branch('BRANCH', 'Filial');

  const AddressTypeEnum(this.value, this.label);
  final String value;
  final String label;

  static AddressTypeEnum? fromValue(String? raw) {
    final normalized = (raw ?? '').trim().toUpperCase();
    for (final item in values) {
      if (item.value == normalized) return item;
    }
    return null;
  }
}
