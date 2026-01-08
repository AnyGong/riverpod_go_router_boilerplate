import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_route_mapper.dart';

/// Splash page shown during app initialization.
///
/// This page:
/// 1. Triggers the app lifecycle initialization
/// 2. Waits for the startup state to be resolved
/// 3. Navigates to the appropriate route based on lifecycle state
///
/// The lifecycle notifier handles:
/// - Session restoration
/// - Maintenance checks
/// - Onboarding state
/// - Auth state resolution
class SplashPage extends ConsumerStatefulWidget {
  /// Creates the [SplashPage] widget.
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
    // Initialize the app lifecycle (resolves startup state)
    final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
    await lifecycleNotifier.initialize();

    // Small delay for splash screen visibility
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _navigateToInitialRoute();
    }
  }

  void _navigateToInitialRoute() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final lifecycleState = ref.read(appLifecycleNotifierProvider);
    final route = StartupRouteMapper.map(lifecycleState.currentState);

    context.go(route);
  }

  @override
  Widget build(final BuildContext context) {
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
              child: Icon(
                Icons.flutter_dash,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Flutter Boilerplate',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
