import '/flutter_flow/flutter_flow_theme.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/shared/widgets/app_chip.dart';
import '../nfse_billing_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NfseListItemCard extends StatelessWidget {
  const NfseListItemCard({
    super.key,
    required this.nfse,
    required this.currencyFormat,
    required this.dateFormat,
    required this.onTap,
  });

  final Map<String, dynamic> nfse;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final cliente = nfseBillingCliente(nfse);
    final numero = nfseBillingNumeroDisplay(nfse);
    final breakdown = nfseBillingBreakdown(nfse);
    final data = nfseBillingDate(nfse['emission_date']) ??
        nfseBillingDate(nfse['data']) ??
        DateTime.now();
    final status = _resolveNfseStatus(nfse);
    final statusLabel = nfseStatusLabel(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: theme.primary.withValues(alpha: 0.08),
        highlightColor: theme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(HomeSurfaceTokens.cardRadius),
        child: Ink(
          decoration: HomeSurfaceTokens.cardDecoration(theme),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          AppChip(
                            label: numero.isNotEmpty && numero != '—'
                                ? 'Nota $numero'
                                : 'Nota sem número',
                            accentColor: theme.primary,
                            icon: Icons.receipt_long_rounded,
                          ),
                          AppChip(
                            label: statusLabel,
                            accentColor: _statusColor(theme, status),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: theme.primary.withValues(alpha: 0.7),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.event_rounded,
                      size: 14,
                      color: theme.secondaryText,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Emitida em ${dateFormat.format(data)}',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  cliente,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.grayscale20,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.grayscale30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricColumn(
                          label: 'Bruto',
                          value: currencyFormat.format(breakdown.grossValue),
                          valueColor: theme.primary,
                        ),
                      ),
                      _verticalDivider(theme),
                      Expanded(
                        child: _MetricColumn(
                          label: 'Impostos',
                          value: currencyFormat.format(breakdown.taxTotal),
                          valueColor: theme.error,
                        ),
                      ),
                      _verticalDivider(theme),
                      Expanded(
                        child: _MetricColumn(
                          label: 'Líquido',
                          value: currencyFormat.format(breakdown.netValue),
                          valueColor: theme.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _resolveNfseStatus(Map<String, dynamic> nfse) {
    final raw = (nfse['status'] ??
            nfse['nfse_status'] ??
            nfse['focus_status'] ??
            nfse['billing_status'])
        ?.toString()
        .trim();
    return raw == null || raw.isEmpty ? 'AUTHORIZED' : raw.toUpperCase();
  }

  static Color _statusColor(FlutterFlowTheme theme, String status) {
    switch (status) {
      case 'AUTHORIZED':
        return theme.success;
      case 'CANCELLED':
      case 'CANCELED':
        return theme.error;
      default:
        return theme.secondary;
    }
  }

  Widget _verticalDivider(FlutterFlowTheme theme) => Container(
        width: 1,
        height: 34,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: theme.grayscale30,
      );
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: theme.secondaryText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
