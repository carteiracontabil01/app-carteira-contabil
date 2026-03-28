import 'servicos_catalog.dart' show SolicitacaoServico;

/// Armazena solicitações em memória (mock; substituir por API depois).
class ServicosRepository {
  ServicosRepository._();
  static final ServicosRepository instance = ServicosRepository._();

  final List<SolicitacaoServico> solicitacoes = [];

  void initMockIfEmpty() {
    if (solicitacoes.isNotEmpty) return;
    final agora = DateTime.now();
    solicitacoes.addAll([
      SolicitacaoServico(
        id: 'sol-mock-1',
        servicoNome: 'Consultoria tributária',
        precoCatalogo: null,
        valorInformadoOpcional: 800,
        observacao: 'Preciso de análise do regime atual.',
        status: 'Em análise',
        solicitadoEm: agora.subtract(const Duration(days: 3)),
      ),
      SolicitacaoServico(
        id: 'sol-mock-2',
        servicoNome: 'Abertura de empresa',
        precoCatalogo: 890.00,
        valorInformadoOpcional: null,
        observacao: 'MEI, comércio online.',
        status: 'Pendente',
        solicitadoEm: agora.subtract(const Duration(days: 10)),
      ),
    ]);
  }

  void add(SolicitacaoServico s) {
    solicitacoes.insert(0, s);
  }
}
