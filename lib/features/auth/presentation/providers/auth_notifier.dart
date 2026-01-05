import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Provider for the auth state notifier.
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

/// Manages authentication state.
///
/// Use this to:
/// - Check if user is logged in
/// - Login/logout
/// - Access current user
class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _repo;

  @override
  Future<User?> build() async {
    _repo = ref.watch(authRepositoryProvider);

    final result = await _repo.restoreSession();
    return result.dataOrNull;
  }

  /// Attempt to login with credentials.
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await _repo.login(email, password);

    state = result.fold(
      onSuccess: (user) => AsyncData(user),
      onFailure: (error) => AsyncError(error, StackTrace.current),
    );
  }

  /// Logout the current user.
  Future<void> logout() async {
    final result = await _repo.logout();

    result.fold(
      onSuccess: (_) => state = const AsyncData(null),
      onFailure: (error) {
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
