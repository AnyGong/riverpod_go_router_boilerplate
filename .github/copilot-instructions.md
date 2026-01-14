# Flutter Boilerplate AI Instructions

You are an expert Flutter developer working on a production-grade boilerplate project. Your goal is to maintain the highest standards of code quality, architecture, and maintainability.

**Reference**: For detailed documentation of all reusable components, see `DEVELOPER_GUIDE.md`.

---

## ⚠️ Critical: Architectural Constraints

You must strictly adhere to the following file size limits to ensure maintainability. If a file exceeds these limits, you **MUST** refactor it immediately by extracting widgets, configuration, or logic into separate files.

| File Type            | Max Lines     | Action if Exceeded                              |
| -------------------- | ------------- | ----------------------------------------------- |
| **Services / Logic** | **200 lines** | Extract configs, enums, or sub-services.        |
| **UI Widgets**       | **250 lines** | Extract private widgets or separate components. |
| **Test Files**       | ~300 lines    | Split by test group if possible (flexible).     |

**Never** bypass these limits. If you write code that exceeds them, stop and refactor.

---

## 🏗️ Project Architecture

This project follows a **Feature-First Clean Architecture** with **Riverpod** for state management.

### Directory Structure

```
lib/
├── app/                    # App-level setup
│   ├── router/             # GoRouter configuration & routes
│   └── startup/            # App lifecycle & startup state machine
├── config/                 # Environment configuration
├── core/                   # Shared utilities & foundational code
│   ├── analytics/          # Firebase Analytics
│   ├── biometric/          # Biometric authentication
│   ├── cache/              # Offline-first caching (Drift)
│   ├── constants/          # App-wide constants
│   ├── crashlytics/        # Firebase Crashlytics
│   ├── extensions/         # Dart/Flutter extensions
│   ├── forms/              # Reactive Forms configurations
│   ├── hooks/              # Flutter Hooks utilities
│   ├── network/            # Dio, interceptors, API client
│   ├── notifications/      # Local notifications
│   ├── performance/        # Firebase Performance
│   ├── permissions/        # Permission handling
│   ├── remote_config/      # Firebase Remote Config
│   ├── result/             # Result monad for error handling
│   ├── session/            # Session state management
│   ├── storage/            # Secure storage utilities
│   ├── theme/              # App theming
│   ├── utils/              # Validators, logger, etc.
│   └── widgets/            # Reusable UI components
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   ├── home/               # Home feature
│   ├── onboarding/         # Onboarding feature
│   └── settings/           # Settings feature
└── l10n/                   # Localization files
```

### Feature Module Structure

Each feature **MUST** follow this structure:

```
features/<feature_name>/
├── data/               # Data layer
│   └── repositories/   # Repository implementations
├── domain/             # Domain layer
│   ├── entities/       # Business objects
│   └── repositories/   # Repository interfaces
└── presentation/       # Presentation layer
    ├── pages/          # Full screens
    ├── widgets/        # Feature-specific widgets
    └── providers/      # Riverpod Notifiers
```

---

## 🔄 State Management (Riverpod)

### Rules

- **Mandatory**: Use **Riverpod** for all state management.
- **Code Generation**: Use `@riverpod` / `@Riverpod(keepAlive: true)`.
- **Logic Location**: Business logic resides in **Notifiers** (Presentation) or **Services** (Domain/Data).
- **UI Role**: Widgets only `watch` state and `read` methods. No complex logic in `build()`.
- **Avoid**: `StatefulWidget` for logic (use only for animation/input controllers).

### keepAlive Guidelines

Use `@Riverpod(keepAlive: true)` **ONLY** for:

- Global app state (auth, theme, user preferences)
- Expensive services (network clients, database connections)
- State that must survive navigation (audio player, download manager)

**Default to autoDispose** for page-specific providers.

### Example Provider

```dart
@riverpod
class MyFeatureNotifier extends _$MyFeatureNotifier {
  @override
  Future<MyData> build() async {
    final repo = ref.watch(myRepositoryProvider);
    return repo.fetchData();
  }

  Future<void> doSomething() async {
    state = const AsyncLoading();
    final result = await ref.read(myRepositoryProvider).doAction();
    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
```

---

## 🛣️ Routing (GoRouter)

- Use **GoRouter** for all navigation.
- Define routes in `lib/app/router/`.
- Use `AppRoute` enum for type-safe route paths.

### Route Navigation

```dart
// Using extension methods (preferred)
context.goRoute(AppRoute.home);
context.pushRoute(AppRoute.settings);

// With parameters
context.goRouteWith(AppRoute.productDetail, {'id': '123'});

// Standard GoRouter (also works)
context.go('/home');
context.push('/settings');
```

### Adding New Routes

1. Add enum entry to `AppRoute` in `app_router.dart`
2. Create route definition in appropriate file (`auth_routes.dart`, `protected_routes.dart`)
3. Set `requiresAuth` appropriately

---

## 📋 Forms

- Use **`reactive_forms`** for all complex form handling.
- Use pre-built form groups from `lib/core/forms/` (e.g., `AuthForms.login()`).
- Validation logic should be reusable (e.g., `lib/core/utils/validators.dart`).

---

## 📦 Mandatory Reusable Components

**You MUST use these existing components. Do NOT create alternatives.**

### Widgets (`lib/core/widgets/`)

| Widget                              | Use For                                                     |
| :---------------------------------- | :---------------------------------------------------------- |
| `AsyncValueWidget<T>`               | Displaying Riverpod `AsyncValue` (loading/error/data)       |
| `LoadingWidget`                     | Any loading state                                           |
| `AppErrorWidget`                    | Any error state with retry action                           |
| `EmptyWidget`                       | Empty lists / no data states                                |
| `AppButton`                         | All buttons (use `AppButtonVariant.primary/secondary/text`) |
| `AppIconButton`                     | All icon buttons                                            |
| `VerticalSpace` / `HorizontalSpace` | All spacing (`.xs()`, `.sm()`, `.md()`, `.lg()`, `.xl()`)   |
| `CachedImage`                       | All network images                                          |
| `ResponsiveBuilder`                 | Adaptive layouts                                            |
| `AppDialogs.confirm()`              | Confirmation dialogs                                        |
| `FadeIn` / `SlideIn` / `ScaleIn`    | Entry animations                                            |

### Constants (`lib/core/constants/`)

| File                 | Contains                          |
| :------------------- | :-------------------------------- |
| `app_constants.dart` | Durations, dimensions, validation |
| `api_endpoints.dart` | API endpoint paths                |
| `assets.dart`        | Image, icon, animation paths      |
| `storage_keys.dart`  | Secure storage and prefs keys     |

| Constant Class                   | Use For              |
| :------------------------------- | :------------------- |
| `AppConstants.animationNormal`   | Animation durations  |
| `AppConstants.borderRadiusMD`    | Border radii         |
| `AppConstants.debounceDelay`     | Debounce delays      |
| `AppConstants.defaultPageSize`   | Pagination           |
| `ApiEndpoints.login`             | API endpoint paths   |
| `StorageKeys.accessToken`        | Secure storage keys  |
| `Assets.logo`                    | Asset paths          |
| `AppIcons.home`                  | Icon paths           |
| `AnalyticsEvents.login`          | Analytics event keys |
| `RemoteConfigKeys.minAppVersion` | Remote config keys   |

### Extensions (`lib/core/extensions/`)

```dart
// ✅ Use extensions (preferred)
context.colorScheme         // instead of Theme.of(context).colorScheme
context.textTheme           // instead of Theme.of(context).textTheme
context.theme               // instead of Theme.of(context)
context.screenWidth         // instead of MediaQuery.of(context).size.width
context.isMobile            // responsive checks
context.unfocus()           // dismiss keyboard
context.showSnackBar(msg)   // show snackbar
context.showErrorSnackBar() // error snackbar
'hello'.capitalized         // string utilities
DateTime.now().timeAgo      // date formatting
```

### Hooks (`lib/core/hooks/`)

For `HookWidget` classes:

```dart
useDebounce(value, delay)   // debounced values
useToggle(initial)          // boolean toggle
usePagination(fetcher)      // infinite scroll
```

### Firebase Services (`lib/core/`)

| Service                       | Path             | Use For                         |
| :---------------------------- | :--------------- | :------------------------------ |
| `CrashlyticsService`          | `crashlytics/`   | Crash reporting & error logging |
| `AnalyticsService`            | `analytics/`     | User analytics & event tracking |
| `PerformanceService`          | `performance/`   | Performance monitoring & traces |
| `FirebaseRemoteConfigService` | `remote_config/` | Feature flags & A/B testing     |

```dart
// Analytics
ref.read(analyticsServiceProvider).logLogin(method: 'email');
ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.featureUsed);

// Performance (custom traces)
await ref.read(performanceServiceProvider).traceAsync('checkout', () => process());

// Remote Config (feature flags)
ref.read(firebaseRemoteConfigServiceProvider).getBool(RemoteConfigKeys.newFeatureEnabled);
ref.read(firebaseRemoteConfigServiceProvider).isMaintenanceMode;
```

---

## 📝 Coding Standards & Style

### Hard Constraints

- **No Magic Numbers**: Use `AppSpacing.md`, `AppConstants.borderRadiusMD`, etc.
- **No Direct Colors**: Use `context.colorScheme.primary` (via extension).
- **No Raw SizedBox for Spacing**: Use `VerticalSpace.md()` or `HorizontalSpace.sm()`.
- **No Custom Loading Widgets**: Use `LoadingWidget`.
- **No Custom Error Widgets**: Use `AppErrorWidget`.
- **Enum Shorthand**: Use Dart 3 enum shorthand syntax (e.g., `variant: .primary` instead of `variant: AppButtonVariant.primary`).

### Naming Conventions

| Type            | Convention  | Example                |
| :-------------- | :---------- | :--------------------- |
| Files           | snake_case  | `user_repository.dart` |
| Classes         | PascalCase  | `UserRepository`       |
| Variables       | camelCase   | `userData`             |
| Private Members | \_camelCase | `_privateField`        |
| Constants       | camelCase   | `maxRetryAttempts`     |
| JSON Fields     | snake_case  | `user_name`            |

### Error Handling

Always use the `Result<T>` monad for operations that can fail:

```dart
// Repository
Future<Result<User>> fetchUser(String id) async {
  try {
    final response = await apiClient.get<Map<String, dynamic>>('/users/$id');
    return response.map((data) => User.fromJson(data));
  } catch (e) {
    return Failure(UnexpectedException(message: e.toString()));
  }
}

// Usage
final result = await repo.fetchUser('123');
result.fold(
  onSuccess: (user) => handleUser(user),
  onFailure: (error) => showError(error.message),
);
```

### Validation

Use `Validators.compose()` for form validation:

```dart
TextFormField(
  validator: Validators.compose([
    Validators.required('Email is required'),
    Validators.email('Invalid email format'),
  ]),
)
```

**Note**: `Validators.strongPassword()` requires 8+ characters with uppercase, lowercase, number, and special character. Don't add redundant `minLength` validators.

---

## 🛠️ Development Workflow

### Adding a New Feature

**Always use the generator script:**

```bash
make feature NAME=my_feature
```

Then implement:

1. Define `Entity` in `domain/entities/`.
2. Define `Repository Interface` in `domain/repositories/`.
3. Implement `Repository` in `data/repositories/`.
4. Create `Provider` in `presentation/providers/`.
5. Build `Page` in `presentation/pages/`.
6. Add entry to `AppRoute` enum.

### Build Commands

```bash
make gen       # Run code generation (build_runner + l10n)
make format    # Format code & apply fixes
make lint      # Run static analysis
make test      # Run all tests
make prepare   # Full setup (clean + l10n + gen)
```

### Testing Guidelines

- **Unit Tests**: For Logic/Repositories
- **Widget Tests**: For UI Components
- **Pattern**: Arrange-Act-Assert
- **Shared Mocks**: Place in `test/helpers/mocks.dart`
- **Library**: Use `mocktail` for all mocking
- **Result<void>**: Return `const Success(null)` when mocking

---

## 🎨 Visual Design & Theming

### Material 3

- **ThemeData**: Centralized in `lib/core/theme/`.
- **ColorScheme**: Uses `ColorScheme.light()` and `ColorScheme.dark()`.
- **Dark Mode**: Support `ThemeMode.system`, `light`, and `dark`.

### Layout Best Practices

- **Responsiveness**: Use `ResponsiveBuilder` or `context.responsive()`.
- **Spacing**: Use `VerticalSpace` / `HorizontalSpace` widgets.
- **Lists**: Use `ListView.builder` for performance.
- **Safe Areas**: Respect `SafeArea`.

### Accessibility

- **Contrast**: Ensure 4.5:1 ratio.
- **Semantics**: Use `Semantics` widgets where necessary.
- **Scaling**: Test with dynamic text scaling.

---

## 🔐 Security Best Practices

### Secure Storage

- Use `FlutterSecureStorage` for sensitive data (tokens, credentials).
- Never log sensitive information.
- iOS Keychain data persists across reinstalls — use `FreshInstallHandler`.

### Network Security

- Auth tokens are automatically injected via `AuthInterceptor`.
- 401 responses trigger automatic token refresh with `Completer` coordination.
- Failed requests retry with exponential backoff.

---

## 📱 Platform Considerations

### iOS

- Keychain accessibility: `first_unlock_this_device`.
- Handle fresh install scenarios (clear stale keychain data).

### Android

- Encrypted SharedPreferences for secure storage.
- Native Cronet adapter for HTTP/3 support (release mode).

---

## ❌ Anti-Patterns to Avoid

1. **Don't** use `StatefulWidget` for business logic
2. **Don't** call `ref.read` in `build()` — use `ref.watch`
3. **Don't** create custom loading/error widgets
4. **Don't** use magic numbers for spacing/dimensions
5. **Don't** store tokens in plain SharedPreferences
6. **Don't** ignore `Result` failures
7. **Don't** use `!` bang operator without checking null first
8. **Don't** duplicate constants across files
