import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTabSelector extends StatelessWidget {
  const AuthTabSelector({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  final int currentTab;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).grayscale20,
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AuthTabItem(
              label: 'Login',
              isActive: currentTab == 0,
              onTap: () => onTabChanged(0),
            ),
          ),
          Expanded(
            child: _AuthTabItem(
              label: 'Cadastrar',
              isActive: currentTab == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTabItem extends StatelessWidget {
  const _AuthTabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF15203D) : Colors.transparent,
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                ),
                color: isActive
                    ? Colors.white
                    : FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}
