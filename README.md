# 🚀 Flutter Riverpod Boilerplate (Opinionated)

A **production-ready Flutter boilerplate** built for real apps — not experiments.

This repository is intentionally **opinionated**, highly structured, and optimized for **scalability, maintainability, and developer experience**.

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
- Reduce architectural decision fatigue
- Scale cleanly as the app grows
- Catch mistakes early via structure and rules

If you’re looking for flexibility, this repo is **not for you**.

---

## ❌ What This Is NOT

- ❌ A tutorial  
- ❌ A pattern comparison playground  
- ❌ A “choose your own architecture” template  

If you disagree with the decisions here, **fork the repo** and adjust it to your needs.

---

## 🧱 Core Architectural Rules (Non-Negotiable)

- ✅ `AsyncNotifier` only (`@riverpod`)
- ❌ No `StateNotifier`
- ❌ No `ChangeNotifier`
- ✅ Repositories return `Result<T>`
- ✅ UI consumes `AsyncValue<T>`
- ✅ `GoRouter` with `ShellRoute` is mandatory
- ✅ Feature isolation is enforced
- ❌ No `Dio` usage outside the data layer

These rules are enforced by **structure, conventions, and reviews** — not documentation alone.

---

## 📁 Folder Structure

```txt
lib/
├── app/        # App bootstrap, routing, providers
├── core/       # Shared infrastructure & utilities
└── features/   # Feature modules (isolated by design)
