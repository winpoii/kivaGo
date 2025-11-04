import 'dart:io';
import 'package:flutter/foundation.dart';

/// App configuration for API endpoints and keys
///
/// NOTE: This file contains PUBLIC configuration values only.
/// For MVP phase, these values are hardcoded for simplicity.
///
/// TODO (Production): Migrate to .env file when:
///   - Moving to production
///   - Adding private backend API keys
///   - Setting up multiple environments (dev/staging/prod)
class AppConfig {
  // n8n Webhook Configuration - Base URL
  // For Android emulator, use: http://10.0.2.2:5678/...
  // For real device on same WiFi, use your computer's local IP: http://192.168.x.x:5678/...
  static const String n8nWebhookBaseUrl =
      'http://localhost:5678/webhook-test/c04a7380-96d8-460d-ba28-d1def5276ecd';
  // Manual override: Set this to your computer's IP if needed
  // Production webhook URL (ngrok tunnel to localhost:5678)
  //Bu kısımda ngrok paketini kurup ngrokun oluşturduğu köprü linki yazıyoruz.
  static const String manualWebhookUrl =
      'https://fermentative-barbera-insensitively.ngrok-free.dev/webhook-test/c04a7380-96d8-460d-ba28-d1def5276ecd';

  // Development vs Production
  static const bool isDevelopment = true;

  // API Timeouts
  static const int apiTimeoutSeconds = 30;

  // Get the appropriate webhook URL based on platform
  // Android emulator uses 10.0.2.2 instead of localhost
  static String get webhookUrl {
    // If manual URL is set, use it (highest priority)
    if (manualWebhookUrl.isNotEmpty) {
      print('🔧 Using manual webhook URL: $manualWebhookUrl');
      return manualWebhookUrl;
    }

    String url = n8nWebhookBaseUrl;

    try {
      // Debug: Check platform
      print('🔍 Platform check:');
      print('   - isAndroid: ${Platform.isAndroid}');
      print('   - isIOS: ${Platform.isIOS}');
      print('   - isWindows: ${Platform.isWindows}');
      print('   - isWeb: $kIsWeb');

      // Check if running on Android emulator
      if (Platform.isAndroid && !kIsWeb) {
        // Replace localhost with 10.0.2.2 for Android emulator
        url = url.replaceAll('http://localhost:', 'http://10.0.2.2:');
        print('📱 Android detected - Changed localhost to 10.0.2.2');
      } else if (Platform.isIOS && !kIsWeb) {
        // iOS Simulator uses localhost, but real device needs computer's IP
        print('📱 iOS detected - Using localhost (for simulator)');
      } else {
        print('💻 Desktop/Web - Using localhost');
      }
    } catch (e) {
      print('⚠️ Platform detection error: $e');
      print('   Defaulting to: $url');
    }

    print('🌐 Final webhook URL: $url');
    return url;
  }

  // Headers for n8n webhook requests
  static Map<String, String> get webhookHeaders => {
        'Content-Type': 'application/json',
      };
}
