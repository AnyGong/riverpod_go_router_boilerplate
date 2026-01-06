import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_route_mapper.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/buttons.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/data/onboarding_service.dart';

/// Onboarding page data model
class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color? color;
}

/// Onboarding pages - customize these for your app
const _pages = [
  OnboardingPageData(
    title: 'Welcome',
    description: 'Welcome to Flutter Boilerplate. A production-ready template for your next app.',
    icon: Icons.flutter_dash,
  ),
  OnboardingPageData(
    title: 'Modern Architecture',
    description: 'Built with Riverpod, GoRouter, and clean architecture principles.',
    icon: Icons.architecture,
  ),
  OnboardingPageData(
    title: 'Ready to Ship',
    description: 'Everything you need to build and ship your app faster.',
    icon: Icons.rocket_launch,
  ),
];

/// Onboarding page shown to first-time users.
class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _completeOnboarding(context, ref),
                child: const Text('Skip'),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageContent(page: page);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _PageIndicator(
                    isActive: index == currentPage.value,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (currentPage.value > 0)
                    Expanded(
                      child: AppButton(
                        variant: AppButtonVariant.secondary,
                        label: 'Back',
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  if (currentPage.value > 0) const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      label: currentPage.value == _pages.length - 1 ? 'Get Started' : 'Next',
                      onPressed: () {
                        if (currentPage.value == _pages.length - 1) {
                          _completeOnboarding(context, ref);
                        } else {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context, WidgetRef ref) async {
    // Mark onboarding as completed
    final onboardingService = ref.read(onboardingServiceProvider);
    await onboardingService.complete();

    // Notify lifecycle notifier
    final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
    await lifecycleNotifier.onOnboardingCompleted();

    // Navigate to next screen based on current startup state
    if (context.mounted) {
      final currentState = ref.read(currentStartupStateProvider);
      final route = StartupRouteMapper.map(currentState);
      context.go(route);
    }
  }
}

class _OnboardingPageContent extends StatelessWidget {
  const _OnboardingPageContent({required this.page});

  final OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: (page.color ?? theme.colorScheme.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(page.icon, size: 64, color: page.color ?? theme.colorScheme.primary),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.isActive, required this.color});

  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
