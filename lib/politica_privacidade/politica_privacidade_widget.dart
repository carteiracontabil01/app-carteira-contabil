import '/shared/components/legal_document_page.dart';
import 'package:flutter/material.dart';
import 'politica_privacidade_model.dart';

export 'politica_privacidade_model.dart';

class PoliticaPrivacidadeWidget extends StatefulWidget {
  const PoliticaPrivacidadeWidget({super.key});

  static String routeName = 'politicaPrivacidade';
  static String routePath = 'politicaPrivacidade';

  @override
  State<PoliticaPrivacidadeWidget> createState() =>
      _PoliticaPrivacidadeWidgetState();
}

class _PoliticaPrivacidadeWidgetState extends State<PoliticaPrivacidadeWidget> {
  late PoliticaPrivacidadeModel _model;

  static const List<LegalDocumentSection> _sections = [
    LegalDocumentSection(
      title: '1. Dados coletados',
      body:
          'Coletamos dados cadastrais, informações da empresa, dados de contato e documentos necessários à prestação de serviços contábeis, fiscais e trabalhistas. A coleta ocorre para cumprimento de obrigações legais, execução contratual e melhoria da experiência no aplicativo.',
    ),
    LegalDocumentSection(
      title: '2. Finalidade do tratamento',
      body:
          'Os dados são tratados para execução dos serviços de assessoria contábil, envio de alertas de prazos, geração de documentos e atendimento ao cliente. Também podemos utilizar dados para comunicações operacionais e segurança da conta.',
    ),
    LegalDocumentSection(
      title: '3. Compartilhamento de informações',
      body:
          'Poderá haver compartilhamento com órgãos públicos, plataformas governamentais e fornecedores essenciais à operação contábil, sempre nos limites da legislação aplicável e da LGPD (Lei nº 13.709/2018). Não comercializamos dados pessoais.',
    ),
    LegalDocumentSection(
      title: '4. Segurança e retenção',
      body:
          'Adotamos controles técnicos e administrativos para proteger dados contra acesso não autorizado, perda ou alteração indevida. Os dados são mantidos pelo prazo necessário ao cumprimento de obrigações legais, regulatórias e contratuais.',
    ),
    LegalDocumentSection(
      title: '5. Direitos do titular',
      body:
          'Nos termos da LGPD, o titular pode solicitar confirmação de tratamento, acesso, correção e outras medidas cabíveis. Solicitações podem ser feitas pelos canais oficiais de atendimento do escritório.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = PoliticaPrivacidadeModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      title: 'Política de Privacidade',
      lastUpdatedLabel: 'Atualizado em: 18/04/2026',
      sections: _sections,
    );
  }
}
