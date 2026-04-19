import '/flutter_flow/flutter_flow_theme.dart';
import 'home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePaymentStatusSection extends StatelessWidget {
  const HomePaymentStatusSection({
    super.key,
    required this.paidInvoices,
    required this.pendingInvoices,
    required this.overdueInvoices,
  });

  final int paidInvoices;
  final int pendingInvoices;
  final int overdueInvoices;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final total = paidInvoices + pendingInvoices + overdueInvoices;
    final segments = <_PieSegment>[
      _PieSegment(
        value: paidInvoices.toDouble(),
        color: theme.success,
        label: 'Pago',
      ),
      _PieSegment(
        value: pendingInvoices.toDouble(),
        color: theme.warning,
        label: 'Pendente',
      ),
      _PieSegment(
        value: overdueInvoices.toDouble(),
        color: theme.error,
        label: 'Atrasado',
      ),
    ].where((segment) => segment.value > 0).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status dos pagamentos',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Distribuição de títulos pagos, pendentes e atrasados',
            style: theme.bodySmall.override(
              color: theme.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          if (total == 0)
            _EmptyStateCard(
              text: 'Nenhum título no período',
            )
          else
            _DonutStatusCard(
              total: total,
              segments: segments,
            ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration:
          HomeSurfaceTokens.cardDecoration(FlutterFlowTheme.of(context)),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ),
    );
  }
}

class _DonutStatusCard extends StatelessWidget {
  const _DonutStatusCard({
    required this.total,
    required this.segments,
  });

  final int total;
  final List<_PieSegment> segments;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    const double size = 190;
    final paidValue = segments
        .where((segment) => segment.label == 'Pago')
        .fold<double>(0, (sum, segment) => sum + segment.value);
    final paidPct = total > 0 ? (paidValue / total) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: HomeSurfaceTokens.cardDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: _DonutChartPainter(
                      segments: segments,
                      total: total.toDouble(),
                      strokeWidth: 24,
                    ),
                    size: const Size(size, size),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${paidPct.toStringAsFixed(0)}%',
                        style: theme.headlineSmall.override(
                          color: theme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Pago',
                        style: theme.bodySmall.override(
                          color: theme.secondaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...segments.map((segment) {
            final pct = total > 0 ? (segment.value / total * 100) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: segment.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${segment.label} — ${pct.toStringAsFixed(0)}%',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                  Text(
                    segment.value.toInt().toString(),
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PieSegment {
  const _PieSegment({
    required this.value,
    required this.color,
    required this.label,
  });

  final double value;
  final Color color;
  final String label;
}

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({
    required this.segments,
    required this.total,
    required this.strokeWidth,
  });

  final List<_PieSegment> segments;
  final double total;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - strokeWidth / 2;
    double startAngle = -3.14159265359 / 2;

    for (final segment in segments) {
      if (segment.value <= 0) continue;
      final sweepAngle = 2 * 3.14159265359 * (segment.value / total);
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.total != total;
  }
}
