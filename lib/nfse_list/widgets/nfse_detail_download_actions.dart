import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NfseDetailDownloadActions extends StatelessWidget {
  const NfseDetailDownloadActions({
    super.key,
    required this.onDownloadPdf,
    required this.onDownloadXml,
  });

  final VoidCallback? onDownloadPdf;
  final VoidCallback? onDownloadXml;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: onDownloadPdf,
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
            label: Text(
              'Abrir PDF',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: theme.primary.withValues(alpha: 0.1),
              foregroundColor: theme.primary,
              disabledBackgroundColor: theme.grayscale30,
              disabledForegroundColor: theme.grayscale70,
              elevation: 0,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDownloadXml,
            icon: const Icon(Icons.code_rounded, size: 18),
            label: Text(
              'Abrir XML',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primary,
              disabledForegroundColor: theme.grayscale70,
              side: BorderSide(color: theme.primary.withValues(alpha: 0.35)),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
