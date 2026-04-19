import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class MeusDadosAvatarPicker extends StatelessWidget {
  const MeusDadosAvatarPicker({
    super.key,
    required this.imageUrl,
    required this.isUploading,
    required this.onTap,
  });

  final String? imageUrl;
  final bool isUploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(58),
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: imageUrl == null || imageUrl!.isEmpty
                    ? theme.primary.withValues(alpha: 0.09)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.primary,
                  width: 2,
                ),
              ),
              child: isUploading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                      ),
                    )
                  : _AvatarImage(imageUrl: imageUrl),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.secondaryBackground,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 16,
                color: theme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    if (!hasImage) {
      return Icon(
        Icons.person_rounded,
        size: 50,
        color: theme.primary,
      );
    }

    return ClipOval(
      child: Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.person_rounded,
          size: 50,
          color: theme.primary,
        ),
      ),
    );
  }
}
