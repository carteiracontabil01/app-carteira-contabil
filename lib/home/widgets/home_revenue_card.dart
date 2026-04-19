import '/flutter_flow/flutter_flow_theme.dart';
import 'home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeRevenueCard extends StatelessWidget {
  const HomeRevenueCard({
    super.key,
    required this.revenueLabel,
    required this.isRevenueVisible,
    required this.growthLabel,
    required this.isGrowthPositive,
    required this.comparisonLabel,
    required this.periodSubtitle,
    required this.onPeriodTap,
  });

  final String revenueLabel;
  final bool isRevenueVisible;
  final String growthLabel;
  final bool isGrowthPositive;
  final String comparisonLabel;
  final String periodSubtitle;
  final VoidCallback onPeriodTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: HomeSurfaceTokens.cardDecoration(
          theme,
          radius: HomeSurfaceTokens.largeCardRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.secondaryBackground,
              theme.accent3.withValues(alpha: 0.55),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onPeriodTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AnimatedCrossFade(
                              duration: const Duration(milliseconds: 250),
                              firstChild: SizedBox(
                                height: 46,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      revenueLabel,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.visible,
                                      style: GoogleFonts.manrope(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primary,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              secondChild: SizedBox(
                                height: 46,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '••••••',
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.visible,
                                      style: GoogleFonts.manrope(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primary,
                                        letterSpacing: 4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              crossFadeState: isRevenueVisible
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedOpacity(
                  opacity: isRevenueVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isGrowthPositive ? theme.success : theme.error)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isGrowthPositive
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color:
                                  isGrowthPositive ? theme.success : theme.error,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              growthLabel,
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color:
                                    isGrowthPositive ? theme.success : theme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comparisonLabel,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            InkWell(
              onTap: onPeriodTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.only(top: 0, right: 4, bottom: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Período de ',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: theme.secondaryText,
                        ),
                        children: [
                          TextSpan(
                            text: periodSubtitle,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: theme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Use o filtro para alterar',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: theme.secondaryText.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.tonalIcon(
                        onPressed: onPeriodTap,
                        icon: const Icon(Icons.tune_rounded, size: 16),
                        label: const Text('Filtrar período'),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.primary.withValues(alpha: 0.1),
                          foregroundColor: theme.primary,
                          textStyle: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
