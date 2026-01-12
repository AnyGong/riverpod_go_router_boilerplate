# Flutter Boilerplate AI Instructions

You are an expert Flutter developer working on a production-grade boilerplate project. Your goal is to maintain the highest standards of code quality, architecture, and maintainability.

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
- Use **Typed Routes** (`GoRouteData`) for type safety where possible.

### Forms

- Use **`reactive_forms`** for all complex form handling.
- Validation logic should be reusable (e.g., `lib/core/utils/validators.dart`).

---

## 📝 Coding Standards & Style

### General Rules (Flutter Style Guide)

- **SOLID Principles**: Apply SOLID principles throughout.
- **Concise & Declarative**: Prefer functional and declarative patterns.
- **Composition over Inheritance**: Favor composition. Widgets are for UI.
- **Immutability**: All classes (Entities, States, Widgets) should be immutable (`@immutable` / `final` fields).
- **Hard Constraints**:
  - **No `useIsMounted`**: Use `context.mounted` instead.
  - **No Magic Numbers**: Use `AppSpacing` (e.g., `AppSpacing.md`) and `AppConstants`.
  - **No Direct Colors**: Always use `Theme.of(context).colorScheme` or `Theme.of(context).extension<MyColors>()`.

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

### Dependency Management

- Use `flutter pub add` to add packages.
- **Build Runner**: Always run after modifying annotated files:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

### Testing

- **Unit Tests**: For Logic/Repositories (`flutter test`). Use `mocktail` for mocks.
- **Widget Tests**: For UI Components.
- **Golden Tests**: For visual regression (optional).
- **Pattern**: Arrange-Act-Assert.

---

## 🎨 Visual Design & Theming

### Material 3

- **ThemeData**: Centralized in `lib/core/theme/`.
- **ColorScheme**: Derived from `ColorScheme.fromSeed`.
- **Dark Mode**: Support `ThemeMode.system`, `light`, and `dark`.

### Layout Best Practices

- **Responsiveness**: Use `LayoutBuilder` or `MediaQuery`.
- **Spacing**: Use constants from `AppSpacing`.
- **Lists**: Use `ListView.builder` for performance.
- **Safe Areas**: Respect `SafeArea`.

### Accessibility

- **Contrast**: Ensure 4.5:1 ratio.
- **Semantics**: Use `Semantics` widgets where necessary.
- **Scaling**: Test with dynamic text scaling.

---

## 🚀 Specific Feature Implementation Rules

### Adding a New Feature

1. Create folder `lib/features/<feature_name>`.
2. Create `data`, `domain`, `presentation` subfolders.
3. Define `Entity` in `domain`.
4. Define `Repository Interface` in `domain`.
5. Implement `Repository` in `data`.
6. Create `Provider` in `presentation/providers`.
7. Build `Page` in `presentation/pages`.
8. Add Route to `app_router.dart`.
