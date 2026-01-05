import 'package:flutter/foundation.dart';

/// Runtime signals that influence startup behavior.
///
/// These are NOT states, only inputs to the [StartupStateResolver].
/// The resolver uses these signals to determine the current [StartupState].
///
/// Example:
/// ```dart
/// final signals = StartupSignals(
///   isAuthenticated: authState.value != null,
///   onboardingCompleted: await storage.read(key: 'onboarding_completed') == 'true',
///   maintenanceEnabled: remoteConfig.getBool('maintenance_enabled'),
///   onboardingEnabled: AppConfig.onboardingEnabled,
///   authEnabled: AppConfig.authEnabled,
/// );
/// ```
@immutable
class StartupSignals {
  const StartupSignals({
    required this.isAuthenticated,
    required this.onboardingCompleted,
    required this.maintenanceEnabled,
    required this.onboardingEnabled,
    required this.authEnabled,
  });

  /// Whether the user is currently authenticated.
  /// Usually determined by checking if a valid session exists.
  final bool isAuthenticated;

  /// Whether the user has completed the onboarding flow.
  /// Read from persistent storage.
  final bool onboardingCompleted;

  /// Whether the app is in maintenance mode.
  /// Usually controlled by remote config/feature flags.
  final bool maintenanceEnabled;

  /// Whether onboarding is enabled for this app.
  /// Static configuration from [AppConfig].
  final bool onboardingEnabled;

  /// Whether authentication is required for this app.
  /// Static configuration from [AppConfig].
  final bool authEnabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartupSignals &&
          runtimeType == other.runtimeType &&
          isAuthenticated == other.isAuthenticated &&
          onboardingCompleted == other.onboardingCompleted &&
          maintenanceEnabled == other.maintenanceEnabled &&
          onboardingEnabled == other.onboardingEnabled &&
          authEnabled == other.authEnabled;

  @override
  int get hashCode => Object.hash(
    isAuthenticated,
    onboardingCompleted,
    maintenanceEnabled,
    onboardingEnabled,
    authEnabled,
  );

  @override
  String toString() =>
      'StartupSignals('
      'isAuthenticated: $isAuthenticated, '
      'onboardingCompleted: $onboardingCompleted, '
      'maintenanceEnabled: $maintenanceEnabled, '
      'onboardingEnabled: $onboardingEnabled, '
      'authEnabled: $authEnabled)';
}
