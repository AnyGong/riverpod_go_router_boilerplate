# 🚀 Flutter Riverpod Boilerplate (Opinionated)

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)
![Riverpod](https://img.shields.io/badge/Riverpod-3.x-blue?style=flat-square)
![GoRouter](https://img.shields.io/badge/GoRouter-17.x-green?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-purple?style=flat-square)

A **production-ready Flutter boilerplate** for building **scalable, maintainable, real-world applications**.

This repository is intentionally **opinionated**, strictly structured, and optimized for **long-term growth**, not experimentation.

> **Clone → Build → Ship.** No architecture debates. No rewrites at scale.

---

## ⭐ Why This Repo?

- Built for **production**, not demos
- Enforces **clean architecture** by default
- Uses **modern Flutter + Riverpod best practices**
- Eliminates architectural decision fatigue
- Designed for **teams and long-lived apps**

If you value **clarity over flexibility**, this boilerplate is for you.

---

## ✨ Tech Stack

| Package                    | Purpose                                 |
| :------------------------- | :-------------------------------------- |
| **Flutter 3.x**            | Cross-platform UI framework             |
| **Riverpod 3.x**           | State management (`AsyncNotifier` only) |
| **GoRouter 17.x**          | Declarative routing with guards         |
| **Dio**                    | HTTP client with interceptors           |
| **flutter_secure_storage** | Secure token storage                    |
| **flutter_native_splash**  | Native splash screen                    |

---

## 🎯 Philosophy

This boilerplate exists to:

1. Enforce **one clear way** to build Flutter apps.
2. Prevent architectural drift as the app grows.
3. Scale cleanly from MVP → large production app.
4. Catch mistakes early through structure and conventions.

Flexibility is intentionally limited.

---

## ❌ What This Is NOT

- ❌ A tutorial
- ❌ A pattern comparison repo
- ❌ A flexible playground

If you disagree with these decisions, **fork the repo**.

---

## 🧱 Core Architectural Rules (Non-Negotiable)

| Rule                                                       | Status |
| :--------------------------------------------------------- | :----: |
| `AsyncNotifier` only (no `StateNotifier`/`ChangeNotifier`) |   ✅   |
| Repositories return `Result<T>`                            |   ✅   |
| UI consumes `AsyncValue<T>`                                |   ✅   |
| Startup flow via **state machine**                         |   ✅   |
| GoRouter enforces access, not startup logic                |   ✅   |
| No `Dio` usage outside data layer                          |   ✅   |
| No business logic inside widgets                           |   ✅   |
| Dependency injection via Riverpod providers                |   ✅   |

These rules are enforced by **structure**, not documentation alone.

---

## 📁 Folder Structure

This boilerplate follows a **feature-first, clean architecture** approach.

```text
lib/
├── app/
│   ├── app.dart                    # Root MaterialApp
│   ├── app_config.dart             # Static configuration
│   ├── app_exports.dart            # Barrel file
│   ├── bootstrap.dart              # App initialization
│   ├── router/
│   │   ├── app_router.dart         # GoRouter configuration
│   │   ├── auth_routes.dart        # Public routes
│   │   └── protected_routes.dart   # Authenticated routes
│   └── startup/
│       ├── startup_state_machine.dart
│       ├── startup_signals.dart
│       ├── startup_state_resolver.dart
│       └── startup_route_mapper.dart
│
├── config/
│   └── env_config.dart             # Environment configuration
│
├── core/
│   ├── core.dart                   # Barrel file
│   ├── network/
│   │   ├── api_client.dart         # Type-safe API client
│   │   └── dio_provider.dart       # Dio with interceptors
│   ├── result/
│   │   └── result.dart             # Result monad + exceptions
│   ├── storage/
│   │   └── secure_storage.dart     # Secure storage provider
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── app_typography.dart
│   └── widgets/
│       ├── async_value_widget.dart # AsyncValue consumer
│       └── spacing.dart            # Spacing utilities
│
├── features/
│   ├── auth/
│   │   ├── auth.dart               # Feature barrel file
│   │   ├── data/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── providers/
│   └── home/
│       └── presentation/
│           └── pages/
│
└── main.dart                       # Entry point
```

---

## 🔥 Key Features

### Result Pattern

Type-safe error handling without exceptions:

```dart
final result = await repository.login(email, password);
result.fold(
  onSuccess: (user) => print(user.name),
  onFailure: (error) => print(error.message),
);
```

### Reactive Router

GoRouter automatically reacts to auth state changes:

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final authListenable = ref.watch(authStateListenableProvider);
  return GoRouter(
    refreshListenable: authListenable,
    // Routes automatically refresh when auth changes
  );
});
```

### Environment Configuration

Easily switch between dev/staging/prod:

```dart
// In main.dart
await AppBootstrap.initialize(
  environment: Environment.dev,  // or .staging, .prod
);
```

### API Client with Result

All network calls return `Result<T>`:

```dart
final result = await apiClient.get<User>(
  '/users/me',
  fromJson: User.fromJson,
);
```

---

## 🧠 Startup Architecture (State Machine)

Startup behavior is modeled as an **explicit state machine**, not router logic.

### Startup States

| State                  | Description                              |
| :--------------------- | :--------------------------------------- |
| `MaintenanceState`     | App under maintenance (highest priority) |
| `OnboardingState`      | User needs to complete onboarding        |
| `UnauthenticatedState` | User needs to login                      |
| `AuthenticatedState`   | User is logged in                        |
| `PublicState`          | App doesn't require auth                 |

### Resolution Flow

```
StartupSignals → StartupStateResolver → StartupState → StartupRouteMapper → Navigation
```

This guarantees:

- ✅ No invalid flows
- ✅ No redirect loops
- ✅ Fully testable startup logic
- ✅ Clean separation of concerns

---

## ✅ Supported App Scenarios

| Scenario                            | Supported |
| :---------------------------------- | :-------: |
| Onboarding + Login required         |    ✅     |
| Onboarding without login            |    ✅     |
| Onboarding with optional login      |    ✅     |
| Public home with protected features |    ✅     |
| Login without onboarding            |    ✅     |
| No-auth apps                        |    ✅     |
| Maintenance mode                    |    ✅     |
| Feature-flagged startup             |    ✅     |

---

## ➕ Adding a New Feature

1. Create `lib/features/your_feature/`
2. Follow the `data` → `domain` → `presentation` structure
3. Create a barrel file (`your_feature.dart`)
4. Register routes in `app/router/`

Example structure:

```text
features/
└── your_feature/
    ├── your_feature.dart          # Barrel file
    ├── data/
    │   └── repositories/
    │       └── your_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   └── repositories/
    │       └── your_repository.dart
    └── presentation/
        ├── pages/
        └── providers/
```

---

## 🛠️ Scripts

```bash
./scripts/bootstrap.sh   # Initial setup
./scripts/clean.sh       # Clean project
```

---

## 🚀 Getting Started

**Prerequisites:** Flutter SDK 3.10+ installed.

```bash
# Clone
git clone https://github.com/your-username/riverpod_go_router_boilerplate.git

# Install dependencies
flutter pub get

# Run
flutter run
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/startup_state_resolver_test.dart

# Run with coverage
flutter test --coverage
```

---

## 📜 License

MIT — use it, fork it, ship it.

---

**This boilerplate is for developers who value correctness, clarity, and long-term maintainability over choice.** If that's you — welcome aboard 🚀
