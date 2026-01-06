import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/features/home/presentation/pages/home_page.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/pages/settings_page.dart';

/// Routes that require authentication.
final protectedRoutes = [
  GoRoute(path: AppRoutes.home, name: 'home', builder: (context, state) => const HomePage()),
  GoRoute(
    path: AppRoutes.profile,
    name: 'profile',
    builder: (context, state) => const _PlaceholderPage(title: 'Profile'),
  ),
  GoRoute(
    path: AppRoutes.settings,
    name: 'settings',
    builder: (context, state) => const SettingsPage(),
  ),
  GoRoute(
    path: AppRoutes.onboarding,
    name: 'onboarding',
    builder: (context, state) => const OnboardingPage(),
  ),
  GoRoute(
    path: AppRoutes.maintenance,
    name: 'maintenance',
    builder: (context, state) => const _MaintenancePage(),
  ),
];

/// Placeholder page for routes that haven't been implemented yet.
/// Replace these with actual feature pages.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'This page is under construction',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Maintenance page shown when the app is under maintenance.
class _MaintenancePage extends StatelessWidget {
  const _MaintenancePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.build_circle, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text('Under Maintenance', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text(
                'We\'re currently performing maintenance.\nPlease check back later.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
