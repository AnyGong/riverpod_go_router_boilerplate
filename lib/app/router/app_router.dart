import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/router/auth_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/protected_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/splash_route.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',

    routes: [splashRoute, ...authRoutes, ...protectedRoutes],

    redirect: (_, state) {
      final path = state.uri.path;
      final isLoggedIn = ref.read(authNotifierProvider).value != null;

      // Maintenance hard stop
      if (path != '/maintenance' && state.matchedLocation == '/maintenance') {
        return '/maintenance';
      }

      // Protect private routes ONLY
      const protectedPaths = ['/', '/profile', '/settings'];

      if (protectedPaths.contains(path) && !isLoggedIn) {
        return '/login';
      }

      // Logged-in users should not see login
      if (isLoggedIn && path == '/login') {
        return '/';
      }

      return null;
    },
  );
});
