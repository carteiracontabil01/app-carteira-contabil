import '/flutter_flow/flutter_flow_theme.dart';
import '/home/widgets/home_surface_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.companyName,
    required this.maskedCnpj,
    required this.companyPhotoUrl,
    required this.isUploadingPhoto,
    required this.onCopyCnpj,
    required this.onPhotoTap,
  });

  final String companyName;
  final String maskedCnpj;
  final String? companyPhotoUrl;
  final bool isUploadingPhoto;
  final VoidCallback? onCopyCnpj;
  final VoidCallback? onPhotoTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasPhoto = companyPhotoUrl != null &&
        companyPhotoUrl!.trim().isNotEmpty &&
        companyPhotoUrl!.trim() != 'null';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(22),
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 20),
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: onPhotoTap,
                borderRadius: BorderRadius.circular(56),
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: hasPhoto
                        ? Colors.transparent
                        : theme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.primary, width: 2),
                  ),
                  child: isUploadingPhoto
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(theme.primary),
                          ),
                        )
                      : hasPhoto
                          ? ClipOval(
                              child: Image.network(
                                companyPhotoUrl!,
                                key: ValueKey(
                                    'company_photo_${companyPhotoUrl!}'),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.apartment_rounded,
                                  size: 44,
                                  color: theme.primary,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.apartment_rounded,
                              size: 44,
                              color: theme.primary,
                            ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: theme.secondaryBackground, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 15,
                    color: theme.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            companyName,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          if (maskedCnpj.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  maskedCnpj,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: theme.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: onCopyCnpj,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 17,
                      color: theme.primary,
                    ),
                  ),
                ),
              ],
            )
          else
            Text(
              'CNPJ não informado',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: theme.secondaryText,
              ),
            ),
        ],
      ),
    );
  }
}
