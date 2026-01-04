import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_route_mapper.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_resolver.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final authState = ref.read(authNotifierProvider);

      final signals = StartupSignals(
        isAuthenticated: authState.value != null,
        onboardingCompleted: false, // later: persistent storage
        maintenanceEnabled: false, // later: remote config
        onboardingEnabled: AppConfig.onboardingEnabled,
        authEnabled: AppConfig.authEnabled,
      );

      final startupState = StartupStateResolver.resolve(signals);

      final route = StartupRouteMapper.map(startupState);

      if (mounted) {
        context.go(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
