import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandEnumChip extends StatelessWidget {
  const BrandEnumChip({
    super.key,
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;

  static const Color chipBackground = Color(0xFF34477F); // Azul Acolhimento
  static const Color chipText = Color(0xFFD6DA1C); // Verde Valorizacao

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: chipBackground.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: chipText),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: chipText,
            ),
          ),
        ],
      ),
    );
  }
}
