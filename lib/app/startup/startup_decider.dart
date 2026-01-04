import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state.dart';

class StartupDecider {
  static String decide({required StartupPolicy policy, required StartupState state}) {
    switch (policy) {
      case StartupPolicy.maintenanceMode:
        return '/maintenance';

      case StartupPolicy.noAuth:
        return '/';

      case StartupPolicy.publicHome:
        return '/';

      case StartupPolicy.authRequired:
        return state.isAuthenticated ? '/' : '/login';

      case StartupPolicy.onboardingRequired:
        if (!state.isAuthenticated) return '/login';
        if (!state.onboardingCompleted) return '/onboarding';
        return '/';

      case StartupPolicy.featureFlaggedStartup:
        if (state.maintenanceEnabled) return '/maintenance';

        if (state.onboardingFeatureEnabled && !state.onboardingCompleted) {
          return '/onboarding';
        }

        return state.isAuthenticated ? '/' : '/login';
    }
  }
}
