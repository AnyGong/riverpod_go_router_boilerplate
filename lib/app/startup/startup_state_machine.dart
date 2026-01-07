/// Represents the valid startup states of the app.
///
/// These states are mutually exclusive and exhaustive.
/// The app can only be in ONE of these states at any given time.
///
/// State Priority (highest to lowest):
/// 1. [MaintenanceState] - App is under maintenance
/// 2. [OnboardingState] - User needs to complete onboarding
/// 3. [UnauthenticatedState] - User needs to login
/// 4. [AuthenticatedState] - User is logged in
/// 5. [PublicState] - App doesn't require auth
///
/// See [StartupStateResolver] for the logic that determines the current state.
sealed class StartupState {
  const StartupState();
}

/// App is under maintenance – nothing else is accessible.
/// This state always takes priority over all other states.
final class MaintenanceState extends StartupState {
  const MaintenanceState();

  @override
  String toString() => 'MaintenanceState';
}

/// User must complete onboarding before accessing the app.
/// Takes priority over authentication states.
final class OnboardingState extends StartupState {
  const OnboardingState();

  @override
  String toString() => 'OnboardingState';
}

/// User must authenticate before accessing protected features.
final class UnauthenticatedState extends StartupState {
  const UnauthenticatedState();

  @override
  String toString() => 'UnauthenticatedState';
}

/// User is authenticated and can access protected features.
final class AuthenticatedState extends StartupState {
  const AuthenticatedState();

  @override
  String toString() => 'AuthenticatedState';
}

/// App does not require authentication at all.
/// For apps that are fully public.
final class PublicState extends StartupState {
  const PublicState();

  @override
  String toString() => 'PublicState';
}
