import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/pages/splash_page.dart';

final splashRoute = GoRoute(path: '/splash', builder: (_, _) => const SplashPage());
