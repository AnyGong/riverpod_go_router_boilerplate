<div align="center">

# 🚀 Flutter Riverpod Boilerplate

### A Production-Ready, Opinionated Flutter Starter Template

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-3.x-0553B1?style=for-the-badge)
![GoRouter](https://img.shields.io/badge/GoRouter-17.x-4CAF50?style=for-the-badge)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-9C27B0?style=for-the-badge)

**Clone → Build → Ship.** No architecture debates. No rewrites at scale.

[Features](#-features) • [Quick Start](#-quick-start) • [Architecture](#-architecture) • [Documentation](#-documentation)

</div>

---

## 📖 Table of Contents

- [Why This Boilerplate?](#-why-this-boilerplate)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Quick Start](#-quick-start)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Core Concepts](#-core-concepts)
  - [State Management (Riverpod)](#-state-management-riverpod)
  - [Navigation (GoRouter)](#-navigation-gorouter)
  - [Network Layer](#-network-layer)
  - [Result Pattern](#-result-pattern)
  - [Startup State Machine](#-startup-state-machine)
- [Key Features Explained](#-key-features-explained)
  - [Offline-First Caching](#-offline-first-caching)
  - [Biometric Authentication](#-biometric-authentication)
  - [Localization (i18n)](#-localization-i18n)
  - [Theme System](#-theme-system)
  - [Deep Linking](#-deep-linking)
  - [Crash Reporting](#-crash-reporting)
- [Adding New Features](#-adding-new-features)
- [Code Style Guidelines](#-code-style-guidelines)
- [Testing](#-testing)
- [Scripts](#-scripts)
- [License](#-license)

---

## 🤔 Why This Boilerplate?

<table>
<tr>
<td width="50%">

### ✅ This IS For You If...

- You want a **production-ready** starting point
- You prefer **conventions over configuration**
- You value **clean architecture** and **testability**
- You're building apps that need to **scale**
- You want to **ship faster** without architecture debates

</td>
<td width="50%">

### ❌ This Is NOT...

- A tutorial or learning resource
- A pattern comparison playground
- A flexible "choose your own adventure" template
- A minimal starter (it's comprehensive)

</td>
</tr>
</table>

> 💡 **Philosophy**: This boilerplate enforces **one clear way** to build Flutter apps. Flexibility is intentionally limited to prevent architectural drift.

---

## ✨ Features

<table>
<tr>
<td width="33%">

### 🏗️ Architecture

- ✅ Clean Architecture
- ✅ Feature-first structure
- ✅ Dependency injection
- ✅ Barrel file exports
- ✅ Separation of concerns

</td>
<td width="33%">

### 📱 State & Navigation

- ✅ Riverpod 3.x with codegen
- ✅ GoRouter 17.x
- ✅ Type-safe routing
- ✅ Auth guards
- ✅ Deep linking

</td>
<td width="33%">

### 🌐 Networking

- ✅ Dio with interceptors
- ✅ HTTP/3 & Brotli support
- ✅ Offline-first caching
- ✅ Token refresh
- ✅ Retry with backoff

</td>
</tr>
<tr>
<td width="33%">

### 💾 Storage

- ✅ Secure storage
- ✅ SQLite (Drift)
- ✅ SharedPreferences
- ✅ ETag caching

</td>
<td width="33%">

### 🔐 Security

- ✅ Biometric auth
- ✅ Secure token storage
- ✅ Session management
- ✅ Encrypted storage

</td>
<td width="33%">

### 🎨 UI/UX

- ✅ Material 3 theming
- ✅ Dark/Light modes
- ✅ Shimmer loading
- ✅ Custom hooks
- ✅ Animations

</td>
</tr>
<tr>
<td width="33%">

### 🌍 i18n

- ✅ English & বাংলা
- ✅ ARB file format
- ✅ Type-safe access
- ✅ Locale persistence

</td>
<td width="33%">

### 📊 DevOps

- ✅ Firebase Crashlytics
- ✅ Environment configs
- ✅ Code generation
- ✅ Linting (very_good_analysis)

</td>
<td width="33%">

### 🧪 Testing

- ✅ Unit tests
- ✅ Mocktail mocking
- ✅ Test coverage
- ✅ CI-ready

</td>
</tr>
</table>

---

## 🛠️ Tech Stack

| Category             | Technologies                                              | Description                                    |
| :------------------- | :-------------------------------------------------------- | :--------------------------------------------- |
| **State Management** | `flutter_riverpod` `riverpod_annotation` `hooks_riverpod` | Reactive state management with code generation |
| **Navigation**       | `go_router`                                               | Declarative routing with type-safe parameters  |
| **Networking**       | `dio` `native_dio_adapter` `retry`                        | HTTP client with HTTP/3, Brotli compression    |
| **Local Database**   | `drift` `sqlite3_flutter_libs`                            | Type-safe SQLite with code generation          |
| **Storage**          | `flutter_secure_storage` `shared_preferences`             | Encrypted + simple key-value storage           |
| **Serialization**    | `freezed` `json_serializable`                             | Immutable models with JSON support             |
| **Authentication**   | `local_auth`                                              | Biometric (Face ID, Touch ID, Fingerprint)     |
| **Crash Reporting**  | `firebase_crashlytics`                                    | Production error tracking                      |
| **Deep Linking**     | `app_links`                                               | Universal Links & App Links                    |
| **UI Components**    | `flutter_animate` `shimmer` `cached_network_image`        | Animations & image caching                     |
| **Testing**          | `mocktail` `flutter_test`                                 | Mocking & widget testing                       |

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK **3.10+** ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK **3.x** (included with Flutter)
- A code editor (VS Code or Android Studio recommended)

### Installation

```bash
# 1️⃣ Clone the repository
git clone https://github.com/your-username/riverpod_go_router_boilerplate.git
cd riverpod_go_router_boilerplate

# 2️⃣ Install dependencies
flutter pub get

# 3️⃣ Generate code (freezed, json_serializable, riverpod_generator, drift)
# Note: You can also use 'make gen' if you have make installed
dart run build_runner build --delete-conflicting-outputs

# 4️⃣ Run the app
flutter run
```

### Development Commands

```bash
# 🔄 Watch mode for code generation (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# 🧪 Run tests
flutter test

# 📊 Run tests with coverage
flutter test --coverage

# 🔍 Analyze code
flutter analyze

# 🌍 Regenerate localization files
flutter gen-l10n
```

---

## 🏛️ Architecture

This boilerplate follows **Clean Architecture** principles with a **feature-first** organization:

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │    Pages    │  │   Widgets   │  │      Providers      │  │
│  │  (Screens)  │  │    (UI)     │  │   (State/Logic)     │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼─────────────────────┼────────────┘
          │                │                     │
          ▼                ▼                     ▼
┌─────────────────────────────────────────────────────────────┐
│                        DOMAIN                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │    Use      │  │    Repository       │  │
│  │  (Models)   │  │   Cases     │  │   (Interfaces)      │  │
│  └─────────────┘  └─────────────┘  └──────────┬──────────┘  │
└───────────────────────────────────────────────┼─────────────┘
                                                │
                                                ▼
┌─────────────────────────────────────────────────────────────┐
│                         DATA                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Repository  │  │    Data     │  │       Remote        │  │
│  │   (Impl)    │  │   Sources   │  │     (API Client)    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Architectural Rules (Non-Negotiable)

| Rule                            | Why It Matters                              |
| :------------------------------ | :------------------------------------------ |
| Use `@riverpod` annotation only | Ensures consistent provider generation      |
| Repositories return `Result<T>` | Type-safe error handling without exceptions |
| UI consumes `AsyncValue<T>`     | Proper loading/error/data state handling    |
| No Dio usage outside data layer | Keeps networking concerns isolated          |
| No business logic in widgets    | Maintains testability and separation        |
| One provider per file (mostly)  | Improves maintainability and testing        |

---

## 📁 Project Structure

```
lib/
├── main.dart                      # 🚀 App entry point
│
├── app/                           # 📱 Application layer
│   ├── app.dart                   # MaterialApp configuration
│   ├── app_config.dart            # Static app configuration
│   ├── app_exports.dart           # Barrel file for app layer
│   ├── bootstrap.dart             # App initialization & error handling
│   │
│   ├── router/                    # 🧭 Navigation
│   │   ├── app_router.dart        # GoRouter configuration
│   │   ├── routes.dart            # Route path constants (AppRoute enum)
│   │   ├── auth_routes.dart       # Public authentication routes
│   │   ├── protected_routes.dart  # Auth-required routes
│   │   └── splash_route.dart      # Splash screen route
│   │
│   └── startup/                   # 🎬 Startup state machine
│       ├── startup_events.dart    # Lifecycle event definitions
│       ├── startup_signals.dart   # Async signal gathering
│       ├── startup_state_machine.dart   # State definitions
│       ├── startup_state_resolver.dart  # Signal → State resolution
│       ├── startup_route_mapper.dart    # State → Route mapping
│       ├── app_lifecycle_notifier.dart  # Event-driven lifecycle
│       └── presentation/
│           └── splash_page.dart   # Splash screen UI
│
├── config/                        # ⚙️ Configuration
│   └── env_config.dart            # Environment (dev/staging/prod)
│
├── core/                          # 🧱 Core infrastructure
│   ├── core.dart                  # Barrel file for all core exports
│   │
│   ├── biometric/                 # 🔐 Biometric authentication
│   │   └── biometric_service.dart
│   │
│   ├── cache/                     # 💾 SQLite caching (Drift)
│   │   ├── cache_service.dart
│   │   ├── cache_database.dart
│   │   └── cache_entry.dart
│   │
│   ├── network/                   # 🌐 Networking
│   │   ├── api_client.dart        # Type-safe API client
│   │   ├── dio_provider.dart      # Dio instance with interceptors
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── retry_interceptor.dart
│   │       ├── cache_interceptor.dart
│   │       └── logging_interceptor.dart
│   │
│   ├── result/                    # 📦 Result monad
│   │   └── result.dart            # Success/Failure pattern
│   │
│   ├── session/                   # 👤 Session management
│   │   ├── session_service.dart
│   │   └── session_state.dart
│   │
│   ├── storage/                   # 🔒 Secure storage
│   │   └── secure_storage.dart
│   │
│   ├── theme/                     # 🎨 Theming
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── theme_notifier.dart
│   │
│   ├── localization/              # 🌍 i18n
│   │   └── locale_notifier.dart
│   │
│   ├── hooks/                     # 🪝 Custom Flutter hooks
│   │   ├── use_async_state.dart
│   │   ├── use_debounced_value.dart
│   │   └── use_toggle.dart
│   │
│   ├── widgets/                   # 🧩 Reusable widgets
│   │   ├── async_value_widget.dart
│   │   ├── shimmer_loading.dart
│   │   └── app_cached_image.dart
│   │
│   └── extensions/                # 🔧 Dart extensions
│       ├── string_extensions.dart
│       ├── context_extensions.dart
│       └── date_extensions.dart
│
├── features/                      # 📦 Feature modules
│   ├── auth/                      # 🔑 Authentication
│   │   ├── auth.dart              # Barrel file
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── login_page.dart
│   │       └── providers/
│   │           └── auth_notifier.dart
│   │
│   ├── home/                      # 🏠 Home feature
│   ├── onboarding/                # 👋 Onboarding flow
│   └── settings/                  # ⚙️ Settings
│
├── l10n/                          # 🌍 Localization files
│   ├── app_en.arb                 # English translations
│   ├── app_bn.arb                 # বাংলা translations
│   └── generated/                 # Auto-generated l10n classes
│
└── test/                          # 🧪 Tests
    ├── auth_repository_test.dart
    ├── session_state_test.dart
    └── startup_state_resolver_test.dart
```

---

## 📚 Core Concepts

### 🔄 State Management (Riverpod)

**Riverpod** is a reactive state management solution. This boilerplate uses **Riverpod 3.x with code generation** for type-safety.

#### What is a Provider?

A **Provider** is a container for a piece of state. Think of it like a global variable that:

- Is lazily created (only when needed)
- Can be watched for changes
- Is automatically disposed when no longer used
- Can depend on other providers

#### Provider Types We Use

```dart
// 1️⃣ Simple Provider - Provides a constant or computed value
@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient(dio: ref.watch(dioProvider));
}

// 2️⃣ AsyncNotifier - For state that changes over time + async operations
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // Initial async state loading
    return await _loadCurrentUser();
  }

  // Methods to modify state
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _performLogin(email, password));
  }
}

// 3️⃣ keepAlive - Provider stays in memory even when not watched
@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  return SessionService(storage: ref.watch(secureStorageProvider));
}
```

#### Using Providers in Widgets

```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👀 Watch a provider (rebuilds when state changes)
    final authState = ref.watch(authNotifierProvider);

    // 📖 Read a provider (doesn't rebuild, good for callbacks)
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return authState.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (user) => user != null
        ? Text('Welcome, ${user.name}!')
        : ElevatedButton(
            onPressed: () => authNotifier.login(email, password),
            child: const Text('Login'),
          ),
    );
  }
}
```

---

### 🧭 Navigation (GoRouter)

**GoRouter** is a declarative routing package for Flutter. It works seamlessly with Riverpod for reactive navigation.

#### Route Definition

```dart
// Route paths are defined as an enum for type-safety and auth control
enum AppRoute {
  splash('/splash', requiresAuth: false),
  login('/login', requiresAuth: false),
  home('/', requiresAuth: true),
  profile('/profile', requiresAuth: true);

  const AppRoute(this.path, {required this.requiresAuth});
  final String path;
  final bool requiresAuth;
}

// Router configuration
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    refreshListenable: ref.watch(appLifecycleListenableProvider),
    redirect: (context, state) {
      // Global redirect logic is handled via the startup state machine
      // and redirect guards in app_router.dart
    },
    // ...
  );
}
```

#### Navigating Between Routes

```dart
// Navigate to a route
context.goRoute(AppRoute.home);

// Navigate with parameters (using extension method)
context.goRouteWith(AppRoute.productDetail, {'id': '123'});

// Push onto navigation stack (can go back)
context.pushRoute(AppRoute.settings);

// Go back
context.pop();
```

---

### 🌐 Network Layer

The networking layer uses **Dio** with custom interceptors for a robust HTTP client.

#### Making API Calls

```dart
// Using the ApiClient (type-safe)
final result = await apiClient.get<User>(
  '/users/me',
  fromJson: User.fromJson,
);

// Handle the result
result.fold(
  onSuccess: (user) => print('Got user: ${user.name}'),
  onFailure: (error) => print('Error: ${error.message}'),
);
```

#### Interceptor Chain

```
Request → Auth → Cache → Retry → Logging → Server
                                              │
Response ← Logging ← Retry ← Cache ← Auth ←───┘
```

| Interceptor | Purpose                                                      |
| :---------- | :----------------------------------------------------------- |
| **Auth**    | Injects access token, handles refresh on 401                 |
| **Cache**   | Stores responses in SQLite, returns cached data when offline |
| **Retry**   | Retries failed requests with exponential backoff             |
| **Logging** | Logs requests/responses for debugging                        |

---

### 📦 Result Pattern

Instead of throwing exceptions, we use a **Result** type for explicit error handling:

```dart
// Defining a result
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  });
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException error;
  const Failure(this.error);
}
```

#### Why Result Pattern?

- ✅ **Explicit**: You can't ignore errors
- ✅ **Type-safe**: Compiler ensures error handling
- ✅ **No try-catch**: Cleaner code flow
- ✅ **Testable**: Easy to test both paths

#### Usage in Repository

```dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final response = await apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return Success(User.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(NetworkException.fromDio(e));
    }
  }
}
```

---

### 🎬 Startup State Machine

The startup system uses an **event-driven state machine** to manage app lifecycle:

```
┌─────────────────────────────────────────────────────────────┐
│                    STARTUP FLOW                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌───────────┐    ┌───────────┐    ┌──────────────┐       │
│   │  Events   │ => │  Signals  │ => │   Resolver   │       │
│   │ (Trigger) │    │  (Gather) │    │  (Decide)    │       │
│   └───────────┘    └───────────┘    └──────┬───────┘       │
│                                             │               │
│                                             ▼               │
│   ┌───────────┐    ┌───────────┐    ┌──────────────┐       │
│   │   Route   │ <= │   State   │ <= │   Mapper     │       │
│   │ (Navigate)│    │ (Current) │    │ (State→Route)│       │
│   └───────────┘    └───────────┘    └──────────────┘       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### Startup Events

| Event                 | When It Fires              |
| :-------------------- | :------------------------- |
| `AppLaunched`         | App just started           |
| `UserAuthenticated`   | User logged in             |
| `UserLoggedOut`       | User logged out            |
| `SessionExpired`      | Token expired/invalid      |
| `OnboardingCompleted` | User finished onboarding   |
| `MaintenanceEnabled`  | Server in maintenance mode |

#### Startup States

| State             | Description           | Route            |
| :---------------- | :-------------------- | :--------------- |
| `Maintenance`     | App under maintenance | Maintenance page |
| `Onboarding`      | First-time user       | Onboarding flow  |
| `Unauthenticated` | Needs login           | Login page       |
| `Authenticated`   | Logged in             | Home page        |

---

## 🔧 Key Features Explained

### 💾 Offline-First Caching

The caching system uses **Drift (SQLite)** to store API responses locally:

```dart
// Make a request (interceptors handle caching automatically)
final result = await apiClient.get<List<Product>>(
  '/products',
  fromJson: (json) => (json as List).map((e) => Product.fromJson(e)).toList(),
);
```

**How it works:**

1. Request intercepted by `CacheInterceptor`
2. Check SQLite for cached response
3. If cached & valid → return immediately
4. If offline → return cached (even if stale)
5. If online → fetch from server, update cache

---

### 🔐 Biometric Authentication

Support for Face ID, Touch ID, and Fingerprint:

```dart
// Check if biometric is available
final isAvailable = await biometricService.isAvailable();

// Authenticate user
final result = await biometricService.authenticate(
  localizedReason: 'Verify your identity to continue',
);

result.fold(
  onSuccess: (_) => print('Authenticated!'),
  onFailure: (e) => print('Failed: ${e.message}'),
);
```

**Platform Support:**

| Platform | Supported Methods              |
| :------- | :----------------------------- |
| iOS      | Face ID, Touch ID              |
| Android  | Fingerprint, Face Unlock, Iris |

---

### 🌍 Localization (i18n)

The app supports **English** and **বাংলা (Bengali)** out of the box:

#### Adding Translations

Edit `lib/l10n/app_en.arb` and `lib/l10n/app_bn.arb`:

```json
// app_en.arb
{
  "welcomeMessage": "Welcome to the app!",
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}"
}

// app_bn.arb
{
  "welcomeMessage": "অ্যাপে স্বাগতম!",
  "itemCount": "{count, plural, =0{কোন আইটেম নেই} =1{১টি আইটেম} other{{count}টি আইটেম}}"
}
```

#### Using Translations

```dart
// In any widget
Text(context.l10n.welcomeMessage)
Text(context.l10n.itemCount(5))

// Change locale
ref.read(localeNotifierProvider.notifier).setLocale(const Locale('bn'));
```

#### Adding a New Language

1. Create `lib/l10n/app_xx.arb` (replace `xx` with language code)
2. Add translations for all keys
3. Update `locale_notifier.dart` to include the new locale
4. Run `flutter gen-l10n`

---

### 🎨 Theme System

Material 3 theming with dynamic light/dark mode:

```dart
// Toggle theme mode
ref.read(themeNotifierProvider.notifier).setThemeMode(ThemeMode.dark);

// Current theme
final themeMode = ref.watch(themeNotifierProvider);

// Using theme colors
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
)
```

**Theme Files:**

- `app_colors.dart` - Color palette definition
- `app_theme.dart` - ThemeData configuration
- `theme_notifier.dart` - Theme state management

---

### 🔗 Deep Linking

Handle custom URLs and universal links:

```dart
// URL schemes supported:
// myapp://home
// myapp://profile/123
// https://myapp.com/products/456

// Deep links are automatically handled by GoRouter
GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final productId = state.pathParameters['id']!;
    return ProductPage(id: productId);
  },
),
```

**Configuration:**

- **iOS**: `ios/Runner/Runner.entitlements` + Associated Domains
- **Android**: `android/app/src/main/AndroidManifest.xml` intent filters

---

### 💥 Crash Reporting

Firebase Crashlytics integration for production error tracking:

```dart
// Automatically captures uncaught exceptions

// Manual error logging
await crashlyticsService.recordError(
  error,
  stackTrace,
  reason: 'Failed to load user profile',
);

// Set user identifier for crash reports
await crashlyticsService.setUserIdentifier(userId);
```

---

## ➕ Adding New Features

Follow this structure when adding new features:

```bash
# 1. Create the feature directory
mkdir -p lib/features/your_feature/{data/repositories,domain/{entities,repositories},presentation/{pages,providers,widgets}}

# 2. Create the barrel file
touch lib/features/your_feature/your_feature.dart
```

**Feature Structure:**

```
features/
└── your_feature/
    ├── your_feature.dart          # 📦 Barrel file (exports everything)
    │
    ├── data/
    │   └── repositories/
    │       └── your_repository_impl.dart  # 🔌 Implementation
    │
    ├── domain/
    │   ├── entities/
    │   │   └── your_entity.dart   # 📋 Data models (freezed)
    │   └── repositories/
    │       └── your_repository.dart  # 📜 Interface/Contract
    │
    └── presentation/
        ├── pages/
        │   └── your_page.dart     # 📱 Screen UI
        ├── providers/
        │   └── your_notifier.dart # 🔄 State management
        └── widgets/
            └── your_widget.dart   # 🧩 Feature-specific widgets
```

**Example Entity:**

```dart
// domain/entities/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    String? imageUrl,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

**Example Provider:**

```dart
// presentation/providers/products_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_notifier.g.dart';

@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  Future<List<Product>> build() async {
    final repository = ref.watch(productRepositoryProvider);
    final result = await repository.getProducts();
    return result.fold(
      onSuccess: (products) => products,
      onFailure: (error) => throw error,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
```

---

## 📏 Code Style Guidelines

| File Type               | Target Lines | Max Lines |
| :---------------------- | :----------: | :-------: |
| Models / Entities       |    20–80     |    120    |
| Providers / Notifiers   |    50–120    |    180    |
| Services / Repositories |    50–150    |    200    |
| UI Widgets              |    60–200    |    250    |
| Test files              |    40–200    |    300    |

**General Rules:**

- Method length: **< 40 lines** (ideal < 20)
- Use `very_good_analysis` for linting
- Prefer `const` constructors
- Use meaningful variable names
- Add dartdoc comments for public APIs
- One class per file (mostly)

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/startup_state_resolver_test.dart

# Run with coverage
flutter test --coverage

# Generate coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Test Structure:**

```dart
void main() {
  group('AuthRepository', () {
    late MockApiClient mockApiClient;
    late AuthRepositoryImpl repository;

    setUp(() {
      mockApiClient = MockApiClient();
      repository = AuthRepositoryImpl(apiClient: mockApiClient);
    });

    test('login returns user on success', () async {
      // Arrange
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(data: mockUserJson));

      // Act
      final result = await repository.login('test@email.com', 'password');

      // Assert
      expect(result, isA<Success<User>>());
    });
  });
}
```

---

## 🛠️ Scripts

| Script                   | Description           |
| :----------------------- | :-------------------- |
| `./scripts/bootstrap.sh` | Initial project setup |
| `./scripts/clean.sh`     | Clean build artifacts |

**Makefile Commands:**

```bash
make prepare   # Clean + Gen
make gen       # Run build_runner
make watch     # Run build_runner in watch mode
make format    # Format + Fix lint issues
make test      # Run all tests
make clean     # Clean project
```

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### 🌟 Star This Repo

If you find this boilerplate useful, please give it a ⭐️!

**Built with ❤️ for Flutter developers who value quality and maintainability.**

[Report Bug](https://github.com/your-username/riverpod_go_router_boilerplate/issues) • [Request Feature](https://github.com/your-username/riverpod_go_router_boilerplate/issues) • [Contribute](https://github.com/your-username/riverpod_go_router_boilerplate/pulls)

</div>
