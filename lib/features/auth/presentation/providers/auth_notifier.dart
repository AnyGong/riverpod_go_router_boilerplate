import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';

part 'auth_notifier.g.dart';

/// Manages authentication state.
///
/// Use this to:
/// - Check if user is logged in
/// - Login/logout
/// - Access current user
///
/// ## Why `keepAlive: true`?
///
/// Auth state should persist for the entire app lifecycle because:
/// - Auth state is needed across all screens for route guards
/// - Prevents unnecessary session restoration on every navigation
/// - Session should survive screen transitions
///
/// **Note:** Most presentation-layer providers (ViewModels, page-specific notifiers)
/// should NOT use `keepAlive: true`. Use `autoDispose` (default) to free memory
/// when the user navigates away. Only use `keepAlive` for:
/// - Global app state (auth, theme, user preferences)
/// - Expensive services (network clients, database connections)
/// - State that must survive navigation (audio player, download manager)
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _repo;

  @override
  Future<User?> build() async {
    _repo = ref.watch(authRepositoryProvider);

    final result = await _repo.restoreSession();
    return result.dataOrNull;
  }

  /// Attempt to login with credentials.
  Future<void> login(final String email, final String password) async {
    state = const AsyncLoading();

    final result = await _repo.login(email, password);

    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (final error) => AsyncError(error, StackTrace.current),
    );
  }

  /// Logout the current user.
  Future<void> logout() async {
    final result = await _repo.logout();

    result.fold(
      onSuccess: (_) => state = const AsyncData(null),
      onFailure: (final error) {
        // Still clear local state even if server logout fails
        state = const AsyncData(null);
        if (kDebugMode) {
          debugPrint('Logout error: ${error.message}');
        }
      },
    );
  }

  /// Check if user is currently authenticated.
  bool get isAuthenticated => state.value != null;

  /// Get the current user, or null if not authenticated.
  User? get currentUser => state.value;
}
