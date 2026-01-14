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

## � Constants

**File**: `lib/core/constants/constants.dart`

### `AppConstants`

| Constant             | Value  | Usage                          |
| :------------------- | :----- | :----------------------------- |
| `animationFast`      | 150ms  | Quick transitions              |
| `animationNormal`    | 300ms  | Standard animations            |
| `animationSlow`      | 500ms  | Emphasized animations          |
| `connectTimeout`     | 30s    | HTTP connection timeout        |
| `receiveTimeout`     | 30s    | HTTP receive timeout           |
| `debounceDelay`      | 500ms  | Input debouncing               |
| `defaultPageSize`    | 20     | Pagination page size           |
| `borderRadiusSmall`  | 4.0    | Subtle corners                 |
| `borderRadiusMedium` | 8.0    | Standard corners               |
| `borderRadiusLarge`  | 16.0   | Prominent corners              |
| `buttonHeight`       | 48.0   | Standard button height         |
| `inputHeight`        | 56.0   | Standard input height          |
| `maxContentWidth`    | 600.0  | Content max-width (responsive) |
| `minPasswordLength`  | 8      | Password validation            |
| `emailPattern`       | RegExp | Email validation regex         |
| `phonePattern`       | RegExp | Phone validation regex         |

```dart
// ✅ Correct
Duration(milliseconds: AppConstants.animationNormal.inMilliseconds)
BorderRadius.circular(AppConstants.borderRadiusMedium)

// ❌ Wrong - Magic numbers
Duration(milliseconds: 300)
BorderRadius.circular(8)
```

### `ApiEndpoints`

Pre-defined API endpoint paths:

```dart
ApiEndpoints.login       // '/auth/login'
ApiEndpoints.register    // '/auth/register'
ApiEndpoints.currentUser // '/users/me'
```

### `Assets`

```dart
Assets.logo        // 'assets/images/logo.png'
Assets.imagesPath  // 'assets/images'
```

---

## 🧩 Widgets

**Path**: `lib/core/widgets/`

### Async State Widgets

| Widget                | Purpose                                            |
| :-------------------- | :------------------------------------------------- |
| `AsyncValueWidget<T>` | Handles Riverpod `AsyncValue` (loading/error/data) |
| `LoadingWidget`       | Centered spinner with optional message             |
| `ErrorWidget`         | Error display with retry button                    |
| `EmptyWidget`         | Empty state with icon and action                   |

```dart
AsyncValueWidget<User>(
  value: ref.watch(userProvider),
  data: (user) => Text(user.name),
  // Optional custom loading/error builders
)

LoadingWidget(message: 'Fetching data...')

ErrorWidget(message: 'Failed to load', onRetry: () => ref.invalidate(provider))

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
| `url()`            | URL format                                   |
| `match(getter)`    | Match another field (e.g., confirm password) |
| `strongPassword()` | 8+ chars, upper, lower, digit, special       |

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

## 🧪 Testing

| Type         | When to Write                  |
| :----------- | :----------------------------- |
| Unit Tests   | Repositories, Notifiers, Utils |
| Widget Tests | Reusable widgets, Pages        |

### Mocking

- Use `mocktail`
- Shared mocks in `test/helpers/mocks.dart`
- For `Result<void>`: return `const Success(null)`

```dart
when(() => mockRepo.logout()).thenAnswer((_) async => const Success(null));
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

---

_Built for scalability. Maintained with ❤️._
