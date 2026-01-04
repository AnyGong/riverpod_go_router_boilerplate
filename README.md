# 🚀 Flutter Riverpod Boilerplate (Opinionated)

A **production-ready Flutter boilerplate** built for real-world applications — not demos, not experiments.

This repository is intentionally **opinionated**, structured, and optimized for **scalability, maintainability, and developer experience**.

> **Clone → Build → Ship.**  
> Not tweak endlessly.

---

## ✨ Tech Stack

- **Flutter (stable)**
- **Riverpod** – `AsyncNotifier` only
- **GoRouter** with `ShellRoute`
- **Clean Architecture** (feature-first)
- **Strict linting**
- **CI-ready**

---

## 🎯 Philosophy

This boilerplate exists to:

- Enforce **one clear way** to build Flutter apps
- Remove architectural decision fatigue
- Scale cleanly as the app grows
- Catch mistakes early via structure and conventions

Flexibility is intentionally limited in favor of **clarity and consistency**.

---

## ❌ What This Is NOT

- ❌ A tutorial  
- ❌ A pattern comparison repo  
- ❌ A flexible playground  

If you disagree with the decisions here, **fork the repo** and adjust it to your needs.

---

## 🧱 Core Architectural Rules (Non-Negotiable)

- ✅ `AsyncNotifier` only (`@riverpod`)
- ❌ No `StateNotifier`
- ❌ No `ChangeNotifier`
- ✅ Repositories return `Result<T>`
- ✅ UI consumes `AsyncValue<T>`
- ✅ `GoRouter` + `ShellRoute` is mandatory
- ✅ Feature isolation is enforced
- ❌ No `Dio` usage outside the data layer

These rules are enforced by **structure**, not just documentation.

---

## 📁 Folder Structure

This boilerplate follows a **feature-first, clean architecture** approach.  
Every feature uses the **same internal structure** to ensure consistency and scalability.

```txt
lib/
├── app/
│   ├── app.dart                 # Root widget
│   ├── bootstrap.dart           # App initialization
│   └── router/
│       ├── app_router.dart      # GoRouter configuration
│       ├── auth_routes.dart     # Public/auth routes
│       ├── protected_routes.dart
│       └── splash_route.dart
│
├── core/
│   ├── errors/
│   │   ├── failure.dart         # Domain-level failures
│   │   └── exceptions.dart
│   │
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── dio_provider.dart
│   │   └── network_interceptor.dart
│   │
│   ├── result/
│   │   └── result.dart          # Result<T> abstraction
│   │
│   ├── storage/
│   │   ├── local_storage.dart
│   │   └── secure_storage.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── utils/
│   │   └── logger.dart
│   │
│   └── widgets/
│       ├── loading_view.dart
│       └── error_view.dart
│
├── features/
│   └── auth/                    # Example feature
│       ├── data/
│       │   ├── datasources/
│       │   │   └── auth_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── usecases/
│       │       ├── login_usecase.dart
│       │       └── restore_session_usecase.dart
│       │
│       ├── presentation/
│       │   ├── pages/
│       │   │   ├── login_page.dart
│       │   │   └── splash_page.dart
│       │   ├── providers/
│       │   │   └── auth_notifier.dart
│       │   └── routes/
│       │       └── auth_routes.dart
│       │
│       └── auth_feature.dart    # Feature barrel file
│
└── main.dart
