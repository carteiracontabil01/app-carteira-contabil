import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class HomeSurfaceTokens {
  static const double cardRadius = 18;
  static const double largeCardRadius = 20;

  static BoxDecoration cardDecoration(
    FlutterFlowTheme theme, {
    double radius = cardRadius,
    Color? color,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      color: color ?? theme.secondaryBackground,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: theme.grayscale30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
