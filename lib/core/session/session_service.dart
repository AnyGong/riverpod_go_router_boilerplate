import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session_state.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/auth.dart';

/// Provider that exposes the current session state reactively.
///
/// Use this when you need to watch session state changes.
/// This is the single source of truth for session state.
final sessionStateProvider = Provider<SessionState>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return const SessionInactive();
      }
      return SessionActive(userId: user.id);
    },
    loading: () => const SessionLoading(),
    error: (error, _) {
      if (error is AuthException) {
        return SessionExpired(reason: error.message);
      }
      return const SessionInactive();
    },
  );
});

/// Provider that indicates whether user is authenticated.
///
/// Simple boolean for convenience in guards and conditionals.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(sessionStateProvider).isAuthenticated;
});

/// Service for session operations.
///
/// Use [sessionStateProvider] for reactive state.
/// Use this service for imperative operations like ending session.
class SessionService {
  const SessionService(this._ref);

  final Ref _ref;

  /// Get the current session state (non-reactive).
  SessionState get currentState => _ref.read(sessionStateProvider);

  /// Check if the current session is valid.
  Future<bool> validateSession() async {
    final state = currentState;
    if (state is SessionActive) {
      return !state.isExpiringSoon;
    }
    return false;
  }

  /// End the current session (logout).
  Future<void> endSession() async {
    final notifier = _ref.read(authNotifierProvider.notifier);
    await notifier.logout();
  }
}

/// Provider for the SessionService.
final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(ref);
});
