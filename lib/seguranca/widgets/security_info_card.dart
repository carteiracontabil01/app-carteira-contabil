import '/flutter_flow/flutter_flow_theme.dart';
import '/home/widgets/home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityInfoCard extends StatelessWidget {
  const SecurityInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(
        theme,
        radius: 14,
        color: theme.primary.withValues(alpha: 0.08),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: theme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dica de Segurança',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use uma senha forte com letras, números e caracteres especiais. Ative a autenticação biométrica para maior segurança.',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: theme.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
