class HomePeriodSelection {
  const HomePeriodSelection({
    required this.filterType,
    required this.selectedMonth,
    required this.selectedYear,
    this.rangeStart,
    this.rangeEnd,
  });

  final String filterType;
  final DateTime selectedMonth;
  final int selectedYear;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
}
