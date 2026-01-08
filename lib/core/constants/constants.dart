/// Application-wide constants.
abstract class AppConstants {
  // ─────────────────────────────────────────────────────────────────────────────
  // ANIMATION DURATIONS
  // ─────────────────────────────────────────────────────────────────────────────
  /// Fast animation duration.
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Normal animation duration.
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// Slow animation duration.
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
  /// Debounce delay for user input.
  static const Duration debounceDelay = Duration(milliseconds: 500);

  /// Throttle delay for actions.
  static const Duration throttleDelay = Duration(milliseconds: 300);

  // ─────────────────────────────────────────────────────────────────────────────
  // PAGINATION
  // ─────────────────────────────────────────────────────────────────────────────
  /// Default number of items per page for paginated requests.
  static const int defaultPageSize = 20;

  /// Maximum number of items per page allowed.
  static const int maxPageSize = 100;

  // ─────────────────────────────────────────────────────────────────────────────
  // UI DIMENSIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Small border radius for subtle rounding.
  static const double borderRadiusSmall = 4;

  /// Medium border radius for standard rounding.
  static const double borderRadiusMedium = 8;

  /// Large border radius for prominent rounding.
  static const double borderRadiusLarge = 16;

  /// Extra large border radius for very rounded corners.
  static const double borderRadiusXLarge = 24;

  // Icon sizes

  /// Small icon size.
  static const double iconSizeSmall = 16;

  /// Medium icon size.
  static const double iconSizeMedium = 24;

  /// Large icon size.
  static const double iconSizeLarge = 32;

  /// Standard button height.
  static const double buttonHeight = 48;

  /// Standard input field height.
  static const double inputHeight = 56;

  /// Standard app bar height.
  static const double appBarHeight = 56;

  /// Maximum content width for large screens.
  static const double maxContentWidth = 600;

  /// Maximum width for tablets.
  static const double maxTabletWidth = 900;

  // ─────────────────────────────────────────────────────────────────────────────
  // PADDING & MARGIN
  // ─────────────────────────────────────────────────────────────────────────────
  /// Extra extra small padding/margin.
  static const double paddingXS = 4;

  /// Extra small padding/margin.
  static const double paddingSM = 8;

  /// Medium padding/margin.
  static const double paddingMD = 16;

  /// Large padding/margin.
  static const double paddingLG = 24;

  /// Extra large padding/margin.
  static const double paddingXL = 32;

  /// Extra extra large padding/margin.
  static const double paddingXXL = 48;

  // ─────────────────────────────────────────────────────────────────────────────
  // VALIDATION
  // ─────────────────────────────────────────────────────────────────────────────
  /// Minimum password length.
  static const int minPasswordLength = 8;

  /// Maximum password length.
  static const int maxPasswordLength = 128;

  /// Minimum username length.
  static const int minUsernameLength = 3;

  /// Maximum username length.
  static const int maxUsernameLength = 30;

  /// Maximum bio length.
  static const int maxBioLength = 500;

  /// Maximum file size in bytes (10MB).
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // ─────────────────────────────────────────────────────────────────────────────
  // REGEX PATTERNS
  // ─────────────────────────────────────────────────────────────────────────────
  /// Email validation pattern.
  static final RegExp emailPattern = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// Phone number validation pattern.
  static final RegExp phonePattern = RegExp(r'^\+?[\d\s-]{10,}$');

  /// URL validation pattern.
  static final RegExp urlPattern = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );
}

/// API endpoint paths.
abstract class ApiEndpoints {
  // Auth
  /// Login endpoint.
  static const String login = '/auth/login';

  /// Register endpoint.
  static const String register = '/auth/register';

  /// Logout endpoint.
  static const String logout = '/auth/logout';

  /// Refresh token endpoint.
  static const String refreshToken = '/auth/refresh';

  /// Forgot password endpoint.
  static const String forgotPassword = '/auth/forgot-password';

  /// Reset password endpoint.
  static const String resetPassword = '/auth/reset-password';

  /// Verify email endpoint.
  static const String verifyEmail = '/auth/verify-email';

  // User
  /// Get current user profile.
  static const String currentUser = '/users/me';

  /// Update user profile.
  static const String updateProfile = '/users/me';

  /// Change user password.
  static const String changePassword = '/users/me/password';

  /// Upload user avatar.
  static const String uploadAvatar = '/users/me/avatar';

  // Settings
  /// Get app settings.
  static const String settings = '/settings';

  /// Notification settings.
  static const String notifications = '/settings/notifications';
}

/// Asset paths.
abstract class Assets {
  // Images
  /// Base path for images.
  static const String imagesPath = 'assets/images';

  /// Logo image asset.
  static const String logo = '$imagesPath/logo.png';

  /// Placeholder image asset.
  static const String placeholder = '$imagesPath/placeholder.png';

  // Icons
  /// Base path for icons.
  static const String iconsPath = 'assets/icons';

  // Animations (Lottie)
  /// Base path for animations.
  static const String animationsPath = 'assets/animations';
}
