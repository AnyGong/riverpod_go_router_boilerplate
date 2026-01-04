import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/router/auth_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/protected_routes.dart';
import 'package:riverpod_go_router_boilerplate/app/router/splash_route.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',

    routes: [splashRoute, ...authRoutes, ...protectedRoutes],

    redirect: (_, state) {
      final path = state.uri.path;
      final isLoggedIn = authState.value != null;

      // 1️⃣ Maintenance mode ALWAYS wins
      if (AppConfig.startupPolicy == StartupPolicy.maintenanceMode) {
        return path == '/maintenance' ? null : '/maintenance';
      }

      // 2️⃣ No-auth apps never redirect
      if (AppConfig.startupPolicy == StartupPolicy.noAuth) {
        return null;
      }

      // 3️⃣ Auth-required apps
      if (AppConfig.startupPolicy == StartupPolicy.authRequired) {
        final isLogin = path == '/login';

        if (!isLoggedIn && !isLogin) return '/login';
        if (isLoggedIn && isLogin) return '/';
      }

      // 4️⃣ Onboarding-required apps
      if (AppConfig.startupPolicy == StartupPolicy.onboardingRequired) {
        final isAuthRoute = path == '/login';
        final isOnboarding = path == '/onboarding';

        if (!isLoggedIn && !isAuthRoute) return '/login';

        // onboarding completion is handled by SplashDecider
        if (isLoggedIn && isAuthRoute) return '/';
        if (isLoggedIn && !isOnboarding && path == '/onboarding') {
          return null;
        }
      }

      // 5️⃣ Feature-flagged startup
      // (Routing priority is handled in SplashPage)
      if (AppConfig.startupPolicy == StartupPolicy.featureFlaggedStartup) {
        // Router only enforces auth if user enters protected areas
        final isLogin = path == '/login';
        final isProtected = path == '/';

        if (isProtected && !isLoggedIn) return '/login';
        if (isLoggedIn && isLogin) return '/';
      }

      return null;
    },
  );
});
