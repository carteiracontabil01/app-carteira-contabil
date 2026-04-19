import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NfseListEmptyState extends StatelessWidget {
  const NfseListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primary.withValues(alpha: 0.1),
                border:
                    Border.all(color: theme.primary.withValues(alpha: 0.18)),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 46,
                color: theme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma NFS-e encontrada',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma nota fiscal emitida no período selecionado.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
