import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_decider.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authNotifierProvider);

      final startupState = StartupState(
        isAuthenticated: authState.value != null,
        onboardingCompleted: false, // TODO: load from storage
        maintenanceEnabled: false, // TODO: remote config
        onboardingFeatureEnabled: true, // TODO: feature flag
      );

      final route = StartupDecider.decide(policy: AppConfig.startupPolicy, state: startupState);

      context.go(route);
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
