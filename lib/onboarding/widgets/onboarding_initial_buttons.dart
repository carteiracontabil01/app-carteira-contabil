import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingInitialButtons extends StatelessWidget {
  const OnboardingInitialButtons({
    super.key,
    required this.onCreateAccountTap,
    required this.onLoginTap,
  });

  final VoidCallback onCreateAccountTap;
  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          height: 56.0,
          child: FFButtonWidget(
            onPressed: onCreateAccountTap,
            text: 'Criar uma conta',
            options: FFButtonOptions(
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xFFD5D91B),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    color: const Color(0xFF15203D),
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          height: 56.0,
          child: FFButtonWidget(
            onPressed: onLoginTap,
            text: 'Entrar',
            options: FFButtonOptions(
              height: 56.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xFF15203D),
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
        ),
      ],
    );
  }
}
