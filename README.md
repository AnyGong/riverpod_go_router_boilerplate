<div align="center">

# 🚀 Flutter Riverpod Boilerplate

### A Production-Ready, Opinionated Flutter Starter Template

![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-3.x-0553B1?style=for-the-badge)
![GoRouter](https://img.shields.io/badge/GoRouter-13.x-4CAF50?style=for-the-badge)
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
- [Commands](#-commands)
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

</td>
<td width="50%">

### ❌ This Is NOT...

- A tutorial or learning resource
- A minimal starter (it's comprehensive)
- A flexible "choose your own adventure" template

</td>
</tr>
</table>

> 💡 **Philosophy**: This boilerplate enforces **feature-first Clean Architecture** and **Riverpod Code Generation** to ensure consistency.

---

## ✨ Features

<table>
<tr>
<td width="33%">

### 🏗️ Architecture

- ✅ Feature-first Clean Architecture
- ✅ Riverpod 3.x (Codegen)
- ✅ Dependency Injection
- ✅ Result Pattern (Monad)
- ✅ Strict Lints & Rules

</td>
<td width="33%">

### 📱 State & Navigation

- ✅ Type-safe GoRouter
- ✅ Auth Guards & Redirects
- ✅ Deep Links (Universal Links)
- ✅ Event-driven Startup Logic
- ✅ Reactive Forms

</td>
<td width="33%">

### 🌐 Networking

- ✅ Dio with Interceptors
- ✅ Offline-First Caching (Drift)
- ✅ Token Refresh & Retry
- ✅ HTTP/3 & Brotli Support

</td>
</tr>
<tr>
<td width="33%">

### 💾 Storage

- ✅ Secure Storage (Encrypted)
- ✅ SQLite (Drift)
- ✅ SharedPreferences
- ✅ ETag Support

</td>
<td width="33%">

### 🔐 Security & Auth

- ✅ Biometric Auth (Face/Touch ID)
- ✅ Secure Token Management
- ✅ Auto-Session Expiry

</td>
<td width="33%">

### 🎨 UI/UX

- ✅ Material 3 Theming
- ✅ Light/Dark/System Modes
- ✅ Custom Hooks & Animations
- ✅ Localized (en/bn)

</td>
</tr>
</table>

---

## 🛠️ Tech Stack

| Category       | Technology                  | Description                      |
| :------------- | :-------------------------- | :------------------------------- |
| **State**      | `riverpod_generator`        | Compile-safe state management    |
| **Routing**    | `go_router`                 | Declarative routing              |
| **Network**    | `dio` + `drift`             | HTTP client with offline caching |
| **Forms**      | `reactive_forms`            | Reactive form validation         |
| **Auth**       | `local_auth`                | Biometrics                       |
| **I18n**       | `flutter_localizations`     | Intl with ARB files              |
| **Code Style** | `very_good_analysis`        | Strict lint rules                |
| **Testing**    | `mocktail` + `flutter_test` | Unit & Widget tests              |

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK **3.19+**
- Dart SDK **3.x**

### 🆕 Creating a New Project

1. **Clone the repo:**

   ```bash
   git clone https://github.com/ShahriarHossainRifat/riverpod_go_router_boilerplate.git my_app
   cd my_app
   ```

2. **Clean history & Initialize:**

   ```bash
   rm -rf .git && git init
   ```

3. **Rename Project:**

   ```bash
   make rename NAME=my_app ORG=com.example DISPLAY="My Awesome App"
   ```

4. **Setup & Run:**
   ```bash
   make prepare  # Installs deps & generates code
   flutter run
   ```

---

## 🏛️ Architecture

We follow a strict **Feature-First Clean Architecture**:

```
lib/features/my_feature/
├── data/                  # 💾 Data Layer
│   ├── datasources/       # API/DB calls
│   ├── models/            # DTOs (Data Transfer Objects)
│   └── repositories/      # Repository Implementations
│
├── domain/                # 🧠 Domain Layer (Pure Dart)
│   ├── entities/          # Business Objects
│   └── repositories/      # Repository Interfaces
│
└── presentation/          # 🎨 Context Layer
    ├── pages/             # Scaffold Widgets
    ├── providers/         # Riverpod Notifiers
    └── widgets/           # Feature-specific Widgets
```

### Key Rules

1. **Dependency Rule**: `Domain` depends on nothing. `Data` depends on `Domain`. `Presentation` depends on both.
2. **Logic Placement**: Business logic goes in **Notifiers** or **UseCases** (Services). Never in UI.
3. **State**: strictly use `@riverpod` codegen. No `StateProvider` or `ChangeNotifier`.

---

## 📁 Project Structure

```
lib/
├── app/                   # Global app config (Theme, Router, Startup)
├── config/                # Environment config (Env vars)
├── core/                  # Shared kernel (Network, Storage, Utils, Widgets)
├── features/              # Feature modules (Auth, Home, Settings)
├── l10n/                  # Localization ARB files
└── main.dart              # Entry point
```

---

## 💻 Commands

We use `make` to simplify common tasks.

| Command        | Description                            |
| :------------- | :------------------------------------- |
| `make prepare` | Full setup: Clean + L10n + Gen Code    |
| `make gen`     | Run code gen (build_runner + l10n)     |
| `make l10n`    | Generate localization files only       |
| `make watch`   | Run `build_runner watch` (Development) |
| `make clean`   | Clean build artifacts & deps           |
| `make format`  | Format code & Apply fixes              |
| `make lint`    | Run static analysis                    |
| `make test`    | Run all tests                          |
| `make upgrade` | Upgrade dependencies                   |
| `make ci`      | Run CI checks (Lint + Test)            |
| `make feature` | Create a new feature (requires NAME)   |
| `make help`    | Show all commands                      |

### Adding a New Feature

You can use the `make` command to scaffold a new feature:

```bash
make feature NAME=profile
```

Or use the script directly:

```bash
./scripts/create_feature.sh profile
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
