import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/feedback/feedback_service.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/notifications.dart';

/// Widget for managing notification badge settings.
class NotificationBadgeSettings extends ConsumerWidget {
  /// Creates a [NotificationBadgeSettings] instance.
  const NotificationBadgeSettings({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final badgeCount = ref.watch(badgeCountProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        badgeCount.when(
          loading: () => const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Badge Count'),
            subtitle: Text('Loading...'),
          ),
          error: (final e, final st) => const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Badge Count'),
            subtitle: Text('Error'),
          ),
          data: (final count) => ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Badge Count'),
            subtitle: Row(
              children: [
                Text('$count notification${count != 1 ? 's' : ''}'),
                const SizedBox(width: 8),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
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
            trailing: PopupMenuButton<int>(
              itemBuilder: (final context) => [
                PopupMenuItem<int>(
                  value: 1,
                  child: const Text('Add 1'),
                  onTap: () => _incrementBadge(ref),
                ),
                PopupMenuItem<int>(
                  value: 5,
                  child: const Text('Add 5'),
                  onTap: () => _addMultipleBadges(ref, 5),
                ),
                PopupMenuItem<int>(
                  value: 0,
                  child: const Text('Clear'),
                  onTap: () => _clearBadge(ref),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Tap the menu to manage badge count. This demonstrates how to track notification count across app restarts.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _incrementBadge(final WidgetRef ref) async {
    try {
      await ref.read(badgeCountProvider.notifier).increment();
      ref.read(feedbackServiceProvider).showSuccess('Badge incremented');
    } catch (e) {
      ref.read(feedbackServiceProvider).showError('Failed: $e');
    }
  }

  Future<void> _addMultipleBadges(final WidgetRef ref, final int count) async {
    try {
      await ref.read(badgeCountProvider.notifier).addNotifications(count);
      ref
          .read(feedbackServiceProvider)
          .showSuccess('Added $count notifications');
    } catch (e) {
      ref.read(feedbackServiceProvider).showError('Failed: $e');
    }
  }

  Future<void> _clearBadge(final WidgetRef ref) async {
    try {
      await ref.read(badgeCountProvider.notifier).clearBadge();
      ref.read(feedbackServiceProvider).showSuccess('Badge cleared');
    } catch (e) {
      ref.read(feedbackServiceProvider).showError('Failed: $e');
    }
  }
}
