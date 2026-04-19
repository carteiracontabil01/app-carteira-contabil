import 'app_config.dart';

// Importar environments disponíveis
import '../environments/env_demo.dart';
// import '../environments/env_lopes.dart';
// import '../environments/env_mercado.dart';
// Adicione novos environments aqui conforme criar

/// Environment atual do app
///
/// Este valor é definido no build time via --dart-define=ENV=<nome>
///
/// Exemplos:
/// - flutter run --dart-define=ENV=demo
/// - flutter build apk --dart-define=ENV=lopes
/// - flutter build ios --dart-define=ENV=mercado
const String ENVIRONMENT = String.fromEnvironment(
  'ENV',
  defaultValue: 'demo', // Ambiente padrão para desenvolvimento
);

/// Retorna a configuração do app baseada no environment
AppConfig getAppConfig() {
  switch (ENVIRONMENT) {
    case 'demo':
      return demoConfig;

    // case 'lopes':
    //   return lopesConfig;

    // case 'mercado':
    //   return mercadoConfig;

    // Adicione novos cases aqui conforme criar novos environments

    default:
      return demoConfig;
  }
}

/// Singleton global para acessar a configuração do app
///
/// Use em qualquer lugar do código:
/// ```dart
/// import 'package:carteira_contabil/config/environment.dart';
///
/// // Acessar nome do app
/// print(appConfig.appName);
///
/// // Acessar tenant slug
/// print(appConfig.tenantSlug);
///
/// // Acessar cores
/// print(appConfig.primaryColor);
/// ```
final AppConfig appConfig = getAppConfig();
