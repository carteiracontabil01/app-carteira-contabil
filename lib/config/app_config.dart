/// Configuração do White Label App
///
/// Cada cliente terá seu próprio arquivo de configuração
/// em lib/environments/env_<cliente>.dart
class AppConfig {
  /// Nome do app (exibido nas stores e no app)
  final String appName;

  /// Package ID único por cliente
  /// Android: com.carteiracontabil.<cliente>
  /// iOS: com.carteiracontabil.<cliente>
  final String appId;

  /// Slug do tenant no Supabase (fixo para white label)
  /// Exemplo: "lopes-supermercado"
  final String tenantSlug;

  /// Cor primária do app (hexadecimal)
  /// Exemplo: "#ef4444" (vermelho)
  final String primaryColor;

  /// Cor secundária do app (hexadecimal)
  /// Exemplo: "#f97316" (laranja)
  final String secondaryColor;

  /// Cor de fundo (hexadecimal)
  /// Exemplo: "#ffffff" (branco)
  final String backgroundColor;

  /// Cor do texto (hexadecimal)
  /// Exemplo: "#000000" (preto)
  final String textColor;

  /// Caminho do logo (dentro de assets/)
  /// Exemplo: "assets/images/lopes/logo.png"
  final String logoPath;

  /// Caminho do splash screen (dentro de assets/)
  /// Exemplo: "assets/images/lopes/splash.png"
  final String splashPath;

  /// Caminho do ícone do app (para launcher)
  /// Exemplo: "assets/icons/lopes/app_icon.png"
  final String appIconPath;

  /// Nome de exibição curto (para notificações)
  /// Exemplo: "Lopes"
  final String shortName;

  /// Descrição do app (para stores)
  final String description;

  /// Configurações opcionais
  final Map<String, dynamic>? extras;

  /// Helper para recuperar valores extras com segurança
  T? getExtra<T>(String key) {
    final value = extras?[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  const AppConfig({
    required this.appName,
    required this.appId,
    required this.tenantSlug,
    required this.primaryColor,
    required this.secondaryColor,
    this.backgroundColor = '#FFFFFF',
    this.textColor = '#000000',
    required this.logoPath,
    required this.splashPath,
    required this.appIconPath,
    required this.shortName,
    required this.description,
    this.extras,
  });

  /// Converte cor hex para Color
  int getColorValue(String hexColor) {
    return int.parse(hexColor.replaceAll('#', '0xFF'));
  }

  /// Retorna informações de debug
  Map<String, String> toDebugInfo() {
    return {
      'appName': appName,
      'appId': appId,
      'tenantSlug': tenantSlug,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'logoPath': logoPath,
    };
  }

  @override
  String toString() {
    return 'AppConfig(appName: $appName, appId: $appId, tenantSlug: $tenantSlug)';
  }
}
