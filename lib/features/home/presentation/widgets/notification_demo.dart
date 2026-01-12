import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/feedback/feedback_service.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/notifications.dart';

/// Demo widget showcasing notification deep linking and badge functionality.
class NotificationDeepLinkDemo extends ConsumerWidget {
  /// Creates a [NotificationDeepLinkDemo] instance.
  const NotificationDeepLinkDemo({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final badgeCount = ref.watch(badgeCountProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Notifications & Deep Linking',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Badge counter display
            _BadgeCountDisplay(badgeCount: badgeCount, theme: theme),
            const SizedBox(height: 12),

            // Demo buttons
            _DemoButtons(
              onSendNotification: () =>
                  _sendNotificationWithDeepLink(context, ref),
              onIncrement: () => _incrementBadgeCount(ref),
              onClear: () => _clearBadge(ref),
            ),
            const SizedBox(height: 12),

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
      padding: const EdgeInsets.all(12),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        ElevatedButton.icon(
          onPressed: onSendNotification,
          icon: const Icon(Icons.send),
          label: const Text('Send Notification with Deep Link'),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: onIncrement,
          icon: const Icon(Icons.add),
          label: const Text('Increment Badge'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.clear),
          label: const Text('Clear Badge'),
        ),
      ],
    );
  }
}
