import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';

/// Resolves the current startup state from signals.
///
/// This is a pure function with no side effects.
/// Given the same signals, it will always return the same state.
///
/// Priority order:
/// 1. Maintenance ALWAYS wins (blocks everything)
/// 2. Onboarding BEFORE auth (must be completed first)
/// 3. No-auth apps go to public state
/// 4. Auth required → check authentication
/// 5. Fully authenticated → grant access
///
/// Example:
/// ```dart
/// final state = StartupStateResolver.resolve(signals);
/// final route = StartupRouteMapper.map(state);
/// context.go(route);
/// ```
class StartupStateResolver {
  const StartupStateResolver._();

  /// Resolve the startup state from the given signals.
  static StartupState resolve(StartupSignals signals) {
    // 1️⃣ Maintenance ALWAYS wins
    if (signals.isInMaintenance) {
      return const MaintenanceState();
    }

    // 2️⃣ Onboarding BEFORE auth
    if (signals.isOnboardingEnabled && !signals.hasCompletedOnboarding) {
      return const OnboardingState();
    }

    // 3️⃣ No-auth apps
    if (!signals.isAuthEnabled) {
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
