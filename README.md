# Flutter Riverpod Boilerplate (Opinionated)

A **production-ready Flutter boilerplate** using:

- Riverpod (AsyncNotifier only)
- GoRouter with ShellRoute
- Clean Architecture (feature-first)
- Strict linting & CI

This repo is designed to be **cloned and shipped**, not customized endlessly.

---

## What This Is

- A default architecture for real apps
- Opinionated by design
- Optimized for scalability and DX
- Enforces best practices via structure

## What This Is NOT

- A tutorial
- A showcase of multiple patterns
- A flexible playground

---

## Architectural Decisions (Non-Negotiable)

- AsyncNotifier only (`@riverpod`)
- No StateNotifier / ChangeNotifier
- Repositories return `Result<T>`
- UI consumes `AsyncValue<T>`
- GoRouter + ShellRoute required
- Features are isolated
- No Dio usage outside data layer

> If you disagree with these decisions, **fork the repo**.

---

## Folder Structure

lib/
├── app/ # App setup & routing
├── core/ # Shared infrastructure
├── features/ # Feature modules

---

## How Auth Works

- Session restored on app start
- Router reacts to auth state
- Protected routes live under ShellRoute
- Logout clears storage and state

---

## Adding a Feature

1. Create `features/your_feature`
2. Follow the existing auth feature structure
3. Export routes from `presentation/routes`
4. Register routes in `protected_routes.dart`

---

## Scripts

```bash
./scripts/bootstrap.sh
./scripts/clean.sh
```
