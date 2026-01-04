import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/pages/login_page.dart';

final authRoutes = [GoRoute(path: '/login', builder: (_, __) => const LoginPage())];
