import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Widget for managing notification badge settings.
class NotificationBadgeSettings extends ConsumerWidget {
  /// Creates a [NotificationBadgeSettings] instance.
  const NotificationBadgeSettings({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final badgeCount = ref.watch(badgeCountProvider);
    final theme = context.theme;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        badgeCount.when(
          loading: () => ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.badgeCount),
            subtitle: Text(l10n.loading),
          ),
          error: (final e, final st) => ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.badgeCount),
            subtitle: Text(l10n.errorGeneric),
          ),
          data: (final count) => ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.badgeCount),
            subtitle: Row(
              children: [
                Text(l10n.notificationCountLabel(count)),
                const HorizontalSpace.sm(),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm - 2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSM,
                      ),
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
            trailing: PopupMenuButton<_BadgeAction>(
              onSelected: (final action) =>
                  _handleBadgeAction(ref, action, l10n),
              itemBuilder: (final context) => [
                PopupMenuItem<_BadgeAction>(
                  value: _BadgeAction.incrementOne,
                  child: Text(l10n.addOne),
                ),
                PopupMenuItem<_BadgeAction>(
                  value: _BadgeAction.addFive,
                  child: Text(l10n.addFive),
                ),
                PopupMenuItem<_BadgeAction>(
                  value: _BadgeAction.clear,
                  child: Text(l10n.clear),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            l10n.badgeCountDescription,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  void _handleBadgeAction(
    final WidgetRef ref,
    final _BadgeAction action,
    final AppLocalizations l10n,
  ) {
    switch (action) {
      case _BadgeAction.incrementOne:
        _incrementBadge(ref, l10n);
      case _BadgeAction.addFive:
        _addMultipleBadges(ref, 5, l10n);
      case _BadgeAction.clear:
        _clearBadge(ref, l10n);
    }
  }

  Future<void> _incrementBadge(
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) async {
    try {
      await ref.read(badgeCountProvider.notifier).increment();
      ref.read(feedbackServiceProvider).showSuccess(l10n.badgeIncremented);
    } catch (e) {
      ref
          .read(feedbackServiceProvider)
          .showError(l10n.failedFormat(e.toString()));
    }
  }

  Future<void> _addMultipleBadges(
    final WidgetRef ref,
    final int count,
    final AppLocalizations l10n,
  ) async {
    try {
      await ref.read(badgeCountProvider.notifier).addNotifications(count);
      ref
          .read(feedbackServiceProvider)
          .showSuccess(l10n.notificationsAddedFormat(count));
    } catch (e) {
      ref
          .read(feedbackServiceProvider)
          .showError(l10n.failedFormat(e.toString()));
    }
  }

  Future<void> _clearBadge(
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) async {
    try {
      await ref.read(badgeCountProvider.notifier).clearBadge();
      ref.read(feedbackServiceProvider).showSuccess(l10n.badgeCleared);
    } catch (e) {
      ref
          .read(feedbackServiceProvider)
          .showError(l10n.failedFormat(e.toString()));
    }
  }
}

/// Enum for badge management actions.
enum _BadgeAction {
  /// Increment badge count by 1.
  incrementOne,

  /// Add 5 notifications to badge count.
  addFive,

  /// Clear all badge notifications.
  clear,
}
