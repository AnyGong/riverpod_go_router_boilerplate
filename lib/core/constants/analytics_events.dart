/// Analytics event constants.
///
/// Use these constants to track user actions and screen views consistently
/// across the app. Log events via:
/// ```dart
/// ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.login);
/// ```
abstract final class AnalyticsEvents {
  /// User successfully logged in.
  static const String login = 'login';

  /// User successfully logged out.
  static const String logout = 'logout';

  /// User viewed the login screen.
  static const String viewLogin = 'view_login';

  /// User viewed the home screen.
  static const String viewHome = 'view_home';

  /// User viewed the settings screen.
  static const String viewSettings = 'view_settings';

  /// Feature demo/showcase used.
  static const String featureUsed = 'feature_used';

  /// User interacted with notification.
  static const String notificationInteracted = 'notification_interacted';

  /// User opened a dialog.
  static const String dialogOpened = 'dialog_opened';
}
