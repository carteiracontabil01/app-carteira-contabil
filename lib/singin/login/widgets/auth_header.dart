import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: 320.0,
            height: 110.0,
            child: ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.asset(
                  'assets/images/ic_carteira_contabil_colorida.png',
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                ),
                letterSpacing: 0.0,
              ),
        ),
        const SizedBox(height: 8.0),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}
