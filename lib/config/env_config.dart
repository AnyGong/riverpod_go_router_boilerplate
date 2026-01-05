/// Environment configuration for the app.
/// Configure different settings for dev, staging, and production.
enum Environment { dev, staging, prod }

/// Runtime environment configuration.
/// Initialize this at app startup before any other code runs.
class EnvConfig {
  EnvConfig._();

  static late final Environment _environment;
  static late final String _baseUrl;
  static late final bool _enableLogging;

  /// Initialize the environment configuration.
  /// Call this in main() before runApp().
  static void initialize({required Environment environment}) {
    _environment = environment;
    _baseUrl = _getBaseUrl(environment);
    _enableLogging = environment != Environment.prod;
  }

  static String _getBaseUrl(Environment env) {
    return switch (env) {
      Environment.dev => 'https://dev-api.example.com',
      Environment.staging => 'https://staging-api.example.com',
      Environment.prod => 'https://api.example.com',
    };
  }

  /// Current environment.
  static Environment get environment => _environment;

  /// Whether the app is running in development mode.
  static bool get isDev => _environment == Environment.dev;

  /// Whether the app is running in staging mode.
  static bool get isStaging => _environment == Environment.staging;

  /// Whether the app is running in production mode.
  static bool get isProd => _environment == Environment.prod;

  /// Base URL for API calls.
  static String get baseUrl => _baseUrl;

  /// Whether logging is enabled.
  static bool get enableLogging => _enableLogging;
}
