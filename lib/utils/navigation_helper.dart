import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_flow/flutter_flow_theme.dart';

enum NavigationApp { googleMaps, waze, browser }

class NavigationHelper {
  static Future<void> showNavigationOptions({
    required BuildContext context,
    required double latitude,
    required double longitude,
    String? destinationName,
  }) async {
    try {
      final options = await _buildNavigationOptions(latitude, longitude);

      if (options.isEmpty) {
        final result = await openNavigation(
          latitude: latitude,
          longitude: longitude,
          destinationName: destinationName,
          preferredApp: NavigationApp.browser,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              backgroundColor: FlutterFlowTheme.of(context).success,
            ),
          );
        }
        return;
      }

      if (!context.mounted) return;

      await showModalBottomSheet<void>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Text(
                  'Escolha o app de navegação',
                  style: FlutterFlowTheme.of(context).titleMedium,
                ),
              ),
              ...options.map(
                (option) => ListTile(
                  leading: Icon(option.icon, color: option.color),
                  title: Text(option.label),
                  onTap: () async {
                    Navigator.of(context).pop();
                    try {
                      final message = await openNavigation(
                        latitude: latitude,
                        longitude: longitude,
                        destinationName: destinationName,
                        preferredApp: option.app,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor:
                                FlutterFlowTheme.of(context).success,
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Não foi possível abrir ${option.label}: $error',
                            ),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir navegação: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  static Future<String> openNavigation({
    required double latitude,
    required double longitude,
    String? destinationName,
    NavigationApp? preferredApp,
  }) async {
    debugPrint('🗺️ Navegação: latitude=$latitude, longitude=$longitude');
    if (!latitude.isFinite ||
        !longitude.isFinite ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      throw ArgumentError(
        'Coordenadas inválidas: ($latitude, $longitude)',
      );
    }

    final coordinates = '$latitude,$longitude';
    final encodedName =
        destinationName != null ? Uri.encodeComponent(destinationName) : null;

    final orderedApps = <NavigationApp>[];
    if (preferredApp != null && preferredApp != NavigationApp.browser) {
      orderedApps.add(preferredApp);
    }
    for (final app in NavigationApp.values) {
      if (app == NavigationApp.browser) {
        continue;
      }
      if (!orderedApps.contains(app)) {
        orderedApps.add(app);
      }
    }

    final attempts = <_NavigationAttempt>[];
    for (final app in orderedApps) {
      attempts.addAll(
        _buildAttemptsForApp(
          app: app,
          latitude: latitude,
          longitude: longitude,
          coordinates: coordinates,
          encodedName: encodedName,
        ),
      );
    }

    for (final attempt in attempts) {
      final launched = await _tryLaunchUri(attempt.uri);
      if (launched) {
        debugPrint('✅ Navegação: ${attempt.appName} (${attempt.type})');
        return attempt.successMessage;
      } else {
        debugPrint('⚠️ Falhou: ${attempt.appName} (${attempt.uri})');
      }
    }

    final fallbackMessage = await _launchWebFallbacks(
      latitude: latitude,
      longitude: longitude,
      destinationName: destinationName,
    );

    if (fallbackMessage != null) {
      return fallbackMessage;
    }

    throw Exception('Nenhuma opção de navegação funcionou.');
  }

  static Future<List<_NavigationOption>> _buildNavigationOptions(
    double latitude,
    double longitude,
  ) async {
    if (kIsWeb) {
      return [
        _NavigationOption(
          label: 'Abrir no navegador',
          icon: Icons.public_rounded,
          color: const Color(0xFF2563EB),
          app: NavigationApp.browser,
        ),
      ];
    }

    final options = <_NavigationOption>[];
    final googleUri = _getGoogleMapsAvailabilityUri(latitude, longitude);
    if (googleUri != null && await canLaunchUrl(googleUri)) {
      options.add(
        const _NavigationOption(
          label: 'Google Maps',
          icon: Icons.navigation_rounded,
          color: Color(0xFF34A853),
          app: NavigationApp.googleMaps,
        ),
      );
    }

    final wazeUri = _getWazeAvailabilityUri(latitude, longitude);
    if (wazeUri != null && await canLaunchUrl(wazeUri)) {
      options.add(
        const _NavigationOption(
          label: 'Waze',
          icon: Icons.directions_car_filled_rounded,
          color: Color(0xFF1C8FD0),
          app: NavigationApp.waze,
        ),
      );
    }

    if (options.isEmpty) {
      options.add(
        const _NavigationOption(
          label: 'Abrir no navegador',
          icon: Icons.public_rounded,
          color: Color(0xFF2563EB),
          app: NavigationApp.browser,
        ),
      );
    }

    return options;
  }

  static List<_NavigationAttempt> _buildAttemptsForApp({
    required NavigationApp app,
    required double latitude,
    required double longitude,
    required String coordinates,
    required String? encodedName,
  }) {
    final isAndroid = !kIsWeb && Platform.isAndroid;
    final isIOS = !kIsWeb && Platform.isIOS;

    switch (app) {
      case NavigationApp.googleMaps:
        final attempts = <_NavigationAttempt>[];
        if (isIOS) {
          attempts.addAll([
            _NavigationAttempt(
              appName: 'Google Maps',
              type: 'comgooglemaps',
              uri: Uri.parse(
                'comgooglemaps://?daddr=$coordinates&directionsmode=driving',
              ),
              successMessage: 'Google Maps aberto com navegação ($coordinates)',
            ),
            _NavigationAttempt(
              appName: 'Apple Maps',
              type: 'maps://',
              uri: Uri.parse(
                'maps://maps.google.com/?daddr=$coordinates&directionsmode=driving',
              ),
              successMessage: 'Apple Maps aberto com navegação ($coordinates)',
            ),
          ]);
        } else if (isAndroid) {
          attempts.addAll([
            _NavigationAttempt(
              appName: 'Google Maps',
              type: 'google.navigation',
              uri: Uri.parse('google.navigation:q=$coordinates'),
              successMessage: 'Google Maps aberto com navegação ($coordinates)',
            ),
            _NavigationAttempt(
              appName: 'Google Maps',
              type: 'intent',
              uri: Uri.parse(
                'intent://navigate/?q=$coordinates#Intent;scheme=google.navigation;package=com.google.android.apps.maps;end',
              ),
              successMessage: 'Google Maps aberto com navegação ($coordinates)',
            ),
          ]);
        }
        attempts.add(
          _NavigationAttempt(
            appName: 'Google Maps',
            type: 'https',
            uri: Uri.parse(
              'https://www.google.com/maps/dir/?api=1&destination=$coordinates&travelmode=driving',
            ),
            successMessage:
                'Google Maps (web) aberto com navegação ($coordinates)',
          ),
        );
        return attempts;
      case NavigationApp.waze:
        final attempts = <_NavigationAttempt>[];
        if (encodedName != null && encodedName.isNotEmpty) {
          attempts.addAll([
            _NavigationAttempt(
              appName: 'Waze',
              type: 'waze:// nome',
              uri: Uri.parse('waze://ul?q=$encodedName&navigate=yes'),
              successMessage: 'Waze aberto para $encodedName ($coordinates)',
            ),
            _NavigationAttempt(
              appName: 'Waze',
              type: 'https nome',
              uri: Uri.parse(
                'https://waze.com/ul?ll=$coordinates&navigate=yes&q=$encodedName',
              ),
              successMessage:
                  'Waze (web) aberto para $encodedName ($coordinates)',
            ),
          ]);
        }
        attempts.addAll([
          _NavigationAttempt(
            appName: 'Waze',
            type: 'waze:// coords',
            uri: Uri.parse('waze://ul?ll=$coordinates&navigate=yes'),
            successMessage: 'Waze aberto com navegação ($coordinates)',
          ),
          _NavigationAttempt(
            appName: 'Waze',
            type: 'https coords',
            uri: Uri.parse(
              'https://waze.com/ul?ll=$coordinates&navigate=yes',
            ),
            successMessage: 'Waze (web) aberto com navegação ($coordinates)',
          ),
        ]);
        return attempts;
      case NavigationApp.browser:
        return [
          _NavigationAttempt(
            appName: 'Google Maps (web)',
            type: 'https',
            uri: Uri.parse(
              'https://www.google.com/maps/dir/?api=1&destination=$coordinates&travelmode=driving',
            ),
            successMessage:
                'Google Maps Web aberto com navegação ($coordinates)',
          ),
        ];
    }
  }

  static Future<String?> _launchWebFallbacks({
    required double latitude,
    required double longitude,
    String? destinationName,
  }) async {
    final coordinates = '$latitude,$longitude';
    final encodedName =
        destinationName != null ? Uri.encodeComponent(destinationName) : null;

    final attempts = <_NavigationAttempt>[
      _NavigationAttempt(
        appName: 'Google Maps (web)',
        type: 'https',
        uri: Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$coordinates&travelmode=driving',
        ),
        successMessage: 'Google Maps Web aberto com navegação ($coordinates)',
      ),
      _NavigationAttempt(
        appName: 'Waze (web)',
        type: 'https',
        uri: Uri.parse(
          encodedName != null && encodedName.isNotEmpty
              ? 'https://waze.com/ul?ll=$coordinates&navigate=yes&q=$encodedName'
              : 'https://waze.com/ul?ll=$coordinates&navigate=yes',
        ),
        successMessage: 'Waze Web aberto com navegação ($coordinates)',
      ),
    ];

    for (final attempt in attempts) {
      final launched = await _tryLaunchUri(attempt.uri);
      if (launched) {
        return attempt.successMessage;
      }
    }

    return null;
  }

  static Future<bool> _tryLaunchUri(Uri uri) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return launched;
    } catch (error) {
      debugPrint('❌ Erro ao abrir $uri -> $error');
      return false;
    }
  }

  static Uri? _getGoogleMapsAvailabilityUri(
    double latitude,
    double longitude,
  ) {
    if (kIsWeb) {
      return null;
    }
    if (Platform.isIOS) {
      return Uri.parse(
        'comgooglemaps://?daddr=$latitude,$longitude&directionsmode=driving',
      );
    }
    if (Platform.isAndroid) {
      return Uri.parse('google.navigation:q=$latitude,$longitude');
    }
    return null;
  }

  static Uri? _getWazeAvailabilityUri(double latitude, double longitude) {
    if (kIsWeb) {
      return null;
    }
    return Uri.parse('waze://ul?ll=$latitude,$longitude&navigate=yes');
  }
}

class _NavigationOption {
  const _NavigationOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.app,
  });

  final String label;
  final IconData icon;
  final Color color;
  final NavigationApp app;
}

class _NavigationAttempt {
  const _NavigationAttempt({
    required this.appName,
    required this.type,
    required this.uri,
    required this.successMessage,
  });

  final String appName;
  final String type;
  final Uri uri;
  final String successMessage;
}
