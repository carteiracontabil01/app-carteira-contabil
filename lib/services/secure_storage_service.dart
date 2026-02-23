import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Serviço de armazenamento seguro de credenciais
/// Usa criptografia nativa do Android/iOS para proteger dados sensíveis
class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Chaves de armazenamento
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyUserEmail = 'biometric_user_email';
  static const String _keyUserPassword = 'biometric_user_password';

  /// Verifica se a biometria está habilitada
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _storage.read(key: _keyBiometricEnabled);
      return value == 'true';
    } catch (e) {
      print('❌ Erro ao verificar biometria habilitada: $e');
      return false;
    }
  }

  /// Habilita ou desabilita a biometria
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      if (enabled) {
        await _storage.write(key: _keyBiometricEnabled, value: 'true');
      } else {
        await _storage.delete(key: _keyBiometricEnabled);
        // Limpar credenciais salvas quando desabilitar
        await clearCredentials();
      }
    } catch (e) {
      print('❌ Erro ao configurar biometria: $e');
    }
  }

  /// Salva as credenciais do usuário de forma segura
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _storage.write(key: _keyUserEmail, value: email);
      await _storage.write(key: _keyUserPassword, value: password);
      print('✅ Credenciais salvas com segurança');
    } catch (e) {
      print('❌ Erro ao salvar credenciais: $e');
      rethrow;
    }
  }

  /// Recupera o email salvo
  Future<String?> getSavedEmail() async {
    try {
      return await _storage.read(key: _keyUserEmail);
    } catch (e) {
      print('❌ Erro ao recuperar email: $e');
      return null;
    }
  }

  /// Recupera a senha salva
  Future<String?> getSavedPassword() async {
    try {
      return await _storage.read(key: _keyUserPassword);
    } catch (e) {
      print('❌ Erro ao recuperar senha: $e');
      return null;
    }
  }

  /// Recupera ambas as credenciais
  Future<Map<String, String>?> getCredentials() async {
    try {
      final email = await getSavedEmail();
      final password = await getSavedPassword();

      if (email != null && password != null) {
        return {
          'email': email,
          'password': password,
        };
      }

      return null;
    } catch (e) {
      print('❌ Erro ao recuperar credenciais: $e');
      return null;
    }
  }

  /// Verifica se há credenciais salvas
  Future<bool> hasCredentials() async {
    try {
      final email = await getSavedEmail();
      return email != null;
    } catch (e) {
      print('❌ Erro ao verificar credenciais: $e');
      return false;
    }
  }

  /// Limpa todas as credenciais salvas
  Future<void> clearCredentials() async {
    try {
      await _storage.delete(key: _keyUserEmail);
      await _storage.delete(key: _keyUserPassword);
      print('✅ Credenciais limpas');
    } catch (e) {
      print('❌ Erro ao limpar credenciais: $e');
    }
  }

  /// Limpa tudo (usado no logout)
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      print('✅ Storage limpo completamente');
    } catch (e) {
      print('❌ Erro ao limpar storage: $e');
    }
  }

  /// Migração de credenciais (se necessário)
  /// Útil para atualizar chaves de criptografia
  Future<void> migrateCredentials() async {
    try {
      final credentials = await getCredentials();
      if (credentials != null) {
        await saveCredentials(
          email: credentials['email']!,
          password: credentials['password']!,
        );
        print('✅ Credenciais migradas');
      }
    } catch (e) {
      print('❌ Erro ao migrar credenciais: $e');
    }
  }
}
