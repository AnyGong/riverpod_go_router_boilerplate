/// Application-wide constants.
abstract class AppConstants {
  // ─────────────────────────────────────────────────────────────────────────────
  // ANIMATION DURATIONS
  // ─────────────────────────────────────────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK TIMEOUTS
  // ─────────────────────────────────────────────────────────────────────────────
  /// Connection timeout for HTTP requests.
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Receive timeout for HTTP requests.
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Send timeout for HTTP requests.
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Maximum number of retry attempts for failed requests.
  static const int maxRetryAttempts = 3;

  /// Delays between retry attempts (exponential backoff).
  static const List<Duration> retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
  ];

  // ─────────────────────────────────────────────────────────────────────────────
  // CACHE TIMEOUTS
  // ─────────────────────────────────────────────────────────────────────────────
  /// Default cache expiry duration.
  static const Duration cacheExpiry = Duration(hours: 24);

  /// Cache expiry for short-lived data (e.g., search results).
  static const Duration cacheExpiryShort = Duration(minutes: 5);

  /// Cache expiry for long-lived data (e.g., static content).
  static const Duration cacheExpiryLong = Duration(days: 7);

  // ─────────────────────────────────────────────────────────────────────────────
  // UI TIMEOUTS & DELAYS
  // ─────────────────────────────────────────────────────────────────────────────
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration throttleDelay = Duration(milliseconds: 300);

  // ─────────────────────────────────────────────────────────────────────────────
  // PAGINATION
  // ─────────────────────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS
  // ─────────────────────────────────────────────────────────────────────────────
  static const double borderRadiusSmall = 4;
  static const double borderRadiusMedium = 8;
  static const double borderRadiusLarge = 16;
  static const double borderRadiusXLarge = 24;

  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;

  static const double buttonHeight = 48;
  static const double inputHeight = 56;
  static const double appBarHeight = 56;

  static const double maxContentWidth = 600;
  static const double maxTabletWidth = 900;

  // ─────────────────────────────────────────────────────────────────────────────
  // PADDING & MARGIN
  // ─────────────────────────────────────────────────────────────────────────────
  static const double paddingXS = 4;
  static const double paddingSM = 8;
  static const double paddingMD = 16;
  static const double paddingLG = 24;
  static const double paddingXL = 32;
  static const double paddingXXL = 48;

  // ─────────────────────────────────────────────────────────────────────────────
  // VALIDATION
  // ─────────────────────────────────────────────────────────────────────────────
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 500;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // ─────────────────────────────────────────────────────────────────────────────
  // REGEX PATTERNS
  // ─────────────────────────────────────────────────────────────────────────────
  static final RegExp emailPattern = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  static final RegExp phonePattern = RegExp(r'^\+?[\d\s-]{10,}$');
  static final RegExp urlPattern = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );
}

/// API endpoint paths.
abstract class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User
  static const String currentUser = '/users/me';
  static const String updateProfile = '/users/me';
  static const String changePassword = '/users/me/password';
  static const String uploadAvatar = '/users/me/avatar';

  // Settings
  static const String settings = '/settings';
  static const String notifications = '/settings/notifications';
}

/// Asset paths.
abstract class Assets {
  // Images
  static const String imagesPath = 'assets/images';
  static const String logo = '$imagesPath/logo.png';
  static const String placeholder = '$imagesPath/placeholder.png';

  // Icons
  static const String iconsPath = 'assets/icons';

  // Animations (Lottie)
  static const String animationsPath = 'assets/animations';
}
