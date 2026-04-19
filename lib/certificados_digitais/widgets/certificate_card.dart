import '/enums/company_access_type_enum.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/shared/widgets/app_chip.dart';
import '../models/certificate_access_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({
    super.key,
    required this.certificate,
    required this.onDownloadPressed,
  });

  final CertificateAccessItem certificate;
  final VoidCallback? onDownloadPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.grayscale30),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CertificateTypeIcon(type: certificate.type),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certificate.name,
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: theme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _CertificateTypeChip(
                              type: certificate.type,
                              label: certificate.typeLabel,
                            ),
                            _CertificateStatusChip(
                              status: certificate.lifecycleStatus,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: theme.grayscale30, height: 1),
              if (certificate.login.isNotEmpty) ...[
                const SizedBox(height: 10),
                CertificateInfoRow(label: 'Usuário', value: certificate.login),
              ],
              if (certificate.expirationDateLabel != null)
                CertificateInfoRow(
                  label: 'Validade',
                  value: certificate.expirationDateLabel!,
                  valueColor:
                      certificate.lifecycleStatus ==
                              CertificateLifecycleStatus.expired
                          ? theme.error
                          : null,
                ),
              if (certificate.createdAtLabel != null)
                CertificateInfoRow(
                  label: 'Cadastro',
                  value: certificate.createdAtLabel!,
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: onDownloadPressed,
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: Text(
                    'Baixar certificado',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.primary,
                    disabledBackgroundColor: theme.grayscale30,
                    disabledForegroundColor: theme.grayscale70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateTypeIcon extends StatelessWidget {
  const _CertificateTypeIcon({required this.type});

  final CompanyAccessTypeEnum? type;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primary.withValues(alpha: 0.15),
            theme.alternate.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primary.withValues(alpha: 0.2)),
      ),
      child: Icon(
        switch (type) {
          CompanyAccessTypeEnum.legalEntityCertificate =>
            Icons.business_rounded,
          CompanyAccessTypeEnum.access => Icons.key_rounded,
          _ => Icons.person_rounded,
        },
        color: theme.primary,
        size: 24,
      ),
    );
  }
}

class _CertificateStatusChip extends StatelessWidget {
  const _CertificateStatusChip({required this.status});

  final CertificateLifecycleStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final (label, backgroundColor, borderColor, textColor) = switch (status) {
      CertificateLifecycleStatus.expired => (
        'Expirado',
        const Color(0xFFFEE2E2),
        const Color(0xFFFCA5A5),
        const Color(0xFFB91C1C),
      ),
      CertificateLifecycleStatus.expiringSoon => (
        'Próximo do vencimento',
        const Color(0xFFFEF3C7),
        const Color(0xFFFCD34D),
        const Color(0xFF92400E),
      ),
      CertificateLifecycleStatus.active => (
        'Ativo',
        theme.success.withValues(alpha: 0.14),
        theme.success.withValues(alpha: 0.32),
        const Color(0xFF166534),
      ),
      CertificateLifecycleStatus.inactive => (
        'Inativo',
        theme.grayscale30,
        theme.grayscale50,
        theme.grayscale80,
      ),
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 26),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}

class _CertificateTypeChip extends StatelessWidget {
  const _CertificateTypeChip({
    required this.type,
    required this.label,
  });

  final CompanyAccessTypeEnum? type;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final accentColor = switch (type) {
      CompanyAccessTypeEnum.legalEntityCertificate => theme.primary,
      CompanyAccessTypeEnum.individualCertificate => theme.secondary,
      CompanyAccessTypeEnum.access => theme.warning,
      _ => theme.grayscale70,
    };

    return AppChip(
      label: label,
      accentColor: accentColor,
    );
  }
}

class CertificateInfoRow extends StatelessWidget {
  const CertificateInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? theme.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
