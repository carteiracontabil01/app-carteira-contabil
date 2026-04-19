import '/shared/components/legal_document_page.dart';
import 'package:flutter/material.dart';
import 'termos_uso_model.dart';

export 'termos_uso_model.dart';

class TermosUsoWidget extends StatefulWidget {
  const TermosUsoWidget({super.key});

  static String routeName = 'termosUso';
  static String routePath = 'termosUso';

  @override
  State<TermosUsoWidget> createState() => _TermosUsoWidgetState();
}

class _TermosUsoWidgetState extends State<TermosUsoWidget> {
  late TermosUsoModel _model;

  static const List<LegalDocumentSection> _sections = [
    LegalDocumentSection(
      title: '1. Objeto e aceitação',
      body:
          'Estes Termos regulam o uso do aplicativo da Carteira Contábil para contratação e acompanhamento de serviços de assessoria contábil, fiscal e trabalhista. Ao utilizar o app, o usuário declara ciência e concordância com estes Termos e com a legislação brasileira aplicável.',
    ),
    LegalDocumentSection(
      title: '2. Serviços oferecidos',
      body:
          'O aplicativo permite acesso a informações da empresa, emissão e acompanhamento de documentos, comunicação com o escritório e outras funcionalidades de apoio à rotina contábil. A disponibilidade de cada funcionalidade pode variar conforme plano contratado e obrigações legais do cliente.',
    ),
    LegalDocumentSection(
      title: '3. Responsabilidades do cliente',
      body:
          'O cliente deve fornecer dados verdadeiros, manter documentos atualizados e cumprir prazos para envio de informações contábeis e fiscais. O atraso ou omissão de dados pode impactar a entrega das obrigações acessórias e gerar multas por órgãos competentes (Receita Federal, Estados e Municípios).',
    ),
    LegalDocumentSection(
      title: '4. Limites e conformidade legal',
      body:
          'A Carteira Contábil atua em conformidade com normas contábeis e tributárias vigentes no Brasil, incluindo regras do CFC e legislações fiscal e trabalhista. O app não substitui orientação jurídica individualizada, quando necessária para casos específicos.',
    ),
    LegalDocumentSection(
      title: '5. Suspensão e encerramento',
      body:
          'O uso poderá ser suspenso em caso de fraude, uso indevido, violação de segurança ou descumprimento contratual. O encerramento da relação contratual seguirá as condições comerciais firmadas entre cliente e escritório.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = TermosUsoModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      title: 'Termos de Uso',
      lastUpdatedLabel: 'Atualizado em: 18/04/2026',
      sections: _sections,
    );
  }
}
