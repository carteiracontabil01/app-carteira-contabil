import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de configurações do usuário
/// Salva no Supabase para sincronização entre dispositivos
/// Usa cache local (SharedPreferences) para performance
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // Chaves de cache local
  static const String _keyCacheTimestamp = 'settings_cache_timestamp';

  /// Carrega configurações do banco (com cache)
  Future<UserSettingsRow> loadSettings(String userId, String? tenantId) async {
    try {
      // Buscar do banco
      final settings = await UserSettingsTable().queryRows(
        queryFn: (q) => q.eq('user_id', userId).eq('tenant_id', tenantId ?? ''),
      );

      if (settings.isEmpty) {
        // Criar configurações padrão
        return await _createDefaultSettings(userId, tenantId);
      }

      // Atualizar cache local
      await _updateLocalCache(settings.first);

      return settings.first;
    } catch (e) {
      print('❌ Erro ao carregar configurações: $e');
      // Fallback: tentar carregar do cache local
      return await _loadFromLocalCache();
    }
  }

  /// Cria configurações padrão para um usuário
  Future<UserSettingsRow> _createDefaultSettings(
      String userId, String? tenantId) async {
    try {
      final newSettings = await UserSettingsTable().insert({
        'user_id': userId,
        'tenant_id': tenantId,
        'notifications_orders': true,
        'notifications_promotions': true,
        'notifications_offers': false,
        'dark_mode': false,
        'app_sounds': true,
        'vibration': true,
      });

      print('✅ Configurações padrão criadas para usuário');

      // O insert retorna um único objeto (T), não uma lista
      return newSettings;
    } catch (e) {
      print('❌ Erro ao criar configurações padrão: $e');
      rethrow;
    }
  }

  /// Atualiza uma configuração específica
  Future<void> updateSetting(String field, bool value) async {
    try {
      final userId = currentUserUid;
      final tenantId = FFAppState().tenantId;

      await UserSettingsTable().update(
        data: {field: value},
        matchingRows: (rows) =>
            rows.eq('user_id', userId).eq('tenant_id', tenantId ?? ''),
      );

      print('✅ Configuração atualizada: $field = $value');
    } catch (e) {
      print('❌ Erro ao atualizar configuração: $e');
    }
  }

  // ========== NOTIFICAÇÕES ==========

  Future<void> setNotificacoesPedidos(bool value) async {
    await updateSetting('notifications_orders', value);
  }

  Future<void> setNotificacoesPromocoes(bool value) async {
    await updateSetting('notifications_promotions', value);
  }

  Future<void> setNotificacoesOfertas(bool value) async {
    await updateSetting('notifications_offers', value);
  }

  // ========== APARÊNCIA ==========

  Future<void> setModoEscuro(bool value) async {
    await updateSetting('dark_mode', value);
  }

  // ========== SOM E VIBRAÇÃO ==========

  Future<void> setSons(bool value) async {
    await updateSetting('app_sounds', value);
  }

  Future<void> setVibracao(bool value) async {
    await updateSetting('vibration', value);
  }

  // ========== CACHE LOCAL (PARA PERFORMANCE) ==========

  /// Atualiza cache local
  Future<void> _updateLocalCache(UserSettingsRow settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_orders', settings.notificationsOrders);
      await prefs.setBool(
          'notifications_promotions', settings.notificationsPromotions);
      await prefs.setBool('notifications_offers', settings.notificationsOffers);
      await prefs.setBool('dark_mode', settings.darkMode);
      await prefs.setBool('app_sounds', settings.appSounds);
      await prefs.setBool('vibration', settings.vibration);
      await prefs.setInt(
          _keyCacheTimestamp, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('❌ Erro ao atualizar cache: $e');
    }
  }

  /// Carrega do cache local (fallback)
  Future<UserSettingsRow> _loadFromLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Criar row fake com dados do cache
      return UserSettingsRow({
        'id': '',
        'user_id': currentUserUid,
        'tenant_id': FFAppState().tenantId,
        'notifications_orders': prefs.getBool('notifications_orders') ?? true,
        'notifications_promotions':
            prefs.getBool('notifications_promotions') ?? true,
        'notifications_offers': prefs.getBool('notifications_offers') ?? false,
        'dark_mode': prefs.getBool('dark_mode') ?? false,
        'app_sounds': prefs.getBool('app_sounds') ?? true,
        'vibration': prefs.getBool('vibration') ?? true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Erro ao carregar do cache: $e');
      // Retornar valores padrão
      return UserSettingsRow({
        'id': '',
        'user_id': currentUserUid,
        'tenant_id': FFAppState().tenantId,
        'notifications_orders': true,
        'notifications_promotions': true,
        'notifications_offers': false,
        'dark_mode': false,
        'app_sounds': true,
        'vibration': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Limpa cache local
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('notifications_orders');
      await prefs.remove('notifications_promotions');
      await prefs.remove('notifications_offers');
      await prefs.remove('dark_mode');
      await prefs.remove('app_sounds');
      await prefs.remove('vibration');
      await prefs.remove(_keyCacheTimestamp);
      print('✅ Cache de configurações limpo');
    } catch (e) {
      print('❌ Erro ao limpar cache: $e');
    }
  }
}
