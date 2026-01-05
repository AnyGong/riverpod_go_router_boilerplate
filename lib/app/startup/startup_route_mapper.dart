import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';

/// Maps startup states to their corresponding routes.
class StartupRouteMapper {
  const StartupRouteMapper._();

  /// Get the route for a given startup state.
  static String map(StartupState state) {
    return switch (state) {
      MaintenanceState() => AppRoutes.maintenance,
      OnboardingState() => AppRoutes.onboarding,
      UnauthenticatedState() => AppRoutes.login,
      AuthenticatedState() => AppRoutes.home,
      PublicState() => AppRoutes.home,
    };
  }
}
