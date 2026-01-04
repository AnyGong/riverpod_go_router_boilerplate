class StartupState {
  final bool isAuthenticated;
  final bool onboardingCompleted;
  final bool maintenanceEnabled;
  final bool onboardingFeatureEnabled;

  const StartupState({
    required this.isAuthenticated,
    required this.onboardingCompleted,
    required this.maintenanceEnabled,
    required this.onboardingFeatureEnabled,
  });
}
