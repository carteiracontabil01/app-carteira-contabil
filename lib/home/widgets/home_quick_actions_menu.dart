import '/flutter_flow/flutter_flow_theme.dart';
import 'home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeQuickActionItem {
  const HomeQuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class HomeQuickActionsMenu extends StatelessWidget {
  const HomeQuickActionsMenu({
    super.key,
    required this.actions,
  });

  final List<HomeQuickActionItem> actions;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final maxViewportWidth = MediaQuery.sizeOf(context).width - 40;
    final itemWidth = maxViewportWidth.clamp(102.0, 116.0);
    final viewportFraction =
        (itemWidth / maxViewportWidth).clamp(0.27, 0.33).toDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acesso rápido',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ações essenciais da sua empresa',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          _QuickActionsCarousel(
            actions: actions,
            viewportFraction: viewportFraction,
            height: 112,
          ),
        ],
      ),
    );
  }
}

class _QuickActionsCarousel extends StatefulWidget {
  const _QuickActionsCarousel({
    required this.actions,
    required this.viewportFraction,
    required this.height,
  });

  final List<HomeQuickActionItem> actions;
  final double viewportFraction;
  final double height;

  @override
  State<_QuickActionsCarousel> createState() => _QuickActionsCarouselState();
}

class _QuickActionsCarouselState extends State<_QuickActionsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
    );
  }

  @override
  void didUpdateWidget(covariant _QuickActionsCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.viewportFraction - widget.viewportFraction).abs() > 0.001) {
      final oldPage = _currentPage;
      _pageController.dispose();
      _pageController = PageController(
        viewportFraction: widget.viewportFraction,
        initialPage: oldPage.clamp(0, widget.actions.length - 1),
      );
    }
    if (_currentPage >= widget.actions.length && widget.actions.isNotEmpty) {
      setState(() => _currentPage = widget.actions.length - 1);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.actions.length,
            physics: const BouncingScrollPhysics(),
            padEnds: false,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final action = widget.actions[index];
              final isLast = index == widget.actions.length - 1;
              return Padding(
                padding: EdgeInsets.only(
                  right: isLast ? 0 : 8,
                ),
                child: _HomeQuickActionButton(action: action),
              );
            },
          ),
        ),
        if (widget.actions.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            children: List.generate(widget.actions.length, (index) {
              final selected = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(right: 6),
                height: 6,
                width: selected ? 18 : 6,
                decoration: BoxDecoration(
                  color: selected
                      ? theme.primary
                      : theme.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _HomeQuickActionButton extends StatelessWidget {
  const _HomeQuickActionButton({required this.action});

  final HomeQuickActionItem action;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.secondaryBackground,
        theme.grayscale10,
      ],
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(HomeSurfaceTokens.cardRadius),
      elevation: 0,
      child: Container(
        decoration: HomeSurfaceTokens.cardDecoration(
          theme,
          gradient: gradient,
        ).copyWith(
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.12),
            width: 1.1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(HomeSurfaceTokens.cardRadius),
          onTap: action.onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.grayscale30,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(action.icon, color: Colors.black87, size: 17),
                    ),
                    const Spacer(),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: theme.grayscale30,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: theme.grayscale30),
                      ),
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        size: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    action.label,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: theme.primary,
                      height: 1.25,
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Abrir',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: theme.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
