import '/flutter_flow/flutter_flow_theme.dart';
import '/shared/widgets/period_filter_mode_selector.dart';
import '/shared/widgets/period_filter_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NfseListFilterPanel extends StatelessWidget {
  const NfseListFilterPanel({
    super.key,
    required this.filterType,
    required this.selectedMonth,
    required this.selectedYear,
    required this.rangeStart,
    required this.rangeEnd,
    required this.onSelectMonth,
    required this.onSelectYear,
    required this.onSelectRange,
    required this.onPreviousPeriod,
    required this.onNextPeriod,
  });

  final String filterType;
  final DateTime selectedMonth;
  final int selectedYear;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final VoidCallback onSelectMonth;
  final VoidCallback onSelectYear;
  final VoidCallback onSelectRange;
  final VoidCallback onPreviousPeriod;
  final VoidCallback onNextPeriod;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.grayscale30),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PeriodFilterModeSelector(
            options: const [
              PeriodFilterModeOption(id: 'month', label: 'Mensal'),
              PeriodFilterModeOption(id: 'year', label: 'Anual'),
              PeriodFilterModeOption(id: 'range', label: 'Intervalo'),
            ],
            selectedId: filterType,
            onSelected: (value) {
              if (value == 'month') onSelectMonth();
              if (value == 'year') onSelectYear();
              if (value == 'range') onSelectRange();
            },
            expandItems: false,
            spacing: 6,
          ),
          const SizedBox(height: 12),
          if (filterType != 'range')
            PeriodFilterStepper(
              label: _periodLabel(),
              onPrev: onPreviousPeriod,
              onNext: onNextPeriod,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.grayscale20,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.grayscale30),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.grayscale30),
                  ),
                  child: Text(
                    _periodLabel(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _periodLabel() {
    if (filterType == 'range' && rangeStart != null && rangeEnd != null) {
      return '${DateFormat('dd/MM/yyyy').format(rangeStart!)} - ${DateFormat('dd/MM/yyyy').format(rangeEnd!)}';
    }
    if (filterType == 'month') {
      return DateFormat('MMMM yyyy', 'pt_BR').format(selectedMonth);
    }
    return '$selectedYear';
  }
}
