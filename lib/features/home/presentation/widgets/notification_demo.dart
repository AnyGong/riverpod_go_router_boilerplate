import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// Demo widget showcasing notification deep linking and badge functionality.
class NotificationDeepLinkDemo extends ConsumerWidget {
  /// Creates a [NotificationDeepLinkDemo] instance.
  const NotificationDeepLinkDemo({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final badgeCount = ref.watch(badgeCountProvider);
    final theme = context.theme;

    return Card(
      child: ResponsivePadding(
        horizontal: AppSpacing.sm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const HorizontalSpace.sm(),
                Text(
                  'Notifications & Deep Linking',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const VerticalSpace.md(),

            // Badge counter display
            _BadgeCountDisplay(badgeCount: badgeCount, theme: theme),
            const VerticalSpace.md(),

            // Demo buttons
            _DemoButtons(
              onSendNotification: () =>
                  _sendNotificationWithDeepLink(context, ref),
              onIncrement: () => _incrementBadgeCount(ref),
              onClear: () => _clearBadge(ref),
            ),
            const VerticalSpace.md(),

            // Info text
            Text(
              'Send a notification that routes to Settings when tapped.',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendNotificationWithDeepLink(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final feedbackService = ref.read(feedbackServiceProvider);
    final notificationService = ref.read(localNotificationServiceProvider);

    try {
      await notificationService.show(
        LocalNotificationConfig(
          id: DateTime.now().millisecond,
          title: 'Check Settings',
          body: 'Tap to navigate to Settings page',
          payload: '/settings',
          importance: Importance.high,
          channelId: 'high_priority_channel',
        ),
      );

      await ref.read(badgeCountProvider.notifier).onNewNotification();
      feedbackService.showSuccess(
        'Notification sent! (will route to /settings on tap)',
      );
    } catch (e) {
      feedbackService.showError('Failed to send notification: $e');
    }
  }

  Future<void> _incrementBadgeCount(final WidgetRef ref) async {
    try {
      await ref.read(badgeCountProvider.notifier).increment();
    } catch (e) {
      ref.read(feedbackServiceProvider).showError('Failed to update badge: $e');
    }
  }

  Future<void> _clearBadge(final WidgetRef ref) async {
    try {
      await ref.read(badgeCountProvider.notifier).clearBadge();
      ref.read(feedbackServiceProvider).showSuccess('Badge cleared');
    } catch (e) {
      ref.read(feedbackServiceProvider).showError('Failed to clear badge: $e');
    }
  }
}

class _BadgeCountDisplay extends StatelessWidget {
  const _BadgeCountDisplay({
    required this.badgeCount,
    required this.theme,
  });

  final AsyncValue<int> badgeCount;
  final ThemeData theme;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: badgeCount.when(
        loading: () => const Text('Loading badge count...'),
        error: (final e, final st) => const Text('Badge count unavailable'),
        data: (final count) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Badge Count: $count', style: theme.textTheme.bodyMedium),
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$count',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DemoButtons extends StatelessWidget {
  const _DemoButtons({
    required this.onSendNotification,
    required this.onIncrement,
    required this.onClear,
  });

  final VoidCallback onSendNotification;
  final VoidCallback onIncrement;
  final VoidCallback onClear;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        AppButton(
          variant: .secondary,
          size: .medium,
          onPressed: onIncrement,
          icon: Icons.add,
          label: 'Increment Badge',
        ),
        const VerticalSpace.sm(),
        AppButton(
          variant: .primary,
          size: .large,
          onPressed: onSendNotification,
          icon: Icons.send,
          label: 'Send Notification with Deep Link',
        ),
        const VerticalSpace.sm(),
        AppButton(
          variant: .text,
          size: .medium,
          onPressed: onClear,
          icon: Icons.clear,
          label: 'Clear Badge',
        ),
      ],
    );
  }
}
