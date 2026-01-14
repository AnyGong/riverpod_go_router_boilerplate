# 📘 Developer Guide

**Welcome to the codebase!** 👋

This guide documents **every reusable component** in the boilerplate. Use these utilities to maintain consistency, reduce code, and build professional apps faster.

---

## Table of Contents

- [🏗️ Architecture](#-architecture)
- [📦 Constants](#-constants)
- [🧩 Widgets](#-widgets)
- [🔧 Utilities](#-utilities)
- [🎨 Extensions](#-extensions)
- [🪝 Hooks](#-hooks)
- [📋 Forms](#-forms)
- [🌐 Services](#-services)
- [👷 Workflow](#-workflow)
- [⚡ State Management](#-state-management)
- [🔐 Security](#-security)
- [🧪 Testing](#-testing)
- [❓ FAQ](#-faq)

---

## 🏗️ Architecture

We follow **Feature-First Clean Architecture**. Every feature has:

```
lib/features/<feature_name>/
├── data/          # Repository implementations, DTOs
├── domain/        # Entities, Repository interfaces
└── presentation/  # Pages, Widgets, Providers (Notifiers)
```

**Dependency Rule**: Domain → pure Dart, Data → implements Domain, Presentation → uses both.

---

## 📦 Constants

**Path**: `lib/core/constants/`

The constants are organized into separate files for better maintainability:

| File                 | Purpose                            |
| :------------------- | :--------------------------------- |
| `app_constants.dart` | Durations, dimensions, validation  |
| `api_endpoints.dart` | All API endpoint paths             |
| `assets.dart`        | Image, icon, animation asset paths |
| `storage_keys.dart`  | Secure storage and prefs keys      |

### `AppConstants`

**File**: `lib/core/constants/app_constants.dart`

| Constant            | Value  | Usage                          |
| :------------------ | :----- | :----------------------------- |
| `animationFast`     | 150ms  | Quick transitions              |
| `animationNormal`   | 300ms  | Standard animations            |
| `animationSlow`     | 500ms  | Emphasized animations          |
| `connectTimeout`    | 30s    | HTTP connection timeout        |
| `receiveTimeout`    | 30s    | HTTP receive timeout           |
| `debounceDelay`     | 500ms  | Input debouncing               |
| `defaultPageSize`   | 20     | Pagination page size           |
| `borderRadiusSM`    | 4.0    | Subtle corners                 |
| `borderRadiusMD`    | 8.0    | Standard corners               |
| `borderRadiusLG`    | 12.0   | Prominent corners              |
| `borderRadiusXL`    | 16.0   | Very rounded corners           |
| `buttonHeight`      | 48.0   | Standard button height         |
| `inputHeight`       | 56.0   | Standard input height          |
| `maxContentWidth`   | 600.0  | Content max-width (responsive) |
| `minPasswordLength` | 8      | Password validation            |
| `emailPattern`      | RegExp | Email validation regex         |

```dart
// ✅ Correct
Duration(milliseconds: AppConstants.animationNormal.inMilliseconds)
BorderRadius.circular(AppConstants.borderRadiusMD)

// ❌ Wrong - Magic numbers
Duration(milliseconds: 300)
BorderRadius.circular(8)
```

### `ApiEndpoints`

**File**: `lib/core/constants/api_endpoints.dart`

Pre-defined API endpoint paths organized by feature:

```dart
// Auth
ApiEndpoints.login            // '/auth/login'
ApiEndpoints.register         // '/auth/register'
ApiEndpoints.logout           // '/auth/logout'
ApiEndpoints.refreshToken     // '/auth/refresh'
ApiEndpoints.forgotPassword   // '/auth/forgot-password'

// User
ApiEndpoints.currentUser      // '/users/me'
ApiEndpoints.updateProfile    // '/users/me'
ApiEndpoints.changePassword   // '/users/me/password'

// Notifications
ApiEndpoints.notifications    // '/notifications'
ApiEndpoints.registerDevice   // '/notifications/device'
```

### `Assets` & `AppIcons`

**File**: `lib/core/constants/assets.dart`

```dart
// Images
Assets.logo                   // 'assets/images/logo.png'
Assets.placeholder            // 'assets/images/placeholder.png'
Assets.emptyState             // 'assets/images/empty_state.png'
Assets.onboarding.page1       // 'assets/images/onboarding_1.png'

// Animations (Lottie)
Assets.loadingAnimation       // 'assets/animations/loading.json'
Assets.successAnimation       // 'assets/animations/success.json'

// Icons (SVG)
AppIcons.home                 // 'assets/icons/home.svg'
AppIcons.settings             // 'assets/icons/settings.svg'
AppIcons.google               // 'assets/icons/google.svg'
```

### `StorageKeys`

**File**: `lib/core/constants/storage_keys.dart`

Centralized storage keys for secure storage and shared preferences:

| Category          | Keys                                                   |
| :---------------- | :----------------------------------------------------- |
| **Auth**          | `accessToken`, `refreshToken`, `tokenExpiry`, `userId` |
| **Preferences**   | `themeMode`, `locale`, `notificationsEnabled`          |
| **App State**     | `onboardingCompleted`, `launchCount`, `hasRatedApp`    |
| **Cache**         | `cachedUserProfile`, `lastSyncTimestamp`               |
| **Notifications** | `fcmToken`, `badgeCount`, `lastNotificationRead`       |

```dart
await secureStorage.write(key: StorageKeys.accessToken, value: token);
final token = await secureStorage.read(key: StorageKeys.accessToken);
```

### `PrefsKeys`

Non-sensitive shared preferences keys:

```dart
PrefsKeys.lastTabIndex       // UI state
PrefsKeys.recentSearches     // Search history
PrefsKeys.shownTooltips      // Feature discovery
```

---

## 🧩 Widgets

**Path**: `lib/core/widgets/`

### Async State Widgets

| Widget                | Purpose                                            |
| :-------------------- | :------------------------------------------------- |
| `AsyncValueWidget<T>` | Handles Riverpod `AsyncValue` (loading/error/data) |
| `LoadingWidget`       | Centered spinner with optional message             |
| `AppErrorWidget`      | Error display with retry button                    |
| `EmptyWidget`         | Empty state with icon and action                   |

```dart
AsyncValueWidget<User>(
  value: ref.watch(userProvider),
  data: (user) => Text(user.name),
  // Optional custom loading/error builders
)

LoadingWidget(message: 'Fetching data...')

AppErrorWidget(message: 'Failed to load', onRetry: () => ref.invalidate(provider))

// Or use the factory constructor for exception handling:
AppErrorWidget.fromError(
  error: exception,
  onRetry: () => ref.invalidate(provider),
)

EmptyWidget(
  message: 'No items yet',
  actionLabel: 'Add Item',
  action: () => context.go('/add'),
)
```

### Buttons

| Widget          | Variants                                        |
| :-------------- | :---------------------------------------------- |
| `AppButton`     | `primary`, `secondary`, `text`                  |
| `AppIconButton` | `standard`, `filled`, `outlined`, `filledTonal` |

```dart
AppButton(
  label: 'Submit',
  onPressed: _submit,
  isLoading: isSubmitting,
  variant: AppButtonVariant.primary,
  size: AppButtonSize.medium, // small, medium, large
)

AppIconButton(
  icon: Icons.add,
  onPressed: _add,
  variant: AppIconButtonVariant.filled,
)
```

**Important**: Always use explicit enum values like `AppButtonVariant.primary` instead of `.primary` for better code clarity.

### Spacing

**NEVER use magic numbers for spacing!**

| Class               | Description                                                          |
| :------------------ | :------------------------------------------------------------------- |
| `AppSpacing`        | Constants: `xs(4)`, `sm(8)`, `md(16)`, `lg(24)`, `xl(32)`, `xxl(48)` |
| `HorizontalSpace`   | Horizontal gap widget                                                |
| `VerticalSpace`     | Vertical gap widget                                                  |
| `ResponsivePadding` | Symmetric padding wrapper                                            |
| `ContentContainer`  | Centered max-width container                                         |

```dart
// ✅ Correct
VerticalSpace.md()         // 16px vertical gap
HorizontalSpace.sm()       // 8px horizontal gap
Padding(padding: EdgeInsets.all(AppSpacing.lg))

// ❌ Wrong
SizedBox(height: 16)
Padding(padding: EdgeInsets.all(24))
```

### Other Widgets

| Widget                | Purpose                                          |
| :-------------------- | :----------------------------------------------- |
| `CachedImage`         | Network image with caching & shimmer placeholder |
| `ConnectivityWrapper` | Shows offline banner when disconnected           |
| `ResponsiveBuilder`   | Adaptive layout (mobile/tablet/desktop)          |
| `ShimmerLoading`      | Skeleton loading effect                          |

```dart
CachedImage(imageUrl: user.avatarUrl, height: 100, width: 100)

ConnectivityWrapper(child: MyPage())

ResponsiveBuilder(
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

### Input Widgets

| Widget           | Purpose                                   |
| :--------------- | :---------------------------------------- |
| `AppTextField`   | Styled text field with consistent styling |
| `AppSearchField` | Search input with clear button            |
| `AppChip`        | Filter/input chips                        |
| `AppBadge`       | Count/status badges                       |
| `AppDivider`     | Divider with optional label               |
| `StatusDot`      | Status indicator (online/offline/busy)    |

```dart
AppTextField(
  label: 'Email',
  prefixIcon: Icons.email,
  validator: Validators.email(),
)

AppSearchField(
  controller: searchController,
  onChanged: (query) => ref.read(searchProvider.notifier).search(query),
)

AppChip(
  label: 'Flutter',
  selected: isSelected,
  onSelected: (selected) => toggleFilter('flutter'),
)

AppBadge(
  count: notificationCount,
  child: Icon(Icons.notifications),
)

StatusDot.online()  // Green pulsing dot
StatusDot.busy()    // Red dot
```

### Dialogs & Bottom Sheets

**File**: `lib/core/widgets/dialogs.dart`

| Helper                 | Purpose                          |
| :--------------------- | :------------------------------- |
| `AppDialogs.confirm()` | Confirmation dialog              |
| `AppDialogs.alert()`   | Simple alert                     |
| `AppDialogs.error()`   | Error dialog with icon           |
| `AppDialogs.success()` | Success dialog with icon         |
| `AppDialogs.input()`   | Input dialog with validation     |
| `AppDialogs.select()`  | Selection dialog                 |
| `AppDialogs.loading()` | Loading dialog (returns dismiss) |

```dart
final confirmed = await AppDialogs.confirm(
  context,
  title: 'Delete Item',
  message: 'This action cannot be undone.',
  isDangerous: true,
);

if (confirmed == true) {
  await deleteItem();
}

// Input dialog
final name = await AppDialogs.input(
  context,
  title: 'Rename',
  initialValue: currentName,
  validator: Validators.required(),
);

// Loading dialog
final dismiss = AppDialogs.loading(context, message: 'Saving...');
await saveData();
dismiss();
```

**Bottom Sheets:**

```dart
AppBottomSheets.confirm(
  context,
  title: 'Sign Out',
  message: 'Are you sure?',
);

AppBottomSheets.actions<String>(
  context,
  title: 'Options',
  actions: [
    BottomSheetAction(value: 'edit', label: 'Edit', icon: Icons.edit),
    BottomSheetAction(value: 'delete', label: 'Delete', icon: Icons.delete, isDestructive: true),
  ],
);
```

### Animation Widgets

**File**: `lib/core/widgets/animations.dart`

| Widget          | Purpose                        |
| :-------------- | :----------------------------- |
| `FadeIn`        | Fade in on mount               |
| `SlideIn`       | Slide in from direction        |
| `ScaleIn`       | Scale in on mount              |
| `StaggeredList` | Staggered list item animations |
| `ShakeWidget`   | Shake effect (for errors)      |
| `Pulse`         | Pulsing animation              |

```dart
// Automatic fade-in animation
FadeIn(
  duration: AppConstants.animationNormal,
  delay: 100.ms,
  child: Text('Hello'),
)

// Slide from bottom
SlideIn(
  direction: SlideDirection.fromBottom,
  child: Card(...),
)

// Staggered list
StaggeredList(
  staggerDelay: 50.ms,
  children: items.map((item) => ItemCard(item)).toList(),
)

// Shake on error
final shakeController = ShakeController();
ShakeWidget(
  controller: shakeController,
  child: TextField(...),
)
// Trigger: shakeController.shake();
```

---

## 🔧 Utilities

**Path**: `lib/core/utils/`

### Validators

Composable form validators:

```dart
// Single validator
TextFormField(validator: Validators.required())

// Composed validators (first error wins)
TextFormField(
  validator: Validators.compose([
    Validators.required('Email is required'),
    Validators.email('Invalid email format'),
  ]),
)
```

| Validator          | Purpose                                      |
| :----------------- | :------------------------------------------- |
| `required()`       | Non-empty check                              |
| `email()`          | Email format                                 |
| `minLength(n)`     | Minimum characters                           |
| `maxLength(n)`     | Maximum characters                           |
| `exactLength(n)`   | Exact characters                             |
| `pattern(regex)`   | Custom regex                                 |
| `numeric()`        | Digits only                                  |
| `phone()`          | Phone format                                 |
| `url()`            | URL format (requires http/https scheme)      |
| `match(getter)`    | Match another field (e.g., confirm password) |
| `strongPassword()` | 8+ chars, upper, lower, digit, special       |

**Important Notes:**

- `strongPassword()` already includes minimum 8 character requirement. Don't add redundant `minLength(8)` validators.
- `url()` validates that the URL has a scheme (http/https) and authority component.

### Logger

```dart
final logger = ref.read(loggerProvider);
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message', error: exception, stackTrace: stack);
```

### Pagination

```dart
final pagination = PaginationController<Product>(
  fetcher: (page, limit) => repo.getProducts(page, limit),
);
```

---

## 🎨 Extensions

**Path**: `lib/core/extensions/`

### BuildContext Extensions

```dart
// Theme
context.theme           // ThemeData
context.colorScheme     // ColorScheme
context.textTheme       // TextTheme
context.isDarkMode      // bool

// Screen
context.screenWidth     // double
context.screenHeight    // double
context.isMobile        // < 600
context.isTablet        // 600-1024
context.isDesktop       // >= 1024

// Responsive helper
context.responsive<Widget>(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)

// Navigation
context.pop()
context.canPop

// Focus
context.unfocus()       // Dismiss keyboard

// Snackbar
context.showSnackBar('Message')
context.showErrorSnackBar('Error!')
context.showSuccessSnackBar('Success!')
```

### String Extensions

```dart
'hello'.capitalized         // 'Hello'
'hello world'.titleCase     // 'Hello World'
'test@email.com'.isValidEmail // true
'  '.isBlank                // true
'hello world'.truncate(8)   // 'hello...'
'Hello World'.toSlug        // 'hello-world'
```

### DateTime Extensions

```dart
DateTime.now().formatMedium    // 'Jan 1, 2024'
DateTime.now().formatShort     // '1/1/2024'
DateTime.now().formatTime      // '10:30 AM'
DateTime.now().formatDateTime  // 'Jan 1, 2024 10:30 AM'
DateTime.now().isToday         // true
DateTime.now().timeAgo         // '2 hours ago'
```

### Nullable Extensions

```dart
String? name;
name.isNullOrEmpty     // true
name.orEmpty           // ''
name.orDefault('N/A')  // 'N/A'
```

### Number Extensions

**File**: `lib/core/extensions/num_extensions.dart`

```dart
// Formatting
1234567.formatted              // '1,234,567'
1234567.89.compactFormatted    // '1.2M'
0.1234.toPercentage()          // '12.34%'
99.99.toCurrency()             // '$99.99'
99.99.toCurrency('€')          // '€99.99'

// File sizes
1024.toFileSize()              // '1.0 KB'
1048576.toFileSize()           // '1.0 MB'

// Time formatting
125.toMinutesSeconds()         // '02:05'
3665.toHoursMinutesSeconds()   // '01:01:05'

// Clamping
150.clampPercentage            // 100.0
(-5).clampPercentage           // 0.0

// Duration shortcuts (works with int and double)
5.seconds                      // Duration(seconds: 5)
500.ms                         // Duration(milliseconds: 500)
2.5.minutes                    // Duration(seconds: 150)

// Spacing shortcuts
16.h                           // SizedBox(height: 16)
8.w                            // SizedBox(width: 8)
```

### Iterable Extensions

**File**: `lib/core/extensions/iterable_extensions.dart`

```dart
// Safe access
[1, 2, 3].firstOrNull          // 1
[].firstOrNull                 // null
[1, 2, 3].lastOrNull           // 3

// Grouping & Chunking
users.groupBy((u) => u.role)   // Map<Role, List<User>>
[1, 2, 3, 4, 5].chunk(2)       // [[1, 2], [3, 4], [5]]

// Filtering
[1, 2, 2, 3, 3].distinct()     // [1, 2, 3]
users.distinctBy((u) => u.id)  // Unique by ID

// Finding
users.maxBy((u) => u.score)    // User with highest score
users.minBy((u) => u.age)      // User with lowest age

// Transformations
users.associate((u) => MapEntry(u.id, u))  // Map<int, User>
users.sortedBy((u) => u.name)              // Sorted copy
users.sortedByDescending((u) => u.score)   // Descending sort

// Conditional
items.takeWhileInclusive((i) => i < 5)  // Includes boundary element
```

### Duration Extensions

**File**: `lib/core/extensions/duration_extensions.dart`

```dart
// Formatting
Duration(seconds: 125).formatHHMMSS    // '00:02:05'
Duration(seconds: 3665).formatHHMMSS   // '01:01:05'
Duration(minutes: 5).formatCompact     // '5m'
Duration(hours: 2, minutes: 30).formatCompact  // '2h 30m'

// Time from now/ago
Duration(hours: 2).fromNow             // DateTime 2 hours from now
Duration(days: 1).ago                  // DateTime 1 day ago

// Comparison
Duration(seconds: 30).isLongerThan(Duration(seconds: 20))  // true
Duration(seconds: 10).isShorterThan(Duration(seconds: 20)) // true

// Rounding
Duration(seconds: 125).roundToMinutes  // Duration(minutes: 2)
Duration(minutes: 45).roundToHours     // Duration(hours: 1)
```

---

## 🪝 Hooks

**Path**: `lib/core/hooks/`

Use in `HookWidget` classes only.

| Hook                        | Purpose                 |
| :-------------------------- | :---------------------- |
| `useDebounce(value, delay)` | Debounced value         |
| `useToggle(initial)`        | Boolean toggle state    |
| `usePreviousValue(value)`   | Previous render's value |
| `useAsyncState<T>()`        | Async operation state   |
| `useCountdown(duration)`    | Countdown timer         |
| `usePagination(fetcher)`    | Infinite scroll helper  |
| `useFormState()`            | Lightweight form state  |

```dart
class MyPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final (isVisible, toggleVisible) = useToggle(false);
    final searchDebounced = useDebounce(searchText, 500.ms);

    return ...;
  }
}
```

---

## 📋 Forms

**Path**: `lib/core/forms/`

We use `reactive_forms` for complex forms. Pre-built form groups:

```dart
// Auth forms
final loginForm = AuthForms.login();  // email + password
final registerForm = AuthForms.register();  // name + email + password + confirm

// Common forms
final profileForm = CommonForms.profile();  // name + email + phone + bio
```

Custom validators for `reactive_forms`:

```dart
FormControl<String>(validators: [
  CustomValidators.required,
  CustomValidators.email,
  CustomValidators.strongPassword,
])
```

---

## 🌐 Services

### Network (`lib/core/network/`)

| Service            | Purpose                                |
| :----------------- | :------------------------------------- |
| `ApiClient`        | Type-safe HTTP client with `Result<T>` |
| `dioProvider`      | Pre-configured Dio instance            |
| `CacheInterceptor` | ETag-based caching                     |

```dart
final result = await apiClient.get<User>(
  '/users/1',
  fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
);

result.fold(
  onSuccess: (user) => print(user.name),
  onFailure: (error) => print(error.message),
);
```

#### Auth Interceptor

The `AuthInterceptor` handles token injection and automatic refresh:

- Automatically injects `Authorization: Bearer <token>` header
- Handles 401 responses with automatic token refresh
- Uses `Completer` for concurrent request coordination (prevents multiple simultaneous refresh calls)
- Failed requests are automatically retried after successful token refresh

### Storage (`lib/core/storage/`)

| Provider                    | Purpose                     |
| :-------------------------- | :-------------------------- |
| `secureStorageProvider`     | Encrypted key-value storage |
| `sharedPreferencesProvider` | Non-sensitive preferences   |

Storage Keys:

```dart
StorageKeys.accessToken       // 'access_token'
StorageKeys.refreshToken      // 'refresh_token'
StorageKeys.userId            // 'user_id'
StorageKeys.onboardingCompleted // 'onboarding_completed'
```

### Other Services

| Service                    | Purpose                 |
| :------------------------- | :---------------------- |
| `BiometricService`         | Face ID / Touch ID      |
| `LocalNotificationService` | Local notifications     |
| `PermissionService`        | Runtime permissions     |
| `FeedbackService`          | Context-free snackbars  |
| `DeepLinkService`          | Universal link handling |
| `InAppReviewService`       | App store reviews       |
| `CrashlyticsService`       | Crash reporting         |
| `AnalyticsService`         | User analytics          |
| `PerformanceService`       | Performance monitoring  |
| `RemoteConfigService`      | Feature flags & config  |

### Firebase Suite (`lib/core/`)

The boilerplate includes a complete Firebase integration:

#### Crashlytics (`lib/core/crashlytics/`)

```dart
// Record non-fatal errors
ref.read(crashlyticsServiceProvider).recordError(
  exception,
  stackTrace,
  reason: 'API call failed',
);

// Log breadcrumbs
ref.read(crashlyticsServiceProvider).log('User tapped checkout');

// Set user identifier
ref.read(crashlyticsServiceProvider).setUserId('user_123');
```

#### Analytics (`lib/core/analytics/`)

```dart
final analytics = ref.read(analyticsServiceProvider);

// Predefined events
await analytics.logLogin(method: 'email');
await analytics.logSignUp(method: 'google');
await analytics.logSearch(searchTerm: 'shoes');
await analytics.logPurchase(
  transactionId: 'txn_123',
  value: 99.99,
  currency: 'USD',
);

// Custom events (use constants from AnalyticsEvents)
await analytics.logEvent(
  AnalyticsEvents.featureUsed,
  parameters: {'feature': 'dark_mode'},
);

// User properties (use constants from AnalyticsUserProperties)
await analytics.setUserProperty(
  AnalyticsUserProperties.subscriptionTier,
  'premium',
);
```

#### Performance Monitoring (`lib/core/performance/`)

```dart
final performance = ref.read(performanceServiceProvider);

// Trace async operations
final result = await performance.traceAsync(
  'checkout_flow',
  () => processCheckout(),
  attributes: {'payment_method': 'credit_card'},
  metrics: {'items_count': 5},
);

// Manual traces for fine-grained control
final trace = await performance.startTrace('image_upload');
trace?.putAttribute('image_type', 'profile');
// ... perform operation ...
await trace?.stop();

// HTTP metrics are automatic via PerformanceHttpInterceptor
// Screen traces are automatic via PerformanceRouteObserver
```

#### Remote Config (`lib/core/remote_config/`)

```dart
final remoteConfig = ref.read(remoteConfigServiceProvider);

// Feature flags
final isFeatureEnabled = remoteConfig.getBool(RemoteConfigKeys.newFeatureEnabled);
final apiVersion = remoteConfig.getString(RemoteConfigKeys.apiVersion);
final maxRetries = remoteConfig.getInt(RemoteConfigKeys.maxApiRetries);

// Force update check
if (remoteConfig.isForceUpdateRequired) {
  final minVersion = remoteConfig.minAppVersion;
  // Show force update dialog
}

// Maintenance mode
if (remoteConfig.isMaintenanceMode) {
  // Show maintenance screen
}

// Fetch latest config
await remoteConfig.fetchAndActivate();

// Real-time updates
remoteConfig.listenForUpdates((updatedKeys) {
  if (updatedKeys.contains(RemoteConfigKeys.maintenanceMode)) {
    // Handle maintenance mode change
  }
});
```

#### Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Add your Android and iOS apps
3. Download configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
4. Run `flutterfire configure` to generate `firebase_options.dart`
5. Uncomment initialization in `lib/app/bootstrap.dart`

---

## 👷 Workflow

### Creating a New Feature

**Always use the generator!**

```bash
make feature NAME=profile
```

This creates the correct folder structure with placeholder files.

### Implementation Steps

1. **Define Entity** in `domain/entities/`
2. **Define Repository Interface** in `domain/repositories/`
3. **Implement Repository** in `data/repositories/`
4. **Create Provider** in `presentation/providers/`
5. **Build Page** in `presentation/pages/`
6. **Add Route** to `lib/app/router/app_router.dart`

### Build Commands

```bash
make gen       # Run code generation (build_runner + l10n)
make format    # Format code & apply fixes
make lint      # Run static analysis
make test      # Run all tests
make prepare   # Full setup (clean + l10n + gen)
```

---

## ⚡ State Management

Use **Riverpod Generator** for all providers.

### Patterns

```dart
// Read-only / Async data
@riverpod
Future<User> fetchUser(FetchUserRef ref, int id) async {
  final repo = ref.watch(userRepositoryProvider);
  final result = await repo.getUser(id);
  return result.getOrThrow();
}

// Mutable state
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}
```

### keepAlive Guidelines

Use `@Riverpod(keepAlive: true)` **ONLY** for:

- Global app state (auth, theme, user preferences)
- Expensive services (network clients, database connections)
- State that must survive navigation (audio player, download manager)

**Default to autoDispose** for page-specific providers.

### UI Consumption

```dart
class UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(fetchUserProvider(1));

    return AsyncValueWidget<User>(
      value: userAsync,
      data: (user) => Text(user.name),
    );
  }
}
```

---

## 🔐 Security

### Secure Storage

The boilerplate uses `FlutterSecureStorage` for sensitive data like tokens and credentials.

#### iOS Keychain Behavior

**Important**: iOS Keychain data persists across app reinstalls. This can cause issues where stale tokens from a previous install are used after a fresh install.

The `FreshInstallHandler` addresses this:

```dart
// In bootstrap.dart - automatically clears stale keychain data
await FreshInstallHandler.handleFreshInstall(secureStorage, sharedPrefs);
```

How it works:

1. On first launch, stores a marker in SharedPreferences
2. SharedPreferences is cleared on uninstall (unlike Keychain)
3. If marker is missing but Keychain has data → fresh install detected
4. Clears all Keychain data to prevent auth issues

#### Platform-Specific Configuration

**iOS:**

- Keychain accessibility: `first_unlock_this_device`
- Data only accessible after first device unlock

**Android:**

- Uses EncryptedSharedPreferences
- Encrypted at rest

### Network Security

- Auth tokens injected automatically via `AuthInterceptor`
- 401 responses trigger automatic token refresh
- Uses `Completer` coordination to prevent multiple simultaneous refresh calls
- Failed requests retry automatically with exponential backoff

---

## 🧪 Testing

| Type         | When to Write                  |
| :----------- | :----------------------------- |
| Unit Tests   | Repositories, Notifiers, Utils |
| Widget Tests | Reusable widgets, Pages        |

### Test File Organization

```
test/
├── core/
│   ├── validators_test.dart    # Utility tests
│   └── widgets_test.dart       # Core widget tests
├── features/
│   └── auth/
│       └── auth_repository_test.dart
├── helpers/
│   └── mocks.dart              # Shared mock classes
└── widget_test.dart
```

### Mocking

- Use `mocktail` for all mocking
- Shared mocks in `test/helpers/mocks.dart`
- For `Result<void>`: return `const Success(null)`

```dart
// In mocks.dart
class MockAuthRepository extends Mock implements AuthRepository {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class MockApiClient extends Mock implements ApiClient {}

// In test file
when(() => mockRepo.logout()).thenAnswer((_) async => const Success(null));
```

### Widget Testing Pattern

```dart
testWidgets('AppButton shows loading state', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AppButton(
        label: 'Submit',
        onPressed: () {},
        isLoading: true,
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Submit'), findsNothing);
});
```

---

## ❓ FAQ

**Q: Where do I configure API URLs?**
A: `lib/config/env_config.dart`

**Q: How do I add a new route?**
A: Add to `AppRoute` enum in `lib/app/router/app_router.dart`

**Q: How do I show a snackbar from a provider?**
A: Use `FeedbackService` or `context.showSnackBar()` from UI

**Q: I have a lint error.**
A: Run `make format`. If it persists, read the error message.

**Q: Why is `ErrorWidget` renamed to `AppErrorWidget`?**
A: To avoid collision with Flutter's built-in `ErrorWidget` class.

**Q: Why does `strongPassword()` not need `minLength(8)`?**
A: The `strongPassword()` validator already includes the 8-character minimum requirement.

**Q: How do I handle fresh install on iOS?**
A: The `FreshInstallHandler` automatically clears stale Keychain data on fresh installs.

---

_Built for scalability. Maintained with ❤️._
