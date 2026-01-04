import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';

class StartupStateResolver {
  static StartupState resolve(StartupSignals signals) {
    // 1️⃣ Maintenance ALWAYS wins
    if (signals.maintenanceEnabled) {
      return const MaintenanceState();
    }

    // 2️⃣ Onboarding BEFORE auth
    if (signals.onboardingEnabled && !signals.onboardingCompleted) {
      return const OnboardingState();
    }

    // 3️⃣ No-auth apps
    if (!signals.authEnabled) {
      return const PublicState();
    }

    // 4️⃣ Auth required
    if (!signals.isAuthenticated) {
      return const UnauthenticatedState();
    }

    // 5️⃣ Fully authenticated
    return const AuthenticatedState();
  }
}
