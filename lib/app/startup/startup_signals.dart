/// Runtime signals that influence startup behavior.
/// These are NOT states, only inputs.
class StartupSignals {
  final bool isAuthenticated;
  final bool onboardingCompleted;
  final bool maintenanceEnabled;
  final bool onboardingEnabled;
  final bool authEnabled;

  const StartupSignals({
    required this.isAuthenticated,
    required this.onboardingCompleted,
    required this.maintenanceEnabled,
    required this.onboardingEnabled,
    required this.authEnabled,
  });
}
