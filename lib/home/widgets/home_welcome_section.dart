import '/flutter_flow/flutter_flow_theme.dart';
import 'home_surface_tokens.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWelcomeSection extends StatelessWidget {
  const HomeWelcomeSection({
    super.key,
    required this.companyName,
    required this.companyPhotoUrl,
    required this.hasCompanySwitcher,
    required this.onAvatarTap,
    this.onCompanyTap,
  });

  final String companyName;
  final String? companyPhotoUrl;
  final bool hasCompanySwitcher;
  final VoidCallback onAvatarTap;
  final VoidCallback? onCompanyTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasCompanyPhoto = companyPhotoUrl != null &&
        companyPhotoUrl!.trim().isNotEmpty &&
        companyPhotoUrl!.trim() != 'null';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: HomeSurfaceTokens.cardDecoration(
          theme,
          radius: HomeSurfaceTokens.largeCardRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onAvatarTap,
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  key: ValueKey(
                      'welcome_company_photo_${companyPhotoUrl ?? 'none'}'),
                  radius: 28,
                  backgroundColor: theme.primary.withValues(alpha: 0.15),
                  child: hasCompanyPhoto
                      ? ClipOval(
                          child: Image.network(
                            companyPhotoUrl!,
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.apartment_rounded,
                              size: 30,
                              color: theme.primary,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.apartment_rounded,
                          size: 30,
                          color: theme.primary,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seja bem vindo',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!hasCompanySwitcher)
                    _CompanyNameText(companyName: companyName)
                  else
                    InkWell(
                      onTap: onCompanyTap,
                      borderRadius: BorderRadius.circular(8),
                      child: _CompanySwitcherLabel(companyName: companyName),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyNameText extends StatelessWidget {
  const _CompanyNameText({required this.companyName});

  final String companyName;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      companyName,
      style: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: FlutterFlowTheme.of(context).primary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      minFontSize: 13,
      stepGranularity: 0.5,
    );
  }
}

class _CompanySwitcherLabel extends StatelessWidget {
  const _CompanySwitcherLabel({required this.companyName});

  final String companyName;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              companyName,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: theme.primary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 13,
              stepGranularity: 0.5,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: theme.primary,
          ),
        ],
      ),
    );
  }
}
