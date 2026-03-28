/// Tipos e catálogo de serviços (sem dependência de widgets).

/// Item do catálogo (pode ou não ter preço fixo).
class ServicoCatalogoItem {
  const ServicoCatalogoItem({
    required this.id,
    required this.nome,
    this.precoFixo,
  });

  final String id;
  final String nome;
  /// Quando não nulo, exibido como valor pré-definido do serviço.
  final double? precoFixo;
}

/// Solicitação registrada (mock / futura API).
class SolicitacaoServico {
  SolicitacaoServico({
    required this.id,
    required this.servicoNome,
    this.precoCatalogo,
    this.valorInformadoOpcional,
    required this.observacao,
    required this.status,
    required this.solicitadoEm,
  });

  final String id;
  final String servicoNome;
  final double? precoCatalogo;
  final double? valorInformadoOpcional;
  final String observacao;
  final String status;
  final DateTime solicitadoEm;
}

/// Catálogo exibido na tela Serviços e no autocomplete de solicitação.
List<ServicoCatalogoItem> get servicosCatalogo => const [
      ServicoCatalogoItem(
        id: '1',
        nome: 'Abertura de empresa',
        precoFixo: 890.00,
      ),
      ServicoCatalogoItem(
        id: '2',
        nome: 'Alteração contratual',
        precoFixo: 450.00,
      ),
      ServicoCatalogoItem(
        id: '3',
        nome: 'Consultoria tributária',
      ),
      ServicoCatalogoItem(
        id: '4',
        nome: 'Planejamento fiscal',
      ),
      ServicoCatalogoItem(
        id: '5',
        nome: 'Regularização na Receita Federal',
        precoFixo: 1200.00,
      ),
      ServicoCatalogoItem(
        id: '6',
        nome: 'BPO financeiro',
      ),
      ServicoCatalogoItem(
        id: '7',
        nome: 'Treinamento de equipe (in company)',
        precoFixo: 2500.00,
      ),
      ServicoCatalogoItem(
        id: '8',
        nome: 'Due diligence contábil',
      ),
    ];
