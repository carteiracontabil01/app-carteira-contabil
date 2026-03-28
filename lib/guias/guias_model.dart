import '/flutter_flow/flutter_flow_util.dart';
import 'guias_widget.dart' show GuiasWidget;
import 'package:flutter/material.dart';

class GuiasModel extends FlutterFlowModel<GuiasWidget> {
  static const String tabPgdas = 'Guias - PGDAS';
  static const String tabCertidoes = 'Certidões/Relatórios';
  static const String tabComprovantes = 'Comprovantes';
  static const String tabCaixas = 'Caixas Postais';

  static const List<String> categoryTabs = [
    tabPgdas,
    tabCertidoes,
    tabComprovantes,
    tabCaixas,
  ];

  /// Filtro por ano/mês/status só na aba [tabPgdas].
  static bool tabShowsPeriodFilters(String tab) => tab == tabPgdas;

  String selectedTab = tabPgdas;
  int filterYear = DateTime.now().year;
  int filterMonth = DateTime.now().month;

  /// Todas | Pendente | Pago (apenas PGDAS)
  String statusFilter = 'Todas';

  bool isLoading = false;

  List<Map<String, dynamic>> getAllPgdasList() {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month;

    return [
      {
        'titulo': 'DAS - Simples Nacional',
        'categoria': 'Impostos',
        'descricao': 'Documento de Arrecadação do Simples',
        'valor': 2100.00,
        'vencimento': DateTime(y, m, 12),
        'status': 'Pendente',
        'arquivo': 'das_simples.pdf',
      },
      {
        'titulo': 'GPS - INSS',
        'categoria': 'Guias',
        'descricao': 'Guia da Previdência Social',
        'valor': 1420.00,
        'vencimento': DateTime(y, m, 18),
        'status': 'Pendente',
        'arquivo': 'gps_inss.pdf',
      },
      {
        'titulo': 'Honorários Contábeis',
        'categoria': 'Honorários',
        'descricao': 'Serviços de contabilidade mensal',
        'valor': 850.00,
        'vencimento': DateTime(y, m, 5),
        'status': 'Pago',
        'arquivo': 'boleto_honorarios.pdf',
      },
      {
        'titulo': 'DARF - IRPJ',
        'categoria': 'Impostos',
        'descricao': 'Imposto de Renda Pessoa Jurídica',
        'valor': 3100.00,
        'vencimento': DateTime(y, m, 22),
        'status': 'Pendente',
        'arquivo': 'darf_irpj.pdf',
      },
      {
        'titulo': 'Honorários Contábeis - Novembro/2025',
        'categoria': 'Honorários',
        'descricao': 'Serviços de contabilidade mensal',
        'valor': 850.00,
        'vencimento': DateTime(2025, 11, 10),
        'status': 'Pendente',
        'arquivo': 'boleto_honorarios_nov.pdf',
      },
      {
        'titulo': 'DARF - IRPJ',
        'categoria': 'Impostos',
        'descricao': 'Imposto de Renda Pessoa Jurídica',
        'valor': 3200.00,
        'vencimento': DateTime(2025, 11, 20),
        'status': 'Pendente',
        'arquivo': 'darf_irpj_nov.pdf',
      },
      {
        'titulo': 'GPS - INSS',
        'categoria': 'Guias',
        'descricao': 'Guia da Previdência Social',
        'valor': 1580.00,
        'vencimento': DateTime(2025, 11, 15),
        'status': 'Pendente',
        'arquivo': 'gps_nov.pdf',
      },
      {
        'titulo': 'DAS - Simples Nacional',
        'categoria': 'Impostos',
        'descricao': 'Documento de Arrecadação do Simples',
        'valor': 2450.00,
        'vencimento': DateTime(2025, 11, 25),
        'status': 'Pendente',
        'arquivo': 'das_nov.pdf',
      },
      {
        'titulo': 'Honorários Contábeis - Outubro/2025',
        'categoria': 'Honorários',
        'descricao': 'Serviços de contabilidade mensal',
        'valor': 850.00,
        'vencimento': DateTime(2025, 10, 10),
        'status': 'Pago',
        'arquivo': 'boleto_honorarios_out.pdf',
      },
    ];
  }

  List<Map<String, dynamic>> getFilteredPgdasList() {
    return getAllPgdasList().where((guia) {
      final vencimento = guia['vencimento'] as DateTime;

      if (vencimento.year != filterYear || vencimento.month != filterMonth) {
        return false;
      }

      if (statusFilter != 'Todas' && guia['status'] != statusFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Certidões/relatórios — sem filtro de período na UI.
  List<Map<String, dynamic>> getCertidoesList() {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month;
    return [
      {
        'titulo': 'Certidão negativa federal',
        'emissao': DateTime(y, m, 8),
        'situacao': 'Válida',
        'arquivo': 'cert_federal.pdf',
      },
      {
        'titulo': 'Relatório mensal DCTF',
        'emissao': DateTime(y, m, 25),
        'situacao': 'Pendente',
        'arquivo': 'dctf_mes.pdf',
      },
      {
        'titulo': 'DARF - CSLL',
        'emissao': DateTime(2025, 10, 20),
        'situacao': 'Emitida',
        'arquivo': 'darf_csll_out.pdf',
      },
      {
        'titulo': 'FGTS — comprovante',
        'emissao': DateTime(2025, 10, 7),
        'situacao': 'Emitida',
        'arquivo': 'fgts_out.pdf',
      },
    ];
  }

  /// Código, vencimento (colunas da UI Comprovantes)
  List<Map<String, dynamic>> getComprovantesList() {
    return [
      {
        'codigo': '3333',
        'vencimento': DateTime(2025, 10, 20),
      },
      {
        'codigo': '1410',
        'vencimento': DateTime(2025, 9, 22),
      },
      {
        'codigo': '2201',
        'vencimento': DateTime(2025, 8, 15),
      },
    ];
  }

  /// Caixa postal: [recebida], [assunto]
  List<Map<String, dynamic>> getCaixasPostaisList() {
    return [
      {
        'recebida': DateTime(2023, 10, 2),
        'assunto': 'Bem-vindo ao Caixa Postal!',
      },
      {
        'recebida': DateTime(2024, 3, 15),
        'assunto': 'Documento fiscal disponível para ciência',
      },
      {
        'recebida': DateTime(2025, 10, 28),
        'assunto': 'Novo comunicado da Receita Federal',
      },
    ];
  }

  void setTab(String tab) {
    selectedTab = tab;
  }

  void setFilterYear(int y) {
    filterYear = y;
  }

  void setFilterMonth(int m) {
    filterMonth = m;
  }

  void setStatusFilter(String s) {
    statusFilter = s;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
