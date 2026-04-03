import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'nfse_billing_helpers.dart';
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
          content: Text('Não foi possível abrir o link.', style: GoogleFonts.nunito()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final b = widget.billing;
    final params = nfseParametersMap(b);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFmt = DateFormat('dd/MM/yyyy');

    final emission = nfseBillingDate(b['emission_date']) ?? DateTime.now();
    final numero = nfseBillingNumeroDisplay(b);
    final status = b['status']?.toString();
    final origin = b['origin']?.toString();
    final typeLabel = b['type']?.toString().trim();
    final verified = b['verified_code']?.toString();
    final refNum = b['ref_number']?.toString();

    final gross = params != null
        ? nfseBillingToDouble(params['gross_value'])
        : nfseBillingValor(b);
    final net = params != null
        ? nfseBillingToDouble(params['net_value'])
        : nfseBillingToDouble(b['net_value']);
    final taxFromParams = nfseSumTaxesFromParameters(params);
    final taxTotal = taxFromParams > 0
        ? taxFromParams
        : nfseBillingToDouble(b['total_tax_value']);

    Map<String, dynamic>? customer;
    final cr = b['customer'];
    if (cr is Map) customer = Map<String, dynamic>.from(cr);

    final serviceDesc =
        params?['service_description']?.toString() ?? b['servico']?.toString() ?? '—';
    final serviceValue = params != null
        ? nfseBillingToDouble(params['service_value'])
        : nfseBillingValor(b);

    final pdfUrl = nfsePdfUrl(b);
    final xmlUrl = nfseXmlUrl(b);

    final hasRetentionDetail = params != null &&
        (nfseBillingToDouble(params['iss_retention']) > 0 ||
            nfseBillingToDouble(params['inss_retention']) > 0 ||
            nfseBillingToDouble(params['irrf_retention']) > 0);

    final dividerColor = theme.primaryText.withValues(alpha: 0.08);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          toolbarHeight:
              typeLabel != null && typeLabel.isNotEmpty ? 72 : kToolbarHeight,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.primaryText, size: 22),
            onPressed: () => context.safePop(),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                numero,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: theme.primaryText,
                ),
              ),
              if (typeLabel != null && typeLabel.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  typeLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.secondaryText,
                  ),
                ),
              ],
            ],
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statusChip(
                        context,
                        nfseStatusLabel(status),
                        isSuccess: status?.toUpperCase() == 'AUTHORIZED',
                      ),
                      if (origin != null && origin.isNotEmpty)
                        _statusChip(
                          context,
                          nfseOriginLabel(origin),
                          isSuccess: false,
                          muted: true,
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: pdfUrl != null ? () => _launch(pdfUrl) : null,
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 22),
                      label: Text(
                        'Baixar PDF',
                        style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: xmlUrl != null ? () => _launch(xmlUrl) : null,
                      icon: Icon(Icons.code_rounded, size: 22, color: theme.primary),
                      label: Text(
                        'Baixar XML',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primary.withValues(alpha: 0.45)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
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
                        currency.format(gross > 0 ? gross : nfseBillingValor(b)),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.primaryText.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Text(
                      hasRetentionDetail
                          ? 'Retenções informadas nos parâmetros desta NFS-e.'
                          : 'Nenhuma retenção registrada para esta NFS-e.',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        height: 1.4,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
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
      MapEntry('Telefone', customer['business_phone_number']?.toString() ?? '—'),
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
          color: theme.secondaryText,
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
        border: Border.all(color: theme.primaryText.withValues(alpha: 0.06)),
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
              color: theme.primaryText,
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

  Widget _statusChip(
    BuildContext context,
    String text, {
    required bool isSuccess,
    bool muted = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final bg = isSuccess
        ? const Color(0xFFE8F5E9)
        : (muted ? theme.grayscale20 : theme.primary.withValues(alpha: 0.1));
    final fg = isSuccess
        ? const Color(0xFF2E7D32)
        : (muted ? theme.secondaryText : theme.primaryText);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
