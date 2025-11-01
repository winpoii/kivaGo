/// App configuration for API endpoints and keys
class AppConfig {
  // n8n Webhook Configuration
  static const String n8nWebhookUrl =
      'https://fermentative-barbera-insensitively.ngrok-free.dev/webhook-test/bca1bf6e-5b90-44b3-9f6e-38df9b17caf6';

  // Development vs Production
  static const bool isDevelopment = true;

  // API Timeouts
  static const int apiTimeoutSeconds = 30;

  // Get the appropriate webhook URL based on environment
  static String get webhookUrl {
    return n8nWebhookUrl; // Use the configured webhook URL directly
  }

  // Headers for n8n webhook requests
  static Map<String, String> get webhookHeaders => {
        'Content-Type': 'application/json',
      };
}
