import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeriodFilterModeOption {
  const PeriodFilterModeOption({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

class PeriodFilterModeSelector extends StatelessWidget {
  const PeriodFilterModeSelector({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
    this.expandItems = true,
    this.spacing = 8,
  });

  final List<PeriodFilterModeOption> options;
  final String selectedId;
  final ValueChanged<String> onSelected;
  final bool expandItems;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (expandItems) {
      return Row(
        children: [
          for (final option in options)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                child: _ModePill(
                  label: option.label,
                  selected: selectedId == option.id,
                  onTap: () => onSelected(option.id),
                  theme: theme,
                ),
              ),
            ),
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length; i++) ...[
            _ModePill(
              label: options[i].label,
              selected: selectedId == options[i].id,
              onTap: () => onSelected(options[i].id),
              theme: theme,
              compact: true,
            ),
            if (i < options.length - 1) SizedBox(width: spacing),
          ],
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
    this.compact = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final FlutterFlowTheme theme;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 40,
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 16)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: selected ? theme.primary : theme.secondaryBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? theme.primary
                  : theme.primaryText.withValues(alpha: 0.08),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? theme.tertiary : theme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
