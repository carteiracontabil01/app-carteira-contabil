import '../config/app_config.dart';

/// Configuração Demo - App Driver
///
/// Aplicativo para entregadores/drivers.
const AppConfig demoConfig = AppConfig(
  // Informações básicas
  appName: 'Carteira Contábil',
  shortName: 'Carteira',
  appId: 'com.carteiracontabil.app',

  // Tenant no Supabase (já existe!)
  tenantSlug: 'default', // Estabelecimento Padrão

  // Cores do app (hexadecimal)
  primaryColor: '#15203D', // Azul Escuro padrão
  secondaryColor: '#D5D91B', // Amarelo padrão
  backgroundColor: '#FFFFFF', // Branco
  textColor: '#000000', // Preto

  // Assets (criar estes arquivos!)
  logoPath: 'assets/images/ic_carteira_contabil_colorida.png',
  splashPath: 'assets/images/splash.png',
  appIconPath: 'assets/images/icone.jpg',

  // Descrição para as stores
  description: 'App de gestão contábil. '
      'Gerencie suas finanças, acompanhe seus lançamentos e organize sua contabilidade de forma prática e eficiente!',

  // Configurações extras (opcional)
  extras: {
    'support_email': 'suporte@carteiracontabil.com.br',
    'support_phone': '(11) 99999-9999',
    'website': 'https://carteiracontabil.com.br',
  },
);
