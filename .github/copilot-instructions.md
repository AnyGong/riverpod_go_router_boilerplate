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

- **`lib/app/`**: Global app setup (routing, theme, initialization).
- **`lib/core/`**: Shared utilities, foundational services, and widgets (e.g., `network/`, `storage/`, `widgets/`, `localization/`).
- **`lib/features/`**: Feature modules. Each feature **MUST** follow strictly:
  - **`data/`**: Repositories implementations, DTOs, data sources.
  - **`domain/`**: Entities (simple classes), Repository interfaces.
  - **`presentation/`**:
    - **`pages/`**: Full screens.
    - **`widgets/`**: Reusable UI components for the feature.
    - **`providers/`**: Application logic (Riverpod Notifiers).

### State Management (Riverpod)

- **Mandatory**: Use **Riverpod** for all state management.
- **Code Generation**: Use `@riverpod` / `@Riverpod(keepAlive: true)`.
- **Logic Location**: Business logic resides in **Notifiers** (Presentation) or **Services** (Domain/Data).
- **UI Role**: Widgets only `watch` state and `read` methods. No complex logic in `build()`.
- **Avoid**: `StatefulWidget` for logic (use only for animation/input controllers).

### Routing (GoRouter)

- Use **GoRouter** for all navigation.
- Define routes in `lib/app/router/`.
- Use `AppRoute` enum for type-safe route paths.

### Forms

- Use **`reactive_forms`** for all complex form handling.
- Use pre-built form groups from `lib/core/forms/` (e.g., `AuthForms.login()`).
- Validation logic should be reusable (e.g., `lib/core/utils/validators.dart`).

---

## 📦 Mandatory Reusable Components

**You MUST use these existing components. Do NOT create alternatives.**

### Widgets (`lib/core/widgets/`)

| Widget                              | Use For                                                   |
| :---------------------------------- | :-------------------------------------------------------- |
| `AsyncValueWidget<T>`               | Displaying Riverpod `AsyncValue` (loading/error/data)     |
| `LoadingWidget`                     | Any loading state                                         |
| `ErrorWidget`                       | Any error state with retry                                |
| `EmptyWidget`                       | Empty lists / no data states                              |
| `AppButton`                         | All buttons (primary, secondary, text variants)           |
| `AppIconButton`                     | All icon buttons                                          |
| `VerticalSpace` / `HorizontalSpace` | All spacing (`.xs()`, `.sm()`, `.md()`, `.lg()`, `.xl()`) |
| `CachedImage`                       | All network images                                        |
| `ResponsiveBuilder`                 | Adaptive layouts                                          |

### Constants (`lib/core/constants/`)

| Constant Class                    | Use For             |
| :-------------------------------- | :------------------ |
| `AppConstants.animationNormal`    | Animation durations |
| `AppConstants.borderRadiusMedium` | Border radii        |
| `AppConstants.debounceDelay`      | Debounce delays     |
| `AppConstants.defaultPageSize`    | Pagination          |
| `ApiEndpoints.login`              | API endpoint paths  |
| `StorageKeys.accessToken`         | Secure storage keys |

### Extensions (`lib/core/extensions/`)

```dart
// ✅ Use extensions
context.colorScheme         // instead of Theme.of(context).colorScheme
context.textTheme           // instead of Theme.of(context).textTheme
context.screenWidth         // instead of MediaQuery.of(context).size.width
context.isMobile            // responsive checks
context.unfocus()           // dismiss keyboard
context.showSnackBar(msg)   // show snackbar
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

---

## 📝 Coding Standards & Style

### Hard Constraints

- **No `useIsMounted`**: Use `context.mounted` instead.
- **No Magic Numbers**: Use `AppSpacing.md`, `AppConstants.borderRadiusMedium`, etc.
- **No Direct Colors**: Use `context.colorScheme.primary` (via extension).
- **No Raw SizedBox for Spacing**: Use `VerticalSpace.md()` or `HorizontalSpace.sm()`.
- **No Custom Loading Widgets**: Use `LoadingWidget`.
- **No Custom Error Widgets**: Use `ErrorWidget`.

### Naming Conventions

- **Files**: `snake_case.dart` (e.g., `user_repository.dart`).
- **Classes**: `PascalCase` (e.g., `UserRepository`).
- **Variables/Functions**: `camelCase`.
- **Private Members**: `_privateVariable`.
- **JSON Fields**: `snake_case` (use `@JsonSerializable(fieldRename: FieldRename.snake)`).

### Dart Best Practices

- **Null Safety**: Leverage sound null safety. Avoid `!` bang operator.
- **Async/Await**: Use `Future` and `Stream` properly. Handle errors.
- **Pattern Matching**: Use Dart 3 switch expressions where possible.
- **Records**: Use records for multiple return values instead of utility classes.

### Documentation

- **Public APIs**: Must have Dartdoc (`///`) comments.
- **Complex Logic**: Explain _why_, not just _what_.
- **No Redundant Comments**: Don't document obvious getters/setters.

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
6. Add entry to `AppRoute` enum in `lib/app/router/app_router.dart`.

### Build Commands

```bash
make gen       # Run code generation (build_runner + l10n)
make format    # Format code & apply fixes
make lint      # Run static analysis
make test      # Run all tests
```

### Testing

- **Unit Tests**: For Logic/Repositories (`flutter test`).
- **Widget Tests**: For UI Components.
- **Pattern**: Arrange-Act-Assert.

### Mocking Guidelines

- **Shared Mocks**: Place reusable mocks in `test/helpers/mocks.dart`.
- **Library**: Use `mocktail` for all mocking.
- **Result<void>**: When mocking `Result<void>`, return `const Success(null)`.

---

## 🎨 Visual Design & Theming

### Material 3

- **ThemeData**: Centralized in `lib/core/theme/`.
- **ColorScheme**: Derived from `ColorScheme.fromSeed`.
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
