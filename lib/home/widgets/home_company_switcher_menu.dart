import '/flutter_flow/flutter_flow_theme.dart';
import '/home/models/home_company_option.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<HomeCompanyOption?> showHomeCompanySwitcherMenu(
  BuildContext context,
  List<HomeCompanyOption> companies,
) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final box = context.findRenderObject() as RenderBox;
  final topLeft = box.localToGlobal(Offset.zero);
  final overlaySize = overlay.size;
  const horizontalPadding = 20.0;
  final menuTop = topLeft.dy + box.size.height + 4;
  final menuWidth = overlaySize.width - 2 * horizontalPadding;
  final theme = FlutterFlowTheme.of(context);

  final selectedCompanyId = await showMenu<String>(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(
        horizontalPadding,
        menuTop,
        menuWidth,
        overlaySize.height - menuTop - horizontalPadding,
      ),
      Offset.zero & overlaySize,
    ),
    elevation: 8,
    color: theme.secondaryBackground,
    shadowColor: Colors.black.withValues(alpha: 0.12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    items: companies.map((item) {
      return PopupMenuItem<String>(
        value: item.companyId,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SizedBox(
          width: menuWidth - 32,
          child: Text(
            item.businessName.isEmpty ? 'Empresa' : item.businessName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
            ),
          ),
        ),
      );
    }).toList(),
  );

  if (selectedCompanyId == null) return null;
  final selectedIndex = companies.indexWhere(
    (item) => item.companyId == selectedCompanyId,
  );
  if (selectedIndex < 0) return null;
  return companies[selectedIndex];
}
