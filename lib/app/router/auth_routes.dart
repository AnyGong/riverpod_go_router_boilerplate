import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/pages/login_page.dart';

/// Routes that are accessible without authentication.
final authRoutes = [
  GoRoute(
    path: AppRoutes.login,
    name: 'login',
    builder: (final context, final state) => const LoginPage(),
  ),
];
