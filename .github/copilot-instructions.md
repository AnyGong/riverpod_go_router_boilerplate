# GitHub Copilot Instructions

This document provides instructions for GitHub Copilot to generate high-quality, consistent code for this Flutter Riverpod boilerplate project.

## Project Overview

This is a **production-ready Flutter boilerplate** using:

- **Flutter 3.10+** with **Dart 3.x**
- **Riverpod 3.x** with code generation (`@riverpod` annotations)
- **GoRouter 17.x** for declarative routing
- **Dio** with native adapters for networking
- **Drift** (SQLite) for local caching
- **Freezed** for immutable models
- **Clean Architecture** (data → domain → presentation)

---

## Code Style Guidelines

### File Length Limits

| File Type               | Target Lines | Max Lines |
| :---------------------- | :----------: | :-------: |
| Models / Entities       |    20–80     |    120    |
| Providers / Notifiers   |    50–120    |    180    |
| Services / Repositories |    50–150    |    200    |
| UI Widgets              |    60–200    |    250    |
| Test files              |    40–200    |    300    |

- **Method length**: < 40 lines (ideal < 20)
- **Split large files** into focused, single-responsibility files

### Naming Conventions

```dart
// ✅ Files: snake_case
user_repository.dart
auth_notifier.dart

// ✅ Classes: PascalCase
class UserRepository {}
class AuthNotifier extends _$AuthNotifier {}

// ✅ Variables/methods: camelCase
final userName = 'John';
Future<void> fetchUser() async {}

// ✅ Constants: lowerCamelCase
const defaultTimeout = Duration(seconds: 30);

// ✅ Private members: _prefix
final _cache = <String, dynamic>{};
void _initializeState() {}

// ✅ Providers: descriptive names without "Provider" suffix for notifiers
@riverpod
class Auth extends _$Auth {}  // Generates authProvider

// ✅ Simple providers: use descriptive function name
@riverpod
ApiClient apiClient(Ref ref) {}  // Generates apiClientProvider
```

---

## Riverpod 3.x Patterns

### ALWAYS Use Code Generation

```dart
// ✅ CORRECT: Use @riverpod annotation
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    return null;
  }
}

// ❌ WRONG: Manual provider declaration (outdated)
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});
```

### Provider Types

```dart
// 1️⃣ Simple synchronous provider
@riverpod
String greeting(Ref ref) => 'Hello';

// 2️⃣ Async provider (auto-disposes)
@riverpod
Future<User> currentUser(Ref ref) async {
  final api = ref.watch(apiClientProvider);
  return api.fetchCurrentUser();
}

// 3️⃣ Async Notifier (stateful + async)
@riverpod
class Products extends _$Products {
  @override
  Future<List<Product>> build() async {
    return _fetchProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProducts());
  }
}

// 4️⃣ Keep-alive provider (persists in memory)
@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  return SessionService(storage: ref.watch(secureStorageProvider));
}
```

### Watching vs Reading Providers

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ watch: Rebuilds widget when state changes
    final user = ref.watch(userProvider);

    // ✅ read: For one-time access (callbacks, onPressed)
    onPressed: () => ref.read(authProvider.notifier).logout(),

    // ❌ WRONG: Don't read in build method
    final user = ref.read(userProvider);  // Won't rebuild!
  }
}
```

### AsyncValue Handling

```dart
// ✅ CORRECT: Use .when() for exhaustive handling
ref.watch(userProvider).when(
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error: error),
  data: (user) => UserCard(user: user),
);

// ✅ Alternative: Use AsyncValueWidget (project utility)
AsyncValueWidget<User>(
  value: ref.watch(userProvider),
  data: (user) => UserCard(user: user),
);

// ✅ For nullable value access
final user = ref.watch(userProvider).valueOrNull;
```

---

## GoRouter Patterns

### Route Definition with Enum

```dart
// ✅ CORRECT: Define routes as enum
enum AppRoute {
  splash('/'),
  login('/login'),
  home('/home'),
  profile('/profile/:userId');  // Dynamic segment

  const AppRoute(this.path);
  final String path;
}
```

### Router Configuration

```dart
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    refreshListenable: ref.watch(appLifecycleListenableProvider),
    redirect: (context, state) => _handleRedirect(ref, state),
    routes: [
      ...authRoutes,
      ...protectedRoutes,
    ],
  );
}
```

### Navigation

```dart
// ✅ Navigate replacing current route
context.go(AppRoute.home.path);

// ✅ Push onto stack (allows back)
context.push(AppRoute.settings.path);

// ✅ Navigate with parameters
context.go('/profile/${user.id}');

// ✅ Navigate with query parameters
context.go('${AppRoute.search.path}?q=flutter');

// ✅ Go back
context.pop();
```

---

## Network Layer Patterns

### API Client Usage

```dart
// ✅ CORRECT: Use ApiClient with Result pattern
final result = await apiClient.get<User>(
  '/users/me',
  fromJson: User.fromJson,
);

result.fold(
  onSuccess: (user) => state = AsyncData(user),
  onFailure: (error) => state = AsyncError(error, StackTrace.current),
);

// ❌ WRONG: Direct Dio usage outside data layer
final response = await dio.get('/users/me');
```

### Repository Pattern

```dart
// ✅ Domain layer: Abstract interface
abstract interface class UserRepository {
  Future<Result<User>> getUser(String id);
  Future<Result<List<User>>> getUsers();
}

// ✅ Data layer: Implementation
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this.apiClient});
  final ApiClient apiClient;

  @override
  Future<Result<User>> getUser(String id) async {
    return apiClient.get<User>(
      '/users/$id',
      fromJson: User.fromJson,
    );
  }
}

// ✅ Provider for repository
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(apiClient: ref.watch(apiClientProvider));
}
```

---

## Model Patterns (Freezed)

### Entity Definition

```dart
// ✅ CORRECT: Use Freezed for immutable models
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? avatarUrl,
    @Default(false) bool isVerified,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### JSON Serialization

```dart
// ✅ Custom JSON key
@JsonKey(name: 'avatar_url')
String? avatarUrl,

// ✅ Custom converter
@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
DateTime createdAt,

// ✅ Ignore field in JSON
@JsonKey(includeFromJson: false, includeToJson: false)
bool isLocal,
```

---

## Result Pattern

### Definition

```dart
// Result is already defined in core/result/result.dart
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  });

  bool get isSuccess;
  bool get isFailure;
}
```

### Usage

```dart
// ✅ CORRECT: Return Result from repository
Future<Result<User>> login(String email, String password) async {
  try {
    final response = await apiClient.post('/auth/login', data: {...});
    return Success(User.fromJson(response.data));
  } on DioException catch (e) {
    return Failure(NetworkException.fromDio(e));
  }
}

// ✅ Handle Result in notifier
final result = await repository.login(email, password);
result.fold(
  onSuccess: (user) {
    state = AsyncData(user);
  },
  onFailure: (error) {
    state = AsyncError(error, StackTrace.current);
  },
);
```

---

## Widget Patterns

### ConsumerWidget (Stateless)

```dart
// ✅ Use ConsumerWidget when reading providers
class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const ShimmerLoading(),
      error: (e, s) => ErrorView(error: e, onRetry: () => ref.invalidate(userProvider)),
      data: (user) => _buildProfile(user),
    );
  }

  Widget _buildProfile(User user) {
    return Column(
      children: [
        Text(user.name),
        Text(user.email),
      ],
    );
  }
}
```

### HookConsumerWidget (with Hooks)

```dart
// ✅ Use HookConsumerWidget when using hooks
class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);

    return Form(
      child: Column(
        children: [
          TextField(controller: emailController),
          TextField(controller: passwordController),
          ElevatedButton(
            onPressed: isLoading.value ? null : () async {
              isLoading.value = true;
              await ref.read(authProvider.notifier).login(
                emailController.text,
                passwordController.text,
              );
              isLoading.value = false;
            },
            child: isLoading.value
              ? const CircularProgressIndicator()
              : const Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Custom Hooks

```dart
// ✅ Create custom hooks for reusable logic
T useDebounced<T>(T value, Duration delay) {
  final debouncedValue = useState(value);

  useEffect(() {
    final timer = Timer(delay, () => debouncedValue.value = value);
    return timer.cancel;
  }, [value, delay]);

  return debouncedValue.value;
}
```

---

## File Organization

### Feature Structure

```
features/
└── your_feature/
    ├── your_feature.dart          # Barrel file (exports all)
    │
    ├── data/
    │   ├── models/                # DTOs (if different from entities)
    │   │   └── user_dto.dart
    │   └── repositories/
    │       └── user_repository_impl.dart
    │
    ├── domain/
    │   ├── entities/
    │   │   └── user.dart          # Freezed models
    │   └── repositories/
    │       └── user_repository.dart  # Abstract interface
    │
    └── presentation/
        ├── pages/
        │   └── user_page.dart
        ├── providers/
        │   └── user_notifier.dart
        └── widgets/
            └── user_card.dart
```

### Barrel Files

```dart
// ✅ CORRECT: Export public APIs only
// features/auth/auth.dart
export 'domain/entities/user.dart';
export 'domain/repositories/auth_repository.dart';
export 'presentation/pages/login_page.dart';
export 'presentation/providers/auth_notifier.dart';

// ❌ WRONG: Don't export implementation details
export 'data/repositories/auth_repository_impl.dart';
```

---

## Testing Patterns

### Unit Test Structure

```dart
void main() {
  group('AuthRepository', () {
    late MockApiClient mockApiClient;
    late AuthRepositoryImpl repository;

    setUp(() {
      mockApiClient = MockApiClient();
      repository = AuthRepositoryImpl(apiClient: mockApiClient);
    });

    tearDown(() {
      // Cleanup if needed
    });

    test('login returns Success with valid credentials', () async {
      // Arrange
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Success(mockUserJson));

      // Act
      final result = await repository.login('test@email.com', 'password');

      // Assert
      expect(result, isA<Success<User>>());
      expect((result as Success).data.email, 'test@email.com');
    });

    test('login returns Failure on network error', () async {
      // Arrange
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(DioException(requestOptions: RequestOptions()));

      // Act
      final result = await repository.login('test@email.com', 'password');

      // Assert
      expect(result, isA<Failure<User>>());
    });
  });
}
```

### Mocking with Mocktail

```dart
import 'package:mocktail/mocktail.dart';

// ✅ Create mock classes
class MockApiClient extends Mock implements ApiClient {}
class MockAuthRepository extends Mock implements AuthRepository {}

// ✅ Register fallback values for custom types
setUpAll(() {
  registerFallbackValue(User(id: '', email: '', name: ''));
});
```

---

## Common Anti-Patterns to Avoid

### ❌ DON'T: Use StateNotifier or ChangeNotifier

```dart
// ❌ WRONG: Old pattern
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);
}

// ✅ CORRECT: Use AsyncNotifier with codegen
@riverpod
class Auth extends _$Auth {
  @override
  Future<User?> build() async => null;
}
```

### ❌ DON'T: Put Business Logic in Widgets

```dart
// ❌ WRONG: Logic in widget
class LoginPage extends ConsumerWidget {
  Future<void> _login(WidgetRef ref) async {
    final response = await dio.post('/login', data: {...});  // Direct API call!
    // Process response...
  }
}

// ✅ CORRECT: Logic in notifier
@riverpod
class Auth extends _$Auth {
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).login(email, password);
    // Handle result...
  }
}
```

### ❌ DON'T: Use Dio Directly Outside Data Layer

```dart
// ❌ WRONG: Dio in presentation layer
final response = await ref.read(dioProvider).get('/users');

// ✅ CORRECT: Use repository
final result = await ref.read(userRepositoryProvider).getUsers();
```

### ❌ DON'T: Throw Exceptions from Repositories

```dart
// ❌ WRONG: Throwing exceptions
Future<User> getUser(String id) async {
  final response = await apiClient.get('/users/$id');
  if (response.statusCode != 200) throw Exception('Failed');
  return User.fromJson(response.data);
}

// ✅ CORRECT: Return Result
Future<Result<User>> getUser(String id) async {
  try {
    return Success(await apiClient.get('/users/$id', fromJson: User.fromJson));
  } catch (e) {
    return Failure(AppException.from(e));
  }
}
```

### ❌ DON'T: Create Providers Without Codegen

```dart
// ❌ WRONG: Manual provider
final userProvider = FutureProvider<User>((ref) async {
  return ref.read(apiClientProvider).fetchUser();
});

// ✅ CORRECT: Use @riverpod annotation
@riverpod
Future<User> user(Ref ref) async {
  return ref.read(apiClientProvider).fetchUser();
}
```

---

## Localization

### Adding New Strings

```json
// lib/l10n/app_en.arb
{
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

### Using Localized Strings

```dart
// ✅ CORRECT: Use context extension
Text(context.l10n.welcomeMessage('John'))

// ✅ Alternative: Direct access
Text(AppLocalizations.of(context).welcomeMessage('John'))
```

---

## Code Generation Commands

```bash
# Generate all (freezed, json_serializable, riverpod, drift)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Clean generated files
dart run build_runner clean
```

---

## Summary

1. **Always use `@riverpod` annotation** for providers
2. **Return `Result<T>`** from repositories, not exceptions
3. **Use `AsyncValue.when()`** for handling async states
4. **Keep business logic in notifiers**, not widgets
5. **Use Freezed** for immutable models
6. **Follow Clean Architecture** (data → domain → presentation)
7. **Keep files under line limits** (split if needed)
8. **Use barrel files** for clean exports
9. **Write tests** for repositories and notifiers
10. **Run `build_runner`** after modifying models or providers
