import '/enums/company_access_type_enum.dart';
import 'package:intl/intl.dart';

enum CertificateLifecycleStatus {
  active,
  expiringSoon,
  expired,
  inactive,
}

class CertificateAccessItem {
  const CertificateAccessItem({
    required this.name,
    required this.type,
    required this.typeLabel,
    required this.login,
    required this.active,
    required this.expirationDate,
    required this.expirationDateLabel,
    required this.createdAtLabel,
    required this.downloadUrl,
  });

  final String name;
  final CompanyAccessTypeEnum? type;
  final String typeLabel;
  final String login;
  final bool active;
  final DateTime? expirationDate;
  final String? expirationDateLabel;
  final String? createdAtLabel;
  final String? downloadUrl;

  CertificateLifecycleStatus get lifecycleStatus {
    final expiry = expirationDate;
    if (expiry != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);

      if (expiryDay.isBefore(today)) {
        return CertificateLifecycleStatus.expired;
      }

      final daysToExpiry = expiryDay.difference(today).inDays;
      if (daysToExpiry <= 30) {
        return CertificateLifecycleStatus.expiringSoon;
      }
    }

    return active
        ? CertificateLifecycleStatus.active
        : CertificateLifecycleStatus.inactive;
  }

  static List<CertificateAccessItem> fromProfile(
    Map<String, dynamic>? profile,
    DateFormat dateFmt,
  ) {
    if (profile == null) return const [];
    final raw = profile['certificates_access'];
    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map((item) => fromMap(Map<String, dynamic>.from(item), dateFmt))
        .whereType<CertificateAccessItem>()
        .toList();
  }

  static CertificateAccessItem? fromMap(
    Map<String, dynamic> raw,
    DateFormat dateFmt,
  ) {
    if (raw.isEmpty) return null;

    final type = CompanyAccessTypeEnum.fromValue(raw['type']?.toString());
    return CertificateAccessItem(
      name: (raw['name'] ?? 'Certificado').toString(),
      type: type,
      typeLabel: type?.shortLabel ?? 'Outro',
      login: (raw['user_login'] ?? '').toString().trim(),
      active: _parseBool(raw['active']),
      expirationDate: _parseDate(raw['expiration_date']),
      expirationDateLabel: _formatDate(raw['expiration_date'], dateFmt),
      createdAtLabel: _formatDate(raw['created_at'], dateFmt),
      downloadUrl: raw['certificate_url']?.toString(),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    final raw = value.toString().trim();
    if (raw.isEmpty) return null;

    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }

  static String? _formatDate(dynamic value, DateFormat dateFmt) {
    if (value == null) return null;
    if (value is DateTime) return dateFmt.format(value);

    final raw = value.toString().trim();
    if (raw.isEmpty) return null;

    try {
      return dateFmt.format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}
