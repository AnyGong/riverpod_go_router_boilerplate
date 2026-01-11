import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/core/feedback/feedback_service.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/notifications.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/async_value_widget.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';

/// Home page shown after successful authentication.
class HomePage extends ConsumerWidget {
  /// Creates a [HomePage] instance.
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.pushRoute(AppRoute.settings),
          ),
        ],
      ),
      body: AsyncValueWidget<User?>(
        value: authState,
        data: (final user) {
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      user.email.substring(0, 1).toUpperCase(),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User info
                  Text(
                    user.name ?? 'User',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Welcome message
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "You're all set!",
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start building your amazing app.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Demo: Notification with Deep Linking & Badges
                  _NotificationDeepLinkDemo(),
                  const SizedBox(height: 48),

                  // Logout button
                  OutlinedButton.icon(
                    onPressed: () => _handleLogout(context, ref),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              'Sign Out',
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      // Use session service to end session
      final sessionService = ref.read(sessionServiceProvider);
      await sessionService.endSession();

      // Notify lifecycle of logout event for proper state transition
      final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
      await lifecycleNotifier.onUserLoggedOut();
    }
  }
}

/// Demo widget showcasing notification deep linking and badge functionality.
class _NotificationDeepLinkDemo extends ConsumerWidget {
  const _NotificationDeepLinkDemo();

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
            Container(
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
                    Text(
                      'Badge Count: $count',
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (count > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
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
            ),
            const SizedBox(height: 12),

            // Demo buttons
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _sendNotificationWithDeepLink(context, ref),
                  icon: const Icon(Icons.send),
                  label: const Text('Send Notification with Deep Link'),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => _incrementBadgeCount(ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Increment Badge'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _clearBadge(ref),
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Badge'),
                ),
              ],
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
      // Send notification with deep link to settings
      await notificationService.show(
        LocalNotificationConfig(
          id: DateTime.now().millisecond,
          title: 'Check Settings',
          body: 'Tap to navigate to Settings page',
          payload: '/settings', // Deep link path
          importance: Importance.high,
          channelId: 'high_priority_channel',
        ),
      );

      // Increment badge and show feedback
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
