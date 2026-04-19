import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.accentColor,
    this.icon,
    this.filled = false,
    this.minHeight = 26,
    this.horizontalPadding = 10,
    this.verticalPadding = 4,
  });

  final String label;
  final Color accentColor;
  final IconData? icon;
  final bool filled;
  final double minHeight;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bgColor = filled ? accentColor : accentColor.withValues(alpha: 0.12);
    final textColor = filled ? theme.tertiary : accentColor;
    final borderColor = filled
        ? accentColor.withValues(alpha: 0.9)
        : accentColor.withValues(alpha: 0.28);

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
