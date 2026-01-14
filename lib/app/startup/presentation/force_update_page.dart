import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/review/in_app_review_service.dart';
import 'package:riverpod_go_router_boilerplate/core/version/app_version_service.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/buttons.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Force update page shown when the app version is below minimum required.
///
/// This page blocks all app functionality until the user updates.
class ForceUpdatePage extends ConsumerWidget {
  /// Creates a [ForceUpdatePage] widget.
  const ForceUpdatePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final versionAsync = ref.watch(versionInfoProvider);
    final theme = context.theme;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePadding(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Update icon
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const VerticalSpace.xl(),
              // Title
              Text(
                'Update Required',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace.md(),
              // Description
              Text(
                'A new version of the app is available. '
                'Please update to continue using the app.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace.lg(),
              // Version info
              versionAsync.when(
                data: (final info) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium + AppConstants.borderRadiusSmall,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'v${info.currentVersion}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const HorizontalSpace.sm(),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const HorizontalSpace.sm(),
                      Text(
                        'v${info.minimumVersion ?? 'Latest'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const Spacer(),
              // Update button
              AppButton(
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
                isExpanded: true,
                onPressed: () => _openStore(ref),
                icon: Icons.download,
                label: 'Update Now',
              ),
              const VerticalSpace.md(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStore(final WidgetRef ref) async {
    final reviewService = ref.read(inAppReviewServiceProvider);
    await reviewService.openStoreListing();

    // Fallback: try to open store URL directly
    // You can customize these URLs for your app
    // final storeUrl = Platform.isIOS
    //     ? 'https://apps.apple.com/app/id<YOUR_APP_ID>'
    //     : 'https://play.google.com/store/apps/details?id=<YOUR_PACKAGE_NAME>';
    //
    // final uri = Uri.parse(storeUrl);
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri, mode: LaunchMode.externalApplication);
    // }
  }
}
