/// Events that can trigger startup re-evaluation.
///
/// These represent "why we need to reconsider the current state"
/// as opposed to "what state we're in".
sealed class StartupEvent {
  const StartupEvent();
}

/// App just launched, need initial evaluation
final class AppLaunched extends StartupEvent {
  const AppLaunched();

  @override
  String toString() => 'AppLaunched()';
}

/// Session was restored from storage
final class SessionRestored extends StartupEvent {
  const SessionRestored({required this.userId});

  final String userId;

  @override
  String toString() => 'SessionRestored(userId: $userId)';
}

/// User successfully authenticated
final class UserAuthenticated extends StartupEvent {
  const UserAuthenticated({required this.userId});

  final String userId;

  @override
  String toString() => 'UserAuthenticated(userId: $userId)';
}

/// User logged out intentionally
final class UserLoggedOut extends StartupEvent {
  const UserLoggedOut();

  @override
  String toString() => 'UserLoggedOut()';
}

/// Session expired (token invalid, etc.)
final class SessionExpiredEvent extends StartupEvent {
  const SessionExpiredEvent({this.reason});

  final String? reason;

  @override
  String toString() => 'SessionExpiredEvent(reason: $reason)';
}

/// Onboarding was completed
final class OnboardingCompleted extends StartupEvent {
  const OnboardingCompleted();

  @override
  String toString() => 'OnboardingCompleted()';
}

/// Maintenance mode was enabled
final class MaintenanceEnabled extends StartupEvent {
  const MaintenanceEnabled({this.message});

  final String? message;

  @override
  String toString() => 'MaintenanceEnabled(message: $message)';
}

/// Maintenance mode was disabled
final class MaintenanceDisabled extends StartupEvent {
  const MaintenanceDisabled();

  @override
  String toString() => 'MaintenanceDisabled()';
}

/// Remote config was updated
final class RemoteConfigUpdated extends StartupEvent {
  const RemoteConfigUpdated();

  @override
  String toString() => 'RemoteConfigUpdated()';
}

/// Deep link received that requires navigation
final class DeepLinkReceived extends StartupEvent {
  const DeepLinkReceived({required this.path});

  final String path;

  @override
  String toString() => 'DeepLinkReceived(path: $path)';
}
