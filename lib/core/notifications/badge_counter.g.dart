// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_counter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(BadgeCount)
final badgeCountProvider = BadgeCountProvider._();

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
final class BadgeCountProvider extends $AsyncNotifierProvider<BadgeCount, int> {
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
  BadgeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'badgeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$badgeCountHash();

  @$internal
  @override
  BadgeCount create() => BadgeCount();
}

String _$badgeCountHash() => r'f602db82ffaa9c869837c4cfa7f6f6984b17b955';

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

abstract class _$BadgeCount extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
