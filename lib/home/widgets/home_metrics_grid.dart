import '/flutter_flow/flutter_flow_theme.dart';
import 'home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeMetricItem {
  const HomeMetricItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconAssetPath,
    required this.iconColor,
    this.trend,
    this.trendUp = true,
  }) : assert(
          icon != null || iconAssetPath != null,
          'HomeMetricItem requires icon or iconAssetPath.',
        );

  final String label;
  final String value;
  final IconData? icon;
  final String? iconAssetPath;
  final Color iconColor;
  final String? trend;
  final bool trendUp;
}

class HomeMetricsGrid extends StatelessWidget {
  const HomeMetricsGrid({
    super.key,
    required this.metrics,
  });

  final List<HomeMetricItem> metrics;

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    final firstRow = metrics.take(2).toList();
    final secondRow = metrics.skip(2).take(2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _MetricsRow(items: firstRow),
          const SizedBox(height: spacing),
          _MetricsRow(items: secondRow),
        ],
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.items});

  final List<HomeMetricItem> items;

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Expanded(child: _MetricCard(item: items[index])),
          if (index < items.length - 1) const SizedBox(width: spacing),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.item});

  final HomeMetricItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration:
          HomeSurfaceTokens.cardDecoration(FlutterFlowTheme.of(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: item.iconAssetPath != null
                    ? Image.asset(
                        item.iconAssetPath!,
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      )
                    : Icon(item.icon, size: 16, color: item.iconColor),
              ),
              if (item.trend != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (item.trendUp
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935))
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.trendUp
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 12,
                        color: item.trendUp
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        item.trend!,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: item.trendUp
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.value,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: FlutterFlowTheme.of(context).primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
