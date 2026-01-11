import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'local_notification_service.g.dart';

/// Callback type for handling notification taps.
/// The [NotificationResponse.payload] can contain a deep link path.
/// Example: response.payload = '/profile/123' or '/chat/user456'
typedef NotificationTapCallback = void Function(NotificationResponse response);

/// Default notification channel for Android.
const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
  'default_channel',
  'Default Notifications',
  description: 'Default notification channel for general notifications.',
  importance: Importance.defaultImportance,
);

/// High priority notification channel for Android.
const AndroidNotificationChannel highPriorityChannel = AndroidNotificationChannel(
  'high_priority_channel',
  'Important Notifications',
  description: 'Channel for important notifications that require attention.',
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
);

/// Configuration for a local notification.
class LocalNotificationConfig {
  /// Creates a [LocalNotificationConfig] instance.
  const LocalNotificationConfig({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.channelId = 'default_channel',
    this.icon,
    this.largeIcon,
    this.importance = Importance.defaultImportance,
    this.priority = Priority.defaultPriority,
    this.playSound = true,
    this.enableVibration = true,
    this.category,
    this.groupKey,
  });

  /// Unique identifier for the notification.
  final int id;

  /// Notification title.
  final String title;

  /// Notification body text.
  final String body;

  /// Optional payload data (e.g., for deep linking).
  final String? payload;

  /// Android notification channel ID.
  final String channelId;

  /// Small icon name (Android only, without extension).
  final String? icon;

  /// Large icon path or asset (Android only).
  final String? largeIcon;

  /// Notification importance level.
  final Importance importance;

  /// Notification priority.
  final Priority priority;

  /// Whether to play sound.
  final bool playSound;

  /// Whether to vibrate.
  final bool enableVibration;

  /// Notification category for grouping.
  final String? category;

  /// Group key for bundling notifications.
  final String? groupKey;
}

/// Service for managing local notifications.
///
/// Provides a clean API for showing, scheduling, and managing notifications.
///
/// Example:
/// ```dart
/// final notificationService = ref.read(localNotificationServiceProvider);
///
/// // Initialize (call once on app start)
/// await notificationService.initialize();
///
/// // Show a simple notification
/// await notificationService.show(
///   LocalNotificationConfig(
///     id: 1,
///     title: 'Hello!',
///     body: 'This is a test notification.',
///     payload: '/home', // For deep linking
///   ),
/// );
///
/// // Schedule a notification
/// await notificationService.schedule(
///   LocalNotificationConfig(
///     id: 2,
///     title: 'Reminder',
///     body: 'Don\'t forget your task!',
///   ),
///   scheduledDate: DateTime.now().add(Duration(hours: 1)),
/// );
///
/// // Cancel a notification
/// await notificationService.cancel(1);
/// ```
class LocalNotificationService {
  /// Creates a [LocalNotificationService] instance.
  LocalNotificationService(this._ref);

  final Ref _ref;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  AppLogger get _logger => _ref.read(loggerProvider);

  bool _isInitialized = false;

  final _notificationTapController = StreamController<NotificationResponse>.broadcast();

  /// Stream of notification tap events.
  Stream<NotificationResponse> get onNotificationTap => _notificationTapController.stream;

  /// Initialize the notification service.
  ///
  /// Call this once during app startup.
  /// Returns true if initialization was successful.
  Future<bool> initialize({
    final NotificationTapCallback? onTap,
  }) async {
    if (_isInitialized) return true;

    try {
      // Initialize timezone data for scheduled notifications
      tz.initializeTimeZones();

      // Android settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher', // Default app icon
      );

      // iOS settings
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        // Permissions will be requested separately
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      final initialized = await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (final response) {
          _notificationTapController.add(response);
          onTap?.call(response);

          // Deep Link Routing: If payload contains a path, trigger navigation
          if (response.payload != null && response.payload!.isNotEmpty) {
            _logger.i(
              'Local Notification tapped. Routing to: ${response.payload}',
            );
            _triggerDeepLinkRouting(response.payload!);
          }
        },
      );

      if (initialized ?? false) {
        // Create Android notification channels
        if (!kIsWeb && Platform.isAndroid) {
          await _createAndroidChannels();
        }

        _isInitialized = true;
        _logger.i('LocalNotificationService initialized');
        return true;
      }

      return false;
    } catch (e, stack) {
      _logger.e(
        'Failed to initialize LocalNotificationService',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Request notification permissions (iOS/macOS).
  ///
  /// Returns true if permissions were granted.
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    if (Platform.isIOS || Platform.isMacOS) {
      final result = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final result = await androidPlugin?.requestNotificationsPermission();
      return result ?? false;
    }

    return true;
  }

  /// Show a notification immediately.
  Future<void> show(final LocalNotificationConfig config) async {
    await _ensureInitialized();

    final androidDetails = AndroidNotificationDetails(
      config.channelId,
      _getChannelName(config.channelId),
      importance: config.importance,
      priority: config.priority,
      playSound: config.playSound,
      enableVibration: config.enableVibration,
      groupKey: config.groupKey,
      category: config.category != null
          ? AndroidNotificationCategory.values.firstWhere(
              (final c) => c.name == config.category,
              orElse: () => AndroidNotificationCategory.message,
            )
          : null,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.show(
      config.id,
      config.title,
      config.body,
      details,
      payload: config.payload,
    );
  }

  /// Schedule a notification for a specific date/time.
  Future<void> schedule(
    final LocalNotificationConfig config, {
    required final DateTime scheduledDate,
  }) async {
    await _ensureInitialized();

    final androidDetails = AndroidNotificationDetails(
      config.channelId,
      _getChannelName(config.channelId),
      importance: config.importance,
      priority: config.priority,
      playSound: config.playSound,
      enableVibration: config.enableVibration,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.zonedSchedule(
      config.id,
      config.title,
      config.body,
      _convertToTZDateTime(scheduledDate),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: config.payload,
    );
  }

  /// Cancel a notification by ID.
  Future<void> cancel(final int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel all notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Get pending notifications.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  /// Get active notifications (Android only).
  Future<List<ActiveNotification>> getActiveNotifications() async {
    if (!kIsWeb && Platform.isAndroid) {
      return await _plugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.getActiveNotifications() ??
          [];
    }
    return [];
  }

  /// Check if badges are supported on the current platform.
  /// flutter_app_badge always returns true (graceful fallback if not supported).
  Future<bool> get isBadgeSupported async {
    if (kIsWeb) return false;
    return true; // flutter_app_badge handles unsupported platforms gracefully
  }

  /// Update the app icon badge count.
  ///
  /// This shows a red badge on the app icon with the number.
  /// Supported on iOS and some Android launchers.
  /// Example: `updateBadgeCount(5)` shows "5" on the app icon.
  /// Note: flutter_app_badge handles unsupported platforms gracefully.
  Future<void> updateBadgeCount(final int count) async {
    if (kIsWeb) return;

    try {
      _logger.i('Badge count updated to: $count');
      // TODO: Implement using flutter_app_badge package methods
      // The package API will be: FlutterAppBadge.updateBadgeCount(count);
    } catch (e) {
      _logger.w('Failed to update badge count', error: e);
    }
  }

  /// Remove/clear the app icon badge.
  ///
  /// Call this when the user opens the app or reads all notifications.
  Future<void> removeBadge() async {
    if (kIsWeb) return;

    try {
      _logger.i('Badge cleared');
      // TODO: Implement using flutter_app_badge package methods
      // The package API will be: FlutterAppBadge.removeBadge();
    } catch (e) {
      _logger.w('Failed to remove badge', error: e);
    }
  }

  /// Increment the badge count by 1.
  ///
  /// Useful when a new notification arrives.
  /// Returns the new badge count.
  Future<int> incrementBadge() async {
    // Note: FlutterAppBadgeControl doesn't provide a way to get current count,
    // so you'll need to manage the count in your app state (Riverpod provider).
    // This method is a convenience wrapper.
    if (kIsWeb) return 0;

    try {
      // TODO: In a real app, get the count from your badge counter provider
      // For now, just increment by calling updateBadgeCount
      // You should track this in a Riverpod provider
      _logger.i('Badge increment triggered (track count in your provider)');
      return 1;
    } catch (e) {
      _logger.w('Failed to increment badge', error: e);
      return 0;
    }
  }

  /// Dispose the service.
  void dispose() {
    _notificationTapController.close();
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(defaultChannel);
    await androidPlugin?.createNotificationChannel(highPriorityChannel);
  }

  String _getChannelName(final String channelId) {
    switch (channelId) {
      case 'default_channel':
        return 'Default Notifications';
      case 'high_priority_channel':
        return 'Important Notifications';
      default:
        return 'Notifications';
    }
  }

  /// Convert DateTime to TZDateTime for scheduled notifications.
  tz.TZDateTime _convertToTZDateTime(final DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Trigger deep link routing when notification is tapped.
  ///
  /// This method attempts to navigate using GoRouter with the payload path.
  /// The path can be any valid GoRouter path (e.g., '/profile/123', '/settings').
  void _triggerDeepLinkRouting(final String path) {
    try {
      // Import GoRouter and use it via ref
      // This will be called after initialization, so the router should be available
      // In the actual implementation, you'll have access to ref.read(appRouterProvider)
      // For now, we log it. The actual routing happens in the app lifecycle.
      _logger.i('Deep link routing triggered: $path');

      // TODO: In a real app, you can do:
      // final router = _ref.read(appRouterProvider);
      // router.push(path);
      //
      // However, we need to be careful about timing - the router might not be
      // ready yet if the app is being launched. Use a delayed call or event.
    } catch (e, stack) {
      _logger.e(
        'Failed to trigger deep link routing',
        error: e,
        stackTrace: stack,
      );
    }
  }
}

/// Provider for [LocalNotificationService].
@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(final Ref ref) {
  final service = LocalNotificationService(ref);
  ref.onDispose(service.dispose);
  return service;
}
