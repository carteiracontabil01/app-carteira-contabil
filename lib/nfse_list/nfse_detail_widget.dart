import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'nfse_billing_helpers.dart';
import 'widgets/nfse_detail_download_actions.dart';
import 'widgets/nfse_detail_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NfseDetailWidget extends StatefulWidget {
  const NfseDetailWidget({
    super.key,
    required this.billing,
  });

  final Map<String, dynamic> billing;

  static String routeName = 'nfseDetail';
  static String routePath = 'nfse-detail';

  @override
  State<NfseDetailWidget> createState() => _NfseDetailWidgetState();
}

class _NfseDetailWidgetState extends State<NfseDetailWidget> {
  Future<void> _launch(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível abrir o link.',
              style: GoogleFonts.nunito()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final b = widget.billing;
    final params = nfseParametersMap(b);
    final breakdown = nfseBillingBreakdown(b);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFmt = DateFormat('dd/MM/yyyy');

    final emission = nfseBillingDate(b['emission_date']) ?? DateTime.now();
    final numero = nfseBillingNumeroDisplay(b);
    final status = b['status']?.toString();
    final origin = b['origin']?.toString();
    final typeLabel = b['type']?.toString().trim();
    final verified = b['verified_code']?.toString();
    final refNum = b['ref_number']?.toString();

    final gross = breakdown.grossValue;
    final net = breakdown.netValue;
    final taxTotal = breakdown.taxTotal;

    Map<String, dynamic>? customer;
    final cr = b['customer'];
    if (cr is Map) customer = Map<String, dynamic>.from(cr);

    final serviceDesc = params?['service_description']?.toString() ??
        b['servico']?.toString() ??
        '—';
    final serviceValue = params != null
        ? nfseBillingToDouble(params['service_value'])
        : nfseBillingValor(b);

    final pdfUrl = nfsePdfUrl(b);
    final xmlUrl = nfseXmlUrl(b);

    final taxItems = _sortTaxItems(breakdown.taxItems);

    final dividerColor = theme.primaryText.withValues(alpha: 0.08);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.grayscale20,
        appBar: AppBar(
          backgroundColor: theme.primary,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          toolbarHeight: 68,
          titleSpacing: 16,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.tertiary,
              size: 22,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Detalhes da NFS-e',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.tertiary,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: theme.tertiary.withValues(alpha: 0.22),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.grayscale10,
                theme.grayscale20,
              ],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    NfseDetailSummaryCard(
                      numero: numero,
                      typeLabel: typeLabel,
                      emission: dateFmt.format(emission),
                      netValue:
                          currency.format(net > 0 ? net : nfseBillingValor(b)),
                      statusLabel: nfseStatusLabel(status),
                      isAuthorized: status?.toUpperCase() == 'AUTHORIZED',
                      originLabel: origin != null && origin.isNotEmpty
                          ? nfseOriginLabel(origin)
                          : null,
                    ),
                    const SizedBox(height: 14),
                    NfseDetailDownloadActions(
                      onDownloadPdf:
                          pdfUrl != null ? () => _launch(pdfUrl) : null,
                      onDownloadXml:
                          xmlUrl != null ? () => _launch(xmlUrl) : null,
                    ),
                    const SizedBox(height: 28),
                    _sectionLabel(context, 'Informações gerais'),
                    _groupedCard(
                      context,
                      dividerColor,
                      _infoGeraisTiles(
                        context,
                        dateFmt: dateFmt,
                        emission: emission,
                        verified: verified,
                        refNum: refNum,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel(context, 'Tomador'),
                    _groupedCard(
                      context,
                      dividerColor,
                      _tomadorTiles(context, customer, b),
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel(context, 'Serviço'),
                    _groupedCard(
                      context,
                      dividerColor,
                      [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child: Text(
                            serviceDesc,
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              height: 1.45,
                              color: theme.primaryText,
                            ),
                          ),
                        ),
                        _mobileField(
                          context,
                          'Valor do serviço',
                          currency.format(serviceValue),
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel(context, 'Valores'),
                    _groupedCard(
                      context,
                      dividerColor,
                      [
                        _financeRow(
                          context,
                          'Valor bruto',
                          currency
                              .format(gross > 0 ? gross : nfseBillingValor(b)),
                          theme.info,
                        ),
                        _financeRow(
                          context,
                          'Total de impostos',
                          currency.format(taxTotal),
                          theme.error,
                          valueColor: theme.error,
                        ),
                        _financeRow(
                          context,
                          'Valor líquido',
                          currency.format(net > 0 ? net : nfseBillingValor(b)),
                          theme.success,
                          valueColor: theme.success,
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _sectionLabel(context, 'Impostos'),
                    _groupedCard(
                      context,
                      dividerColor,
                      [
                        _mobileField(
                          context,
                          'Total de impostos',
                          currency.format(taxTotal),
                        ),
                        if (taxItems.isEmpty)
                          _mobileField(
                            context,
                            'Detalhamento',
                            'Nenhum imposto adicional registrado para esta NFS-e.',
                            isLast: true,
                          )
                        else
                          ...List<Widget>.generate(taxItems.length, (index) {
                            final item = taxItems[index];
                            final aliquotSuffix = item.aliquot != null
                                ? ' (${_formatAliquot(item.aliquot!)}%)'
                                : '';
                            return _taxBreakdownRow(
                              context,
                              label: '${item.label}$aliquotSuffix',
                              value: currency.format(item.value),
                              accent: _taxAccentColor(theme, item.key),
                              icon: _taxIcon(item.key),
                              isLast: index == taxItems.length - 1,
                            );
                          }),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _tomadorTiles(
    BuildContext context,
    Map<String, dynamic>? customer,
    Map<String, dynamic> b,
  ) {
    if (customer == null) {
      return [
        _mobileField(context, 'Nome', nfseBillingCliente(b), isLast: true),
      ];
    }
    final rows = <MapEntry<String, String>>[
      MapEntry(
        'Razão social / Nome',
        customer['legal_name']?.toString() ??
            customer['business_name']?.toString() ??
            '—',
      ),
      MapEntry('CNPJ', customer['cnpj']?.toString() ?? '—'),
      MapEntry('E-mail', customer['business_email']?.toString() ?? '—'),
      MapEntry(
          'Telefone', customer['business_phone_number']?.toString() ?? '—'),
    ];
    return List<Widget>.generate(rows.length, (i) {
      return _mobileField(
        context,
        rows[i].key,
        rows[i].value,
        isLast: i == rows.length - 1,
      );
    });
  }

  List<Widget> _infoGeraisTiles(
    BuildContext context, {
    required DateFormat dateFmt,
    required DateTime emission,
    String? verified,
    String? refNum,
  }) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Data de emissão', dateFmt.format(emission)),
    ];
    if (verified != null && verified.isNotEmpty) {
      rows.add(MapEntry('Código de verificação', verified));
    }
    if (refNum != null && refNum.isNotEmpty) {
      rows.add(MapEntry('Número de referência', refNum));
    }
    return List<Widget>.generate(rows.length, (i) {
      return _mobileField(
        context,
        rows[i].key,
        rows[i].value,
        isLast: i == rows.length - 1,
      );
    });
  }

  Widget _sectionLabel(BuildContext context, String text) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: theme.primary,
        ),
      ),
    );
  }

  Widget _groupedCard(
    BuildContext context,
    Color dividerColor,
    List<Widget> tiles,
  ) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.grayscale30),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _intersperseDividers(tiles, dividerColor),
      ),
    );
  }

  List<Widget> _intersperseDividers(List<Widget> tiles, Color dividerColor) {
    final out = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      out.add(tiles[i]);
      if (i < tiles.length - 1) {
        out.add(Divider(height: 1, thickness: 1, color: dividerColor));
      }
    }
    return out;
  }

  Widget _mobileField(
    BuildContext context,
    String label,
    String value, {
    bool isLast = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, isLast ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: theme.primary,
            ),
          ),
          if (!isLast) const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _financeRow(
    BuildContext context,
    String label,
    String value,
    Color accent, {
    Color? valueColor,
    bool isLast = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, isLast ? 16 : 14),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: valueColor ?? theme.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAliquot(double value) {
    var text = value.toStringAsFixed(4);
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
    return text;
  }

  List<NfseTaxItem> _sortTaxItems(List<NfseTaxItem> items) {
    const order = <String, int>{
      'iss': 0,
      'inss': 1,
      'irrf': 2,
      'csll': 3,
      'cofins': 4,
      'pis': 5,
      'outras_retencoes': 6,
    };
    final sorted = List<NfseTaxItem>.from(items);
    sorted.sort(
      (a, b) => (order[a.key] ?? 99).compareTo(order[b.key] ?? 99),
    );
    return sorted;
  }

  IconData _taxIcon(String key) {
    switch (key) {
      case 'iss':
        return Icons.account_balance_rounded;
      case 'inss':
        return Icons.shield_outlined;
      case 'irrf':
        return Icons.request_quote_rounded;
      case 'csll':
        return Icons.account_balance_wallet_outlined;
      case 'cofins':
        return Icons.pie_chart_outline_rounded;
      case 'pis':
        return Icons.percent_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  Color _taxAccentColor(FlutterFlowTheme theme, String key) {
    switch (key) {
      case 'iss':
        return theme.info;
      case 'inss':
        return theme.warning;
      case 'irrf':
        return theme.error;
      case 'csll':
        return theme.alternate;
      case 'cofins':
        return theme.secondary;
      case 'pis':
        return theme.primary;
      default:
        return theme.grayscale70;
    }
  }

  Widget _taxBreakdownRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color accent,
    required IconData icon,
    bool isLast = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, isLast ? 16 : 0),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
