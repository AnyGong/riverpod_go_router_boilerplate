/// Represents the valid startup states of the app.
/// These states are mutually exclusive and exhaustive.
sealed class StartupState {
  const StartupState();
}

/// App is under maintenance – nothing else is accessible
final class MaintenanceState extends StartupState {
  const MaintenanceState();
}

/// User must complete onboarding
final class OnboardingState extends StartupState {
  const OnboardingState();
}

/// User must authenticate before accessing protected features
final class UnauthenticatedState extends StartupState {
  const UnauthenticatedState();
}

/// User is authenticated and can access protected features
final class AuthenticatedState extends StartupState {
  const AuthenticatedState();
}

/// App does not require authentication at all
final class PublicState extends StartupState {
  const PublicState();
}
