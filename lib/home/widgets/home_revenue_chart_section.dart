import '/flutter_flow/flutter_flow_theme.dart';
import 'home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeRevenueChartSection extends StatelessWidget {
  const HomeRevenueChartSection({
    super.key,
    required this.chartData,
    required this.filterType,
    required this.selectedMonth,
    required this.selectedYear,
    required this.isRevenueVisible,
    required this.onBarTap,
  });

  final List<Map<String, dynamic>> chartData;
  final String filterType;
  final DateTime selectedMonth;
  final int selectedYear;
  final bool isRevenueVisible;
  final void Function(int year, int month) onBarTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faturamento por período',
            style: theme.headlineSmall.override(
              color: theme.primary,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tendência recente de receita da empresa',
            style: theme.bodySmall.override(
              color: theme.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          _HomeRevenueChart(
            chartData: chartData,
            filterType: filterType,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            isRevenueVisible: isRevenueVisible,
            onBarTap: onBarTap,
          ),
        ],
      ),
    );
  }
}

class _HomeRevenueChart extends StatelessWidget {
  const _HomeRevenueChart({
    required this.chartData,
    required this.filterType,
    required this.selectedMonth,
    required this.selectedYear,
    required this.isRevenueVisible,
    required this.onBarTap,
  });

  final List<Map<String, dynamic>> chartData;
  final String filterType;
  final DateTime selectedMonth;
  final int selectedYear;
  final bool isRevenueVisible;
  final void Function(int year, int month) onBarTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (chartData.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: HomeSurfaceTokens.cardDecoration(theme),
        child: Center(
          child: Text(
            'Nenhum dado para exibir no período',
            style: theme.bodyMedium.override(
              color: theme.secondaryText,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    final maxValue = chartData
        .map((e) => e['value'] as double)
        .fold(0.0, (a, b) => a > b ? a : b);
    final safeMax = maxValue > 0 ? maxValue : 1.0;

    double niceMax = safeMax;
    if (niceMax > 1000) {
      niceMax = (niceMax / 1000).ceil() * 1000.0;
    } else if (niceMax > 0) {
      niceMax = niceMax.ceilToDouble();
    }
    const int tickCount = 5;
    final yTicks = List.generate(
      tickCount,
      (i) => niceMax * (tickCount - 1 - i) / (tickCount - 1),
    );

    String formatY(double value) {
      if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}K';
      }
      return value.toStringAsFixed(0);
    }

    const double chartHeight = 180.0;
    final values = chartData.map((item) => item['value'] as double).toList();
    final months = chartData.map((item) => item['month'] as String).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: HomeSurfaceTokens.cardDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChartHeader(
            title: 'Últimos 6 meses',
            value: values.last,
            isRevenueVisible: isRevenueVisible,
            theme: theme,
          ),
          const SizedBox(height: 20),
          if (!isRevenueVisible)
            SizedBox(
              height: 230,
              child: Center(
                child: Text(
                  'Valores em reais ocultos',
                  style: theme.bodyMedium.override(
                    color: theme.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 230,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: chartHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: yTicks.map((tick) {
                        return Text(
                          formatY(tick),
                          style: theme.bodySmall.override(
                            color: theme.secondaryText,
                            fontSize: 10,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _LineGridPainter(
                                    lineColor:
                                        theme.grayscale40.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _RevenueLinePainter(
                                      values: values,
                                      maxValue: niceMax,
                                      lineColor: theme.primary,
                                      fillColor: theme.primary.withValues(alpha: 0.16),
                                    dotInnerColor: theme.tertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: months.asMap().entries.map((entry) {
                            final index = entry.key;
                            final month = entry.value;
                            final ref = filterType == 'year'
                                ? DateTime(selectedYear, 12, 1)
                                : DateTime(
                                    selectedMonth.year,
                                    selectedMonth.month,
                                    1,
                                  );
                            final target = DateTime(
                              ref.year,
                              ref.month - (months.length - 1 - index),
                              1,
                            );
                            return Expanded(
                              child: InkWell(
                                onTap: () => onBarTap(target.year, target.month),
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    month,
                                    style: theme.bodySmall.override(
                                      color: theme.secondaryText,
                                      fontSize: 11,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartHeader extends StatelessWidget {
  const _ChartHeader({
    required this.title,
    required this.value,
    required this.isRevenueVisible,
    required this.theme,
  });

  final String title;
  final double value;
  final bool isRevenueVisible;
  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Row(
      children: [
        Text(
          title,
          style: theme.bodyMedium.override(
            color: theme.secondaryText,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          isRevenueVisible ? currencyFormat.format(value) : 'R\$ •••••',
          style: theme.titleSmall.override(
            color: theme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LineGridPainter extends CustomPainter {
  _LineGridPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    const lines = 4;
    for (var i = 0; i <= lines; i++) {
      final y = (size.height / lines) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineGridPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor;
}

class _RevenueLinePainter extends CustomPainter {
  _RevenueLinePainter({
    required this.values,
    required this.maxValue,
    required this.lineColor,
    required this.fillColor,
    required this.dotInnerColor,
  });

  final List<double> values;
  final double maxValue;
  final Color lineColor;
  final Color fillColor;
  final Color dotInnerColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final stepX = size.width / (values.length - 1);
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final normalized = (values[i] / maxValue).clamp(0.0, 1.0);
      final x = i * stepX;
      final y = size.height - (size.height * normalized);
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final cpX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(cpX, p0.dy, cpX, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          fillColor,
          fillColor.withValues(alpha: 0.02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = lineColor;
    final dotCenterPaint = Paint()..color = dotInnerColor;
    for (final point in points) {
      canvas.drawCircle(point, 4.5, dotPaint);
      canvas.drawCircle(point, 2.4, dotCenterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueLinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.dotInnerColor != dotInnerColor;
  }
}
