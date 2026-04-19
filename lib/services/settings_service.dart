import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    required this.notificationsOrders,
    required this.darkMode,
    required this.appSounds,
    required this.vibration,
  });

  final bool notificationsOrders;
  final bool darkMode;
  final bool appSounds;
  final bool vibration;
}

/// Serviço de configurações com persistência local.
/// Não realiza chamadas remotas e evita requisições desnecessárias no app.
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _keyNotificationsOrders = 'settings_notifications_orders';
  static const String _keyDarkMode = 'settings_dark_mode';
  static const String _keyAppSounds = 'settings_app_sounds';
  static const String _keyVibration = 'settings_vibration';

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      notificationsOrders: prefs.getBool(_keyNotificationsOrders) ?? true,
      darkMode: prefs.getBool(_keyDarkMode) ?? false,
      appSounds: prefs.getBool(_keyAppSounds) ?? true,
      vibration: prefs.getBool(_keyVibration) ?? true,
    );
  }

  Future<void> setNotificacoesPedidos(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsOrders, value);
  }

  Future<void> setModoEscuro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  Future<void> setSons(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAppSounds, value);
  }

  Future<void> setVibracao(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVibration, value);
  }
}
