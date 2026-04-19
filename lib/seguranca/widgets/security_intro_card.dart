import '/flutter_flow/flutter_flow_theme.dart';
import '/home/widgets/home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityIntroCard extends StatelessWidget {
  const SecurityIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: HomeSurfaceTokens.cardDecoration(
        theme,
        radius: 20,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.security_rounded,
              size: 32,
              color: theme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proteja sua conta',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: theme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gerencie a segurança da sua conta.',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: theme.secondaryText,
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
