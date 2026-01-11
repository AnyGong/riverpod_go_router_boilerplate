import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/review/in_app_review_service.dart';
import 'package:riverpod_go_router_boilerplate/core/version/app_version_service.dart';

/// Force update page shown when the app version is below minimum required.
///
/// This page blocks all app functionality until the user updates.
class ForceUpdatePage extends ConsumerWidget {
  /// Creates a [ForceUpdatePage] widget.
  const ForceUpdatePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final versionAsync = ref.watch(versionInfoProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Update icon
              Container(
                padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 32),
              // Title
              Text(
                'Update Required',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'A new version of the app is available. '
                'Please update to continue using the app.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Version info
              versionAsync.when(
                data: (final info) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
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
                      const SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
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
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openStore(ref),
                  icon: const Icon(Icons.download),
                  label: const Text('Update Now'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
