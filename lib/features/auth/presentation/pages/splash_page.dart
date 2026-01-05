import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_route_mapper.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_resolver.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';

/// Splash page shown during app initialization.
/// Determines the initial route based on startup signals.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for auth state to be resolved
    await ref.read(authNotifierProvider.future);

    // Perform any additional initialization here
    // e.g., load remote config, check for updates, etc.

    // Small delay for splash screen visibility
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _navigateToInitialRoute();
    }
  }

  void _navigateToInitialRoute() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final authState = ref.read(authNotifierProvider);

    final signals = StartupSignals(
      isAuthenticated: authState.value != null,
      onboardingCompleted: false, // TODO: Read from secure storage
      maintenanceEnabled: false, // TODO: Read from remote config
      onboardingEnabled: AppConfig.onboardingEnabled,
      authEnabled: AppConfig.authEnabled,
    );

    final startupState = StartupStateResolver.resolve(signals);
    final route = StartupRouteMapper.map(startupState);

    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.flutter_dash, size: 64, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 32),
            Text(
              'Flutter Boilerplate',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3, color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
