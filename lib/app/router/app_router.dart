import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session.dart';
import 'package:riverpod_go_router_boilerplate/app/router/auth_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/protected_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/splash_route.dart';

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
final appRouterProvider = Provider<GoRouter>((ref) {
  // Use lifecycle listenable for refresh - this triggers re-evaluation
  // when session state changes, maintenance mode toggles, etc.
  final lifecycleListenable = ref.watch(appLifecycleListenableProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: lifecycleListenable,
    routes: [splashRoute, ...authRoutes, ...protectedRoutes],
    redirect: (context, state) {
      final path = state.uri.path;
      final lifecycleState = ref.read(appLifecycleNotifierProvider);
      final sessionState = ref.read(sessionStateProvider);
      final isLoading = sessionState.isLoading;

      // Don't redirect while loading (except from splash)
      if (isLoading && path != AppRoutes.splash) {
        return null;
      }

      // Don't redirect until lifecycle is initialized
      if (!lifecycleState.isInitialized && path == AppRoutes.splash) {
        return null;
      }

      // Maintenance hard stop - always allow access
      if (path == AppRoutes.maintenance) {
        return null;
      }

      // Allow splash to handle initial routing
      if (path == AppRoutes.splash) {
        return null;
      }

      // Check session state for auth-based redirects
      final isLoggedIn = sessionState.isAuthenticated;

      // Define protected routes
      const protectedPaths = [AppRoutes.home, AppRoutes.profile, AppRoutes.settings];

      // Redirect unauthenticated users away from protected routes
      if (protectedPaths.contains(path) && !isLoggedIn) {
        return AppRoutes.login;
      }

      // Redirect authenticated users away from login
      if (isLoggedIn && path == AppRoutes.login) {
        return AppRoutes.home;
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              state.uri.path,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
