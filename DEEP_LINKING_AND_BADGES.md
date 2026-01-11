# Deep Linking Notifications & App Badges

## Overview

This guide covers the two production-ready notification features that elevate your boilerplate from "functional" to "industry standard":

1. **Deep Link Notification Routing** - Tapping notifications intelligently routes to specific screens
2. **App Icon Badges** - Show notification counts on the app icon (iOS & supported Android launchers)

Both features are fully integrated with Riverpod and follow Clean Architecture principles.

---

## Part 1: Deep Link Notification Routing

### Why It Matters

Users expect intelligent behavior from notifications. When they tap a "New Message" notification, they should navigate directly to that message thread—not the home screen. This is table stakes for modern apps.

### How It Works

#### Local Notifications (Always Available)

```dart
// Send notification with deep link path
await notificationService.show(
  LocalNotificationConfig(
    id: 1,
    title: 'New Message',
    body: 'You have a message from John',
    payload: '/chat/user123',  // ← Deep link path
    channelId: 'high_priority_channel',
  ),
);
```

When a user taps this notification:

1. `LocalNotificationService` captures the tap in `onDidReceiveNotificationResponse`
2. The payload (`/chat/user123`) is extracted
3. The app routes to that path using GoRouter

#### Push Notifications (Firebase - Optional)

```dart
// Example FCM payload structure
{
  "notification": {
    "title": "New Order",
    "body": "Order #12345 is ready"
  },
  "data": {
    "path": "/orders/12345",  // ← Deep link path
    "orderId": "12345"
  }
}
```

When implemented with Firebase:

```dart
// In lib/core/notifications/push_notification_service.dart
void _handleMessage(RemoteMessage message) {
  final path = message.data['path'] as String?;
  if (path != null) {
    ref.read(appRouterProvider).push(path);
  }
}
```

### Implementation Details

**LocalNotificationService** (`lib/core/notifications/local_notification_service.dart`):

- `show()` method accepts `payload` parameter for deep link
- Automatically routes when notification is tapped
- Works on app launch (cold start) and when app is running

**PushNotificationService** (`lib/core/notifications/push_notification_service.dart`):

- Stub implementation ready for Firebase integration
- `_setupInteractedMessage()` - Handle notification taps
- `_handleMessage()` - Extract path and route

### Usage Examples

#### Example 1: Route to Settings

```dart
await notificationService.show(
  LocalNotificationConfig(
    id: 1,
    title: 'Action Required',
    body: 'Please verify your account',
    payload: '/settings',
  ),
);
```

#### Example 2: Route to Profile with ID

```dart
await notificationService.show(
  LocalNotificationConfig(
    id: 2,
    title: 'New Follower',
    body: 'Alice started following you',
    payload: '/profile/alice123',  // Dynamic routing
  ),
);
```

#### Example 3: Route to Chat Thread

```dart
await notificationService.show(
  LocalNotificationConfig(
    id: 3,
    title: 'New Message from John',
    body: 'Hey, are you free today?',
    payload: '/chat/john456',
    channelId: 'high_priority_channel',
  ),
);
```

### Handling on App Launch (Cold Start)

When a user taps a notification and the app is terminated:

1. The notification tap is captured by the OS
2. The app launches with the notification payload
3. `LocalNotificationService.initialize()` processes the payload
4. GoRouter automatically navigates to the target route

This happens seamlessly without any extra code needed in `main.dart`.

### Valid Deep Link Paths

Use any valid GoRouter path defined in your app:

```dart
// From lib/app/router/auth_routes.dart
AppRoute.login.path      // '/login'
AppRoute.settings.path   // '/settings'
AppRoute.profile.path    // '/profile/:userId' with params
```

---

## Part 2: App Icon Badges

### Why It Matters

On iOS, the red badge count on the app icon is a critical re-engagement signal. Users check the badge to know if they have unread items without opening the app. This is table stakes for modern UX.

### How It Works

The `BadgeCount` Riverpod provider manages badge state:

```dart
@riverpod
class BadgeCount extends _$BadgeCount {
  @override
  Future<int> build() async => 0;

  // Methods to manipulate badge count
}
```

When badge count changes, it's automatically synced to the app icon using `flutter_app_badger`.

### Supported Platforms

| Platform | Support    | Details                                                |
| -------- | ---------- | ------------------------------------------------------ |
| iOS      | ✅ Full    | Native badge support                                   |
| Android  | ✅ Partial | Works with supported launchers (Samsung, Google, etc.) |
| Web      | ❌ None    | Badge concept doesn't apply                            |
| macOS    | ✅ Full    | Native badge support                                   |

### Usage Examples

#### Example 1: Watch Badge Count in UI

```dart
final badgeCount = ref.watch(badgeCountProvider);

badgeCount.when(
  loading: () => Text('Loading...'),
  error: (e, st) => Text('Error'),
  data: (count) => Text('Notifications: $count'),
);
```

#### Example 2: Increment Badge on New Notification

```dart
// When you show a notification
await notificationService.show(config);

// Increment badge
await ref.read(badgeCountProvider.notifier).increment();
```

#### Example 3: Clear Badge When App Opens

```dart
// In AppLifecycleNotifier
Future<void> onAppResumed() async {
  await ref.read(badgeCountProvider.notifier).clearBadge();
}
```

#### Example 4: Update to Specific Count

```dart
// Set badge to 5
await ref.read(badgeCountProvider.notifier).updateCount(5);

// Add multiple notifications
await ref.read(badgeCountProvider.notifier).addNotifications(3);
```

### Badge Counter API

**Methods:**

```dart
// Increment badge by 1
await badgeCountProvider.notifier.increment();

// Decrement badge by 1 (won't go below 0)
await badgeCountProvider.notifier.decrement();

// Set badge to specific count
await badgeCountProvider.notifier.updateCount(5);

// Clear badge (set to 0)
await badgeCountProvider.notifier.clearBadge();

// Add multiple notifications at once
await badgeCountProvider.notifier.addNotifications(3);

// Increment and return new count
final newCount = await badgeCountProvider.notifier.onNewNotification();

// Reset to 0 (useful for testing)
await badgeCountProvider.notifier.reset();

// Check if badges supported
final supported = await notificationService.isBadgeSupported;
```

### Complete Example: Notification with Badge

```dart
Future<void> handleNewMessage(String senderId, String message) async {
  final notificationService = ref.read(localNotificationServiceProvider);
  final badgeProvider = ref.read(badgeCountProvider.notifier);

  // Show notification with deep link
  await notificationService.show(
    LocalNotificationConfig(
      id: DateTime.now().millisecond,
      title: 'New Message from Alice',
      body: message,
      payload: '/chat/$senderId',
      importance: Importance.high,
      channelId: 'high_priority_channel',
    ),
  );

  // Increment badge count
  final newCount = await badgeProvider.onNewNotification();
  print('Badge count is now: $newCount');
}
```

---

## Integration with Push Notifications (Firebase)

When you enable Firebase Cloud Messaging (FCM), the deep linking works seamlessly:

### Setup Steps

1. **Add Firebase** (if not already done):

   ```bash
   flutterfire configure
   ```

2. **Uncomment Firebase in pubspec.yaml**:

   ```yaml
   firebase_messaging: ^15.0.0
   ```

3. **Implement Push Handler** in `push_notification_service.dart`:

   ```dart
   Future<bool> initialize() async {
     final messaging = FirebaseMessaging.instance;

     // Request iOS permissions
     await messaging.requestPermission(
       alert: true,
       badge: true,
       sound: true,
     );

     // Setup handlers
     _setupInteractedMessage();

     // Listen for foreground messages
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       // Update badge
       ref.read(badgeCountProvider.notifier).increment();
     });

     return true;
   }

   void _handleMessage(RemoteMessage message) {
     final path = message.data['path'] as String?;
     if (path != null) {
       ref.read(appRouterProvider).push(path);
     }
   }
   ```

### FCM Payload Format

```json
{
  "to": "device_token_here",
  "notification": {
    "title": "Order Ready",
    "body": "Your order #123 is ready for pickup"
  },
  "data": {
    "path": "/orders/123",
    "orderId": "123",
    "priority": "high"
  },
  "webpush": {
    "headers": {
      "TTL": "86400"
    }
  }
}
```

---

## Architecture

### Clean Separation

```
Presentation Layer (UI)
  ↓ refs
Notification Services Layer
  ├── LocalNotificationService (shows + routes)
  ├── PushNotificationService (FCM handler)
  └── BadgeCount Provider (state management)
  ↓ uses
Core Services Layer
  ├── GoRouter (navigation)
  ├── flutter_app_badger (badge display)
  └── flutter_local_notifications (OS integration)
```

### Riverpod Integration

```dart
// Badge state is a Riverpod provider
@riverpod
class BadgeCount extends _$BadgeCount {
  // State: int (badge count)
  // Notifier: methods to mutate badge
}

// Notification services use Riverpod
@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(Ref ref) {
  // Can access other providers via ref
  // Non-disposable (app lifecycle service)
}
```

### Error Handling

All badge operations are non-critical and fail gracefully:

```dart
Future<void> updateBadgeCount(int count) async {
  try {
    await FlutterAppBadger.updateBadgeCount(count);
  } catch (e) {
    _logger.w('Failed to update badge', error: e);
    // Continue silently - badge update failing shouldn't crash the app
  }
}
```

---

## Testing

### Unit Tests

```dart
test('badge count increments', () async {
  final container = ProviderContainer();
  final badgeNotifier = container.read(badgeCountProvider.notifier);

  await badgeNotifier.increment();
  final count = container.read(badgeCountProvider);

  expect(count, equals(1));
});

test('badge clears', () async {
  final container = ProviderContainer();
  final badgeNotifier = container.read(badgeCountProvider.notifier);

  await badgeNotifier.updateCount(5);
  await badgeNotifier.clearBadge();

  expect(container.read(badgeCountProvider), equals(0));
});
```

### Widget Tests

```dart
testWidgets('notification deep links to settings', (tester) async {
  await tester.pumpWidget(const MyApp());

  // Simulate notification tap with deep link
  final notificationService = find.byType(LocalNotificationService);
  // Verify navigation occurred
});
```

---

## Common Patterns

### Pattern 1: Background Notification Processing

```dart
// In your notification handler service
Future<void> processNotification(Notification notification) async {
  // Show notification + update badge
  await localNotificationService.show(
    LocalNotificationConfig(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      payload: notification.deepLink,
    ),
  );

  // Sync badge count with backend
  await badgeCountProvider.notifier.updateCount(
    notification.unreadCount,
  );
}
```

### Pattern 2: Clear Badge on Navigation

```dart
// In any navigation callback
void onNavigationComplete(String route) {
  if (route == AppRoute.home.path) {
    ref.read(badgeCountProvider.notifier).clearBadge();
  }
}
```

### Pattern 3: Sync Badge on App Launch

```dart
// In AppLifecycleNotifier.initialize()
Future<void> initialize() async {
  // Get unread count from backend
  final unreadCount = await api.getUnreadCount();

  // Set badge to match server state
  await ref.read(badgeCountProvider.notifier).updateCount(unreadCount);

  // Continue with normal initialization
}
```

### Pattern 4: Dynamic Deep Links with Data

```dart
// Notification with additional data
await notificationService.show(
  LocalNotificationConfig(
    id: 1,
    title: 'New Order',
    body: 'Order #123',
    payload: '/orders/123',
  ),
);

// Route extracts ID from path
// GoRouter navigates to: /orders/123
// Your page can access via: final orderId = ref.watch(orderIdProvider);
```

---

## Troubleshooting

### Badges Not Showing on Android

**Solution**: Only certain launchers support badges (Samsung, Google, Nothing, etc.). Test on:

- Google Pixel (stock Android)
- Samsung device
- Use emulator with Google Play Services

### Notifications Not Routing

**Check**:

1. Is `LocalNotificationService.initialize()` called on app startup?
2. Is the payload a valid GoRouter path?
3. Is the route defined in your router?

```dart
// Verify in AppLifecycleNotifier
await notificationService.initialize();  // ← Must be called

// Verify route exists
AppRoute.settings.path  // ← Must be defined
```

### Badge Persists After Restart

**Solution**: Badge is managed by OS, cleared via:

1. User manually clearing on home screen
2. App call to `removeBadge()`
3. User uninstalling and reinstalling app

Implement badge clearing on app resume:

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    ref.read(badgeCountProvider.notifier).clearBadge();
  }
}
```

---

## Best Practices

✅ **DO**:

- Always clear badge when user opens app (`onAppResumed`)
- Use meaningful, concise payload paths
- Test deep links on real device (iOS badge especially)
- Sync badge count with backend on app launch
- Handle routing gracefully if path is invalid

❌ **DON'T**:

- Rely on badges as primary UX (they can be disabled)
- Use complex logic in `_handleMessage()` - keep it simple
- Forget to initialize notification service
- Ignore badge update failures
- Use web-style deep links (`http://example.com/path`) - use app-only paths

---

## Production Checklist

- [ ] Local notifications working with deep links
- [ ] Badge count increments on new notification
- [ ] Badge clears when user opens app
- [ ] Tested on iOS device (badge display)
- [ ] Tested on Android device (if badge supported)
- [ ] Firebase Cloud Messaging configured (if using push)
- [ ] All deep link routes are valid in GoRouter
- [ ] Error logging in place for badge failures
- [ ] Unit tests for badge counter provider
- [ ] Documentation updated for team

---

## Related Files

| File                                                          | Purpose                                     |
| ------------------------------------------------------------- | ------------------------------------------- |
| `lib/core/notifications/local_notification_service.dart`      | Show notifications + route on tap           |
| `lib/core/notifications/push_notification_service.dart`       | Firebase integration (stub)                 |
| `lib/core/notifications/badge_counter.dart`                   | Riverpod badge state management             |
| `lib/app/startup/app_lifecycle_notifier.dart`                 | Initialize services + clear badge on resume |
| `lib/features/home/presentation/pages/home_page.dart`         | Demo notification with deep link            |
| `lib/features/settings/presentation/pages/settings_page.dart` | Demo badge management                       |

---

## Next Steps

1. **Test locally** - Send notifications with payload, verify routing works
2. **Add Firebase** - Follow Firebase setup if you need push notifications
3. **Track unread count** - Sync badge with backend unread count on launch
4. **User preferences** - Let users disable badges if desired
5. **Analytics** - Track notification tap rates and deep link usage
