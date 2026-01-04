import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';

class StartupRouteMapper {
  static String map(StartupState state) {
    return switch (state) {
      MaintenanceState() => '/maintenance',
      OnboardingState() => '/onboarding',
      UnauthenticatedState() => '/login',
      AuthenticatedState() => '/',
      PublicState() => '/',
    };
  }
}
