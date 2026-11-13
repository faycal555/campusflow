import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Adresse de l'API json-server.
///
/// Sur l'émulateur Android, la machine hôte s'appelle 10.0.2.2 (localhost
/// désigne l'émulateur lui-même). Pour un vrai téléphone, passer l'adresse IP
/// du PC : `flutter run --dart-define=API_URL=http://192.168.1.20:3000`.
String get apiBaseUrl {
  const fromEnv = String.fromEnvironment('API_URL');
  if (fromEnv.isNotEmpty) return fromEnv;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000';
  }
  return 'http://localhost:3000';
}

Dio buildDio({String? baseUrl}) => Dio(
  BaseOptions(
    baseUrl: baseUrl ?? apiBaseUrl,
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
    contentType: Headers.jsonContentType,
  ),
);

/// Client HTTP unique de l'application. Seuls les repositories l'utilisent.
final dioProvider = Provider<Dio>((ref) => buildDio());
