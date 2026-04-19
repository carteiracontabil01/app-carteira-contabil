import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyInfoTabSelector extends StatelessWidget {
  const CompanyInfoTabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return TabBar(
      labelColor: theme.tertiary,
      unselectedLabelColor: theme.secondaryText,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      dividerColor: Colors.transparent,
      labelStyle: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
      unselectedLabelStyle: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      tabs: const [
        Tab(text: 'Dados gerais'),
        Tab(text: 'Endereço'),
      ],
    );
  }
}
