import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_route_mapper.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/onboarding/data/onboarding_service.dart';

/// Onboarding page data model
class OnboardingPageData {
  /// Creates an [OnboardingPageData] instance.
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    this.color,
  });

  /// Title of the onboarding page
  final String title;

  /// Description of the onboarding page
  final String description;

  /// Icon representing the onboarding page
  final IconData icon;

  /// Optional color for the icon background
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
  /// Creates an [OnboardingPage] instance.
  const OnboardingPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final theme = context.theme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: AppButton(
                variant: .text,
                onPressed: () => _completeOnboarding(context, ref),
                label: 'Skip',
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: _pages.length,
                onPageChanged: (final index) => currentPage.value = index,
                itemBuilder: (final context, final index) {
                  final page = _pages[index];
                  return _OnboardingPageContent(page: page);
                },
              ),
            ),

            // Page indicators
            ResponsivePadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (final index) => _PageIndicator(
                    isActive: index == currentPage.value,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

            // Navigation buttons
            ResponsivePadding(
              child: Row(
                children: [
                  if (currentPage.value > 0)
                    Expanded(
                      child: AppButton(
                        variant: .secondary,
                        label: 'Back',
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  if (currentPage.value > 0) const HorizontalSpace.md(),
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

  Future<void> _completeOnboarding(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
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
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return ResponsivePadding(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: (page.color ?? theme.colorScheme.primary).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusXXL),
            ),
            child: Icon(
              page.icon,
              size: 64,
              color: page.color ?? theme.colorScheme.primary,
            ),
          ),
          const VerticalSpace.lg(),
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const VerticalSpace.md(),
          Text(
            page.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
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
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
      ),
    );
  }
}
