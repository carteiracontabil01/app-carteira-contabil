import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:flutter/services.dart';

/// Serviço de autenticação biométrica
/// Suporta: Touch ID, Face ID, Impressão Digital
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Verifica se o dispositivo tem biometria disponível
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      return isAvailable && isDeviceSupported;
    } catch (e) {
      print('❌ Erro ao verificar biometria: $e');
      return false;
    }
  }

  /// Retorna os tipos de biometria disponíveis
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('❌ Erro ao obter tipos de biometria: $e');
      return [];
    }
  }

  /// Autentica o usuário usando biometria
  /// Retorna true se autenticado com sucesso
  Future<bool> authenticate({
    String reason = 'Verifique sua identidade para continuar',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();

      if (!isAvailable) {
        print('⚠️ Biometria não disponível neste dispositivo');
        return false;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Autenticação Biométrica',
            cancelButton: 'Cancelar',
            biometricHint: 'Use sua impressão digital para autenticar',
            biometricNotRecognized: 'Impressão digital não reconhecida',
            biometricSuccess: 'Autenticação bem-sucedida',
            deviceCredentialsRequiredTitle: 'Autenticação necessária',
            deviceCredentialsSetupDescription: 'Configure sua biometria',
            goToSettingsButton: 'Configurações',
            goToSettingsDescription: 'Configure a biometria no seu dispositivo',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancelar',
            goToSettingsButton: 'Configurações',
            goToSettingsDescription: 'Configure a biometria no seu dispositivo',
            lockOut: 'Biometria bloqueada. Tente novamente mais tarde.',
            localizedFallbackTitle: 'Usar senha',
          ),
        ],
      );

      if (authenticated) {
        print('✅ Autenticação biométrica bem-sucedida');
      } else {
        print('❌ Autenticação biométrica falhou ou foi cancelada');
      }

      return authenticated;
    } on PlatformException catch (e) {
      print('❌ Erro de plataforma na biometria: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('❌ Erro inesperado na biometria: $e');
      return false;
    }
  }

  /// Verifica se o usuário tem biometria cadastrada no dispositivo
  Future<bool> hasBiometricsEnrolled() async {
    try {
      final biometrics = await getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar biometria cadastrada: $e');
      return false;
    }
  }

  /// Retorna descrição amigável do tipo de biometria
  Future<String> getBiometricTypeDescription() async {
    try {
      final biometrics = await getAvailableBiometrics();

      if (biometrics.isEmpty) {
        return 'Biometria';
      }

      if (biometrics.contains(BiometricType.face)) {
        return 'Face ID';
      }

      if (biometrics.contains(BiometricType.fingerprint)) {
        return 'Impressão Digital';
      }

      if (biometrics.contains(BiometricType.iris)) {
        return 'Íris';
      }

      return 'Biometria';
    } catch (e) {
      return 'Biometria';
    }
  }
}
