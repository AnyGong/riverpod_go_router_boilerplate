/// Environment configuration for the app.
/// Configure different settings for dev, staging, and production.
///
/// Supports both runtime switching and compile-time configuration via `--dart-define`.
///
/// ## Compile-time Configuration (Recommended for Production)
///
/// Use `--dart-define` to set values at compile time, keeping secrets out of source:
/// ```bash
/// flutter build apk \
///   --dart-define=ENV=prod \
///   --dart-define=BASE_URL=https://api.myapp.com \
///   --dart-define=API_KEY=your_secret_key
/// ```
///
/// Or in your launch.json / VS Code configuration:
/// ```json
/// {
///   "args": [
///     "--dart-define=ENV=prod",
///     "--dart-define=BASE_URL=https://api.myapp.com"
///   ]
/// }
/// ```
///
/// ## Runtime Configuration (For Development)
///
/// Call [initialize] in main() for development/testing:
/// ```dart
/// EnvConfig.initialize(environment: Environment.dev);
/// ```
enum Environment { dev, staging, prod }

/// Runtime environment configuration.
///
/// Supports compile-time variables via `--dart-define` for secure production builds,
/// with fallback to runtime configuration for development flexibility.
///
/// **Priority:** Compile-time values (`--dart-define`) take precedence over runtime values.
class EnvConfig {
  EnvConfig._();

  // Compile-time constants from --dart-define
  static const String _dartDefineEnv = String.fromEnvironment('ENV');
  static const String _dartDefineBaseUrl = String.fromEnvironment('BASE_URL');
  static const String _dartDefineApiKey = String.fromEnvironment('API_KEY');
  static const bool _dartDefineEnableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
  static const bool _dartDefineUseMocks = bool.fromEnvironment(
    'USE_MOCKS',
    defaultValue: true,
  );

  static late final Environment _environment;
  static late final String _baseUrl;
  static late final String _apiKey;
  static late final bool _enableLogging;
  static late final bool _useMockRepositories;

  /// Whether the config has been initialized.
  static bool _isInitialized = false;

  /// Initialize the environment configuration.
  ///
  /// Call this in main() before runApp().
  /// Compile-time values from `--dart-define` take precedence.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   EnvConfig.initialize(environment: Environment.dev);
  ///   runApp(MyApp());
  /// }
  /// ```
  static void initialize({required final Environment environment}) {
    if (_isInitialized) return;

    // Use compile-time environment if provided, otherwise use runtime parameter
    _environment = _dartDefineEnv.isNotEmpty ? _parseEnvironment(_dartDefineEnv) : environment;

    // Use compile-time base URL if provided, otherwise derive from environment
    _baseUrl = _dartDefineBaseUrl.isNotEmpty ? _dartDefineBaseUrl : _getBaseUrl(_environment);

    // API key from compile-time (empty string if not provided)
    _apiKey = _dartDefineApiKey;

    // Logging: compile-time value, or enabled for non-prod
    _enableLogging = _dartDefineEnv.isNotEmpty
        ? _dartDefineEnableLogging
        : _environment != Environment.prod;

    // Mock repositories: compile-time value, or use for non-prod
    _useMockRepositories = _dartDefineEnv.isNotEmpty
        ? _dartDefineUseMocks
        : _environment != Environment.prod;

    _isInitialized = true;
  }

  static Environment _parseEnvironment(final String env) {
    return switch (env.toLowerCase()) {
      'prod' || 'production' => Environment.prod,
      'staging' || 'stage' => Environment.staging,
      _ => Environment.dev,
    };
  }

  static String _getBaseUrl(final Environment env) {
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

  /// API key for authenticated requests.
  /// Will be empty string if not configured via --dart-define.
  static String get apiKey => _apiKey;

  /// Whether logging is enabled.
  static bool get enableLogging => _enableLogging;

  /// Whether to use mock repositories instead of remote ones.
  /// Returns true for dev and staging, false for production.
  static bool get useMockRepositories => _useMockRepositories;
}
