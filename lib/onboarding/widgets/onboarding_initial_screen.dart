import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingInitialScreen extends StatelessWidget {
  const OnboardingInitialScreen({
    super.key,
    required this.availableHeight,
    required this.onHelpTap,
  });

  final double availableHeight;
  final VoidCallback onHelpTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: availableHeight * 0.3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF15203D),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF15203D),
                    Color(0xFF1A2A4F),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        'assets/images/icone-azul.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40.0,
                    left: 24.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        'assets/images/icone-verde.png',
                        width: 48.0,
                        height: 48.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40.0,
                    right: 24.0,
                    child: GestureDetector(
                      onTap: onHelpTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ajuda',
                            style: GoogleFonts.nunito(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(
                            Icons.help_outline,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24.0,
                    bottom: 120.0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: Text(
                        'Contabilidade\ndo seu negócio\nem qualquer\nhora e lugar.',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: availableHeight * 0.7,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
