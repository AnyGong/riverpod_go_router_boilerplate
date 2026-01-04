import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_resolver.dart';

void main() {
  test('onboarding before auth', () {
    final state = StartupStateResolver.resolve(
      const StartupSignals(
        isAuthenticated: false,
        onboardingCompleted: false,
        maintenanceEnabled: false,
        onboardingEnabled: true,
        authEnabled: true,
      ),
    );

    expect(state.runtimeType, equals(OnboardingState));
  });
}
