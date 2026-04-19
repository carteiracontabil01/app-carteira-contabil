import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsOptionTile extends StatelessWidget {
  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.switchValue,
    this.onSwitchChanged,
    this.showDivider = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool showDivider;

  bool get hasSwitch => switchValue != null;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      onTap: hasSwitch ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: theme.grayscale30,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: theme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (hasSwitch)
              Switch.adaptive(
                value: switchValue!,
                onChanged: onSwitchChanged,
                activeColor: theme.tertiary,
                activeTrackColor: theme.primary.withValues(alpha: 0.75),
                inactiveThumbColor: theme.grayscale10,
                inactiveTrackColor: theme.grayscale60,
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: theme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
