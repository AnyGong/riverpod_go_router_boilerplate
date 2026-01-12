# 📘 Developer Guide & Best Practices

**Welcome to the codebase!** 👋

This guide is designed to help you become productive immediately, even if you are new to strict **Clean Architecture**, **Riverpod**, or **Flutter**. This boilerplate provides a robust foundation so you can focus on building features, not reinventing the wheel.

---

## 🏗️ The "Vision" of this Boilerplate

We follow a strict **Convention over Configuration** philosophy.

- **Consistency**: Every feature looks the same. Once you know one, you know them all.
- **Scalability**: The architecture handles 100+ screens as easily as 5.
- **Safety**: Strong typing (Enums, Code Generation) catches generic errors at compile time.

---

## 🚀 Reusable Component Library

Don't write new code if a solution already exists! We have prepared a suite of professional-grade components in `lib/core/`.

### 🧩 Smart Widgets (`lib/core/widgets/`)

| Widget                    | Purpose                                                     | Usage Example                                                                   |
| :------------------------ | :---------------------------------------------------------- | :------------------------------------------------------------------------------ |
| **`AsyncValueWidget<T>`** | Handles Loading/Error/Data states for Riverpod.             | Checks `isLoading`, shows `CircularProgress`, handles errors, then builds data. |
| **`PrimaryButton`**       | Standard branded button with loading state support.         | `PrimaryButton(text: 'Login', isLoading: true, onPressed: ...)`                 |
| **`CachedImage`**         | Network image with caching, retry, and shimmer placeholder. | `CachedImage(imageUrl: url, height: 100)`                                       |
| **`ConnectivityWrapper`** | Shows a "No Internet" banner automatically.                 | Wrap your `Scaffold` body or just use the global wrapper.                       |
| **`ShimmerLoading`**      | Skeleton loading effect.                                    | `ShimmerLoading(child: Container(...))`                                         |
| **`ResponsiveBuilder`**   | Adaptive layouts (Mobile/Tablet/Desktop).                   | `ResponsiveBuilder(mobile: MobileView(), desktop: DesktopView())`               |

### 🛠️ Utilities (`lib/core/utils/`)

| Utility          | Purpose                              | Usage                                     |
| :--------------- | :----------------------------------- | :---------------------------------------- |
| **`Validators`** | Form validation logic.               | `Validators.required`, `Validators.email` |
| **`AppLogger`**  | Logging with pretty printing.        | `ref.read(loggerProvider).i('Message')`   |
| **`Pagination`** | Helper for infinite scrolling lists. | Used in Repositories for paginated APIs.  |

### 🎨 Theme & Spacing (`lib/core/theme/`)

- **`AppSpacing`**: **NEVER** use magic numbers for padding.
  - ✅ `Gap(AppSpacing.md)` (16px)
  - ❌ `Gap(16)`
- **`AppTheme`**: Centralized logic for Light/Dark mode. Use `Theme.of(context)` to access colors.

### 🔌 Services (`lib/core/`)

- **`ApiClient`**: Type-safe HTTP client with Refresh Token logic built-in.
- **`SecureStorage`**: Encrypted storage for sensitive data (Tokens).
- **`LocalNotificationService`**: Abstraction for local notifications.
- **`BiometricService`**: Easy FaceID/TouchID integration.

---

## 👷 Feature Development Workflow

We automated the boring parts! To create a new feature that follows our strict architecture:

### Step 1: Run the Script

```bash
make feature NAME=my_new_feature
```

### Step 2: What You Get

This creates `lib/features/my_new_feature/` with:

- `data/` (Repositories, DTOs)
- `domain/` (Entities, Repository Interfaces)
- `presentation/` (Pages, Providers, Widgets)

### Step 3: Implement Logic

1.  **Define Domain**: Add your `Entity` (e.g., `Product`) and `Repository Interface`.
2.  **Implement Data**: Implement the repository in `data/` using `ApiClient`.
3.  **State**: Create a `Riverpod` notifier in `presentation/providers/` to call the repository.
4.  **UI**: Build the page in `presentation/pages/`, watching the provider.

---

## ⚡ State Management "Cheatsheet"

We use **Riverpod Generator** for everything.

**1. Fetching Data (FutureProvider replacement)**

```dart
@riverpod
Future<User> fetchUser(FetchUserRef ref, int id) async {
  final repository = ref.watch(userRepositoryProvider);
  final result = await repository.getUser(id);
  return result.fold(
    onSuccess: (user) => user,
    onFailure: (error) => throw error, // UI handles error state
  );
}
```

**2. Mutable State (NotifierProvider replacement)**

```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0; // Initial state

  void increment() => state++;
}
```

**3. Consuming in UI**

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

## 🧪 Testing Strategy

| Type             | Command        | When to write?                          |
| :--------------- | :------------- | :-------------------------------------- |
| **Unit Tests**   | `flutter test` | For Repositories, Notifiers, and Utils. |
| **Widget Tests** | `flutter test` | For reusable Widgets and complex Pages. |

**Mocking**:

- Use `mocktail`.
- Shared mocks go in `test/helpers/mocks.dart`.
- For `Result<void>`, mock return value as `const Success(null)`.

---

## ❓ FAQ

**Q: Where do I put my API URL?**
A: `lib/config/env_config.dart`.

**Q: How do I handle forms?**
A: Use `reactive_forms`. See `lib/features/auth/presentation/pages/login_page.dart` for an example.

**Q: How do I add a new Route?**
A: Add an entry to the `AppRoute` enum in `lib/app/router/app_router.dart` and add the `GoRoute` object in the list.

**Q: I have a lint error I can't fix.**
A: Run `make format`. If it persists, read the error—our lint rules are strict for a reason!

---

_Built for scalability. Maintained with ❤️._
