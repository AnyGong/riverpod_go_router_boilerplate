import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';
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
/// Listens to auth state changes and redirects accordingly.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authListenable = ref.watch(authStateListenableProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authListenable,
    routes: [splashRoute, ...authRoutes, ...protectedRoutes],
    redirect: (context, state) {
      final path = state.uri.path;
      final authState = ref.read(authNotifierProvider);
      final isLoading = authState.isLoading;

      // Don't redirect while auth state is loading (except from splash)
      if (isLoading && path != AppRoutes.splash) {
        return null;
      }

      // Maintenance hard stop
      if (path == AppRoutes.maintenance) {
        return null;
      }

      // Allow splash to handle initial routing
      if (path == AppRoutes.splash) {
        return null;
      }

      // Check if user is logged in
      final isLoggedIn = authState.value != null;

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
