import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/router/auth_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/protected_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/splash_route.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_state.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session.dart';

/// Route paths used throughout the app.
/// Use these instead of hardcoded strings.
abstract class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String maintenance = '/maintenance';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Global navigator key for accessing navigation outside of widget context.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Provider for the app router.
///
/// Uses [appLifecycleListenableProvider] to refresh when lifecycle state changes.
/// This enables reactive routing based on session state, maintenance mode, etc.
final appRouterProvider = Provider<GoRouter>((final ref) {
  // Use lifecycle listenable for refresh - this triggers re-evaluation
  // when session state changes, maintenance mode toggles, etc.
  final lifecycleListenable = ref.watch(appLifecycleListenableProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: lifecycleListenable,
    routes: [splashRoute, ...authRoutes, ...protectedRoutes],
    redirect: (final context, final state) =>
        _handleRedirect(ref, state.uri.path),
    errorBuilder: (final context, final state) =>
        _ErrorPage(path: state.uri.path),
  );
});

// ============================================================================
// Redirect Guards (Chain of Responsibility Pattern)
// ============================================================================

/// Main redirect handler - delegates to specific guards.
String? _handleRedirect(final Ref ref, final String path) {
  final lifecycleState = ref.read(appLifecycleNotifierProvider);
  final sessionState = ref.read(sessionStateProvider);

  // Apply guards in order of priority
  return _guardLoading(path, sessionState) ??
      _guardInitialization(path, lifecycleState) ??
      _guardMaintenance(path) ??
      _guardSplash(path) ??
      _guardAuth(path, sessionState);
}

/// Guard: Don't redirect while session is loading (except from splash).
String? _guardLoading(final String path, final SessionState sessionState) {
  if (sessionState.isLoading && path != AppRoutes.splash) {
    return null; // Allow current navigation to proceed
  }
  return null;
}

/// Guard: Force splash until initialization completes.
/// Prevents "flash of unauthenticated content" when deep links arrive
/// before session state is restored from storage.
String? _guardInitialization(
  final String path,
  final AppLifecycleState lifecycleState,
) {
  if (!lifecycleState.isInitialized) {
    if (path != AppRoutes.splash) {
      return AppRoutes.splash; // Force back to splash
    }
    return null; // Stay on splash
  }
  return null;
}

/// Guard: Always allow access to maintenance page.
String? _guardMaintenance(final String path) {
  if (path == AppRoutes.maintenance) {
    return null; // Allow access
  }
  return null;
}

/// Guard: Allow splash to handle its own routing.
String? _guardSplash(final String path) {
  if (path == AppRoutes.splash) {
    return null; // Splash handles navigation after init
  }
  return null;
}

/// Guard: Handle authentication-based redirects.
String? _guardAuth(final String path, final SessionState sessionState) {
  if (!AppConfig.authEnabled) {
    return null; // Auth disabled, allow all routes
  }

  final isLoggedIn = sessionState.isAuthenticated;

  // Protected routes that require authentication
  const protectedPaths = [
    AppRoutes.home,
    AppRoutes.profile,
    AppRoutes.settings,
  ];

  // Redirect unauthenticated users away from protected routes
  if (protectedPaths.contains(path) && !isLoggedIn) {
    return AppRoutes.login;
  }

  // Redirect authenticated users away from login
  if (isLoggedIn && path == AppRoutes.login) {
    return AppRoutes.home;
  }

  return null;
}

// ============================================================================
// Error Page
// ============================================================================

/// Error page shown when route is not found.
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.path});

  final String path;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              path,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
