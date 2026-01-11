import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/notifications/local_notification_service.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'badge_counter.g.dart';

/// Manages the app icon badge count.
///
/// This provider keeps track of the notification badge count and synchronizes
/// it with the app icon (iOS and supported Android launchers).
///
/// Example usage:
/// ```dart
/// // Get current badge count
/// final badgeCount = ref.watch(badgeCountProvider);
///
/// // Increment badge (e.g., when new notification arrives)
/// ref.read(badgeCountProvider.notifier).increment();
///
/// // Set badge to specific count
/// ref.read(badgeCountProvider.notifier).updateCount(5);
///
/// // Clear badge
/// ref.read(badgeCountProvider.notifier).clearBadge();
/// ```
@riverpod
class BadgeCount extends _$BadgeCount {
  @override
  Future<int> build() async {
    // Initialize with 0 badge count
    return 0;
  }

  /// Increment the badge count by 1.
  Future<void> increment() async {
    final currentCount = state.value ?? 0;
    final newCount = currentCount + 1;
    await updateCount(newCount);
  }

  /// Decrement the badge count by 1.
  ///
  /// Will not go below 0.
  Future<void> decrement() async {
    final currentCount = state.value ?? 0;
    final newCount = (currentCount - 1).clamp(0, double.infinity).toInt();
    await updateCount(newCount);
  }

  /// Set the badge count to a specific value.
  Future<void> updateCount(final int count) async {
    state = AsyncValue.data(count);

    try {
      final notificationService = ref.read(localNotificationServiceProvider);
      await notificationService.updateBadgeCount(count);
    } catch (e) {
      final logger = ref.read(loggerProvider);
      logger.w('Failed to update app badge', error: e);
    }
  }

  /// Clear the badge (set count to 0).
  ///
  /// Call this when the user opens the app or reads all notifications.
  Future<void> clearBadge() async {
    state = const AsyncValue.data(0);

    try {
      final notificationService = ref.read(localNotificationServiceProvider);
      await notificationService.removeBadge();
    } catch (e) {
      final logger = ref.read(loggerProvider);
      logger.w('Failed to clear app badge', error: e);
    }
  }

  /// Increment badge in response to a new notification.
  ///
  /// This is a convenience method that increments and returns the new count.
  Future<int> onNewNotification() async {
    await increment();
    return state.value ?? 0;
  }

  /// Add multiple notifications at once.
  ///
  /// Useful if you're processing a batch of notifications.
  Future<void> addNotifications(final int count) async {
    final currentCount = state.value ?? 0;
    final newCount = currentCount + count;
    await updateCount(newCount);
  }

  /// Reset badge count.
  ///
  /// This is useful for testing or when you want to start fresh.
  Future<void> reset() async {
    state = const AsyncValue.data(0);
  }
}
