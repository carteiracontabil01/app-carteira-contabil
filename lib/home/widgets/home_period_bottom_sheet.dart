import '/flutter_flow/flutter_flow_theme.dart';
import '/home/models/home_period_selection.dart';
import '/shared/widgets/period_filter_mode_selector.dart';
import '/shared/widgets/period_filter_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Future<HomePeriodSelection?> showHomePeriodBottomSheet(
  BuildContext context, {
  required String currentFilterType,
  required DateTime currentMonth,
  required int currentYear,
  DateTime? currentRangeStart,
  DateTime? currentRangeEnd,
}) async {
  String sheetType = currentFilterType;
  DateTime sheetMonth = currentMonth;
  int sheetYear = currentYear;
  DateTime? sheetRangeStart = currentRangeStart;
  DateTime? sheetRangeEnd = currentRangeEnd;

  if (sheetRangeStart == null || sheetRangeEnd == null) {
    final now = DateTime.now();
    sheetRangeStart = DateTime(now.year, now.month, 1);
    sheetRangeEnd = DateTime(now.year, now.month + 1, 0);
  }

  return showModalBottomSheet<HomePeriodSelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) {
        final theme = FlutterFlowTheme.of(ctx);
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.secondaryText.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Período',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              PeriodFilterModeSelector(
                options: const [
                  PeriodFilterModeOption(id: 'month', label: 'Mensal'),
                  PeriodFilterModeOption(id: 'year', label: 'Anual'),
                  PeriodFilterModeOption(id: 'range', label: 'Intervalo'),
                ],
                selectedId: sheetType,
                onSelected: (value) => setModalState(() => sheetType = value),
              ),
              const SizedBox(height: 16),
              if (sheetType == 'month')
                PeriodFilterStepper(
                  label: DateFormat('MMMM yyyy', 'pt_BR').format(sheetMonth),
                  onPrev: () => setModalState(
                    () => sheetMonth =
                        DateTime(sheetMonth.year, sheetMonth.month - 1),
                  ),
                  onNext: () => setModalState(
                    () => sheetMonth =
                        DateTime(sheetMonth.year, sheetMonth.month + 1),
                  ),
                )
              else if (sheetType == 'year')
                PeriodFilterStepper(
                  label: '$sheetYear',
                  onPrev: () => setModalState(() => sheetYear--),
                  onNext: () => setModalState(() => sheetYear++),
                )
              else
                _PeriodRangeBlock(
                  start: sheetRangeStart!,
                  end: sheetRangeEnd!,
                  onStartPicked: (DateTime value) =>
                      setModalState(() => sheetRangeStart = value),
                  onEndPicked: (DateTime value) =>
                      setModalState(() => sheetRangeEnd = value),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(
                      HomePeriodSelection(
                        filterType: sheetType,
                        selectedMonth: sheetMonth,
                        selectedYear: sheetYear,
                        rangeStart: sheetRangeStart,
                        rangeEnd: sheetRangeEnd,
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    backgroundColor: theme.primary,
                    foregroundColor: theme.tertiary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Aplicar',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _PeriodRangeBlock extends StatelessWidget {
  const _PeriodRangeBlock({
    required this.start,
    required this.end,
    required this.onStartPicked,
    required this.onEndPicked,
  });

  final DateTime start;
  final DateTime end;
  final ValueChanged<DateTime> onStartPicked;
  final ValueChanged<DateTime> onEndPicked;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _PeriodDateTile(
            label: 'Data inicial',
            value: start,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onPicked: onStartPicked,
            isTop: true,
          ),
          Divider(
            height: 1,
            color: theme.primaryText.withValues(alpha: 0.08),
          ),
          _PeriodDateTile(
            label: 'Data final',
            value: end,
            firstDate: start,
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onPicked: onEndPicked,
            isTop: false,
          ),
        ],
      ),
    );
  }
}

class _PeriodDateTile extends StatelessWidget {
  const _PeriodDateTile({
    required this.label,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    required this.onPicked,
    required this.isTop,
  });

  final String label;
  final DateTime value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onPicked;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: value,
            firstDate: firstDate,
            lastDate: lastDate,
          );
          if (picked != null) onPicked(picked);
        },
        borderRadius: isTop
            ? const BorderRadius.vertical(top: Radius.circular(12))
            : const BorderRadius.vertical(bottom: Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  color: theme.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('dd/MM/yyyy', 'pt_BR').format(value),
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: theme.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
