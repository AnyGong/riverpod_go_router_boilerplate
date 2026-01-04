enum StartupPolicy {
  authRequired,
  publicHome,
  noAuth,

  onboardingRequired,
  maintenanceMode,
  featureFlaggedStartup,
}

class AppConfig {
  /// Static, project-level policy
  static const startupPolicy = StartupPolicy.maintenanceMode;

  /// Feature flag keys (used only when featureFlaggedStartup)
  static const onboardingFlagKey = 'onboarding_enabled';
}
