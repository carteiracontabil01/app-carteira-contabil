import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeriodFilterStepper extends StatelessWidget {
  const PeriodFilterStepper({
    super.key,
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.primaryText.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          _StepperIconButton(
            icon: Icons.chevron_left_rounded,
            onPressed: onPrev,
            theme: theme,
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.primaryText.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: theme.primary,
                  ),
                ),
              ),
            ),
          ),
          _StepperIconButton(
            icon: Icons.chevron_right_rounded,
            onPressed: onNext,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _StepperIconButton extends StatelessWidget {
  const _StepperIconButton({
    required this.icon,
    required this.onPressed,
    required this.theme,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.primaryText.withValues(alpha: 0.08),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 18,
        icon: Icon(
          icon,
          size: 24,
          color: theme.primary,
        ),
      ),
    );
  }
}
