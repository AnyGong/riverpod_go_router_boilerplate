import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/config/remote_config_service.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Maintenance page shown when the app is under maintenance.
///
/// This page blocks all app functionality until maintenance is complete.
class MaintenancePage extends ConsumerWidget {
  /// Creates a [MaintenancePage] widget.
  const MaintenancePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final maintenanceMessage = ref.watch(maintenanceMessageProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsivePadding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Maintenance icon
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction_rounded,
                  size: 64,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const VerticalSpace.xl(),
              // Title
              Text(
                'Under Maintenance',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const VerticalSpace.md(),
              // Description
              Text(
                maintenanceMessage ??
                    'We\'re currently performing scheduled maintenance. '
                        'Please check back shortly.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Retry button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _retry(ref),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
              const VerticalSpace.md(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _retry(final WidgetRef ref) async {
    // Refresh remote config to check if maintenance is over
    final remoteConfigService = ref.read(remoteConfigServiceProvider);
    await remoteConfigService.fetch();
  }
}
