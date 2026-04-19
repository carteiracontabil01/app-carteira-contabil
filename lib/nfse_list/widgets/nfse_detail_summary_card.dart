import '/flutter_flow/flutter_flow_theme.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/shared/widgets/app_chip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NfseDetailSummaryCard extends StatelessWidget {
  const NfseDetailSummaryCard({
    super.key,
    required this.numero,
    required this.typeLabel,
    required this.emission,
    required this.netValue,
    required this.statusLabel,
    required this.isAuthorized,
    required this.originLabel,
  });

  final String numero;
  final String? typeLabel;
  final String emission;
  final String netValue;
  final String statusLabel;
  final bool isAuthorized;
  final String? originLabel;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: HomeSurfaceTokens.cardDecoration(
        theme,
        radius: HomeSurfaceTokens.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppChip(
                label: 'Nota $numero',
                accentColor: theme.primary,
                icon: Icons.receipt_long_rounded,
              ),
              AppChip(
                label: statusLabel,
                accentColor: isAuthorized ? theme.success : theme.secondary,
              ),
              if (originLabel != null && originLabel!.isNotEmpty)
                AppChip(
                  label: originLabel!,
                  accentColor: theme.secondary,
                ),
            ],
          ),
          if (typeLabel != null && typeLabel!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              typeLabel!,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.secondaryText,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            netValue,
            style: GoogleFonts.nunito(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: theme.primary,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Valor líquido · Emitida em $emission',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
