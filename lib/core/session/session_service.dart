import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session_state.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/auth.dart';

/// Service abstraction that provides session status to the rest of the app.
///
/// This decouples consumers (like startup) from the auth implementation.
/// The session service:
/// - Watches the auth state
/// - Translates it into a clean SessionState
/// - Handles session expiry detection
/// - Could be extended to handle token refresh, session validation, etc.
class SessionService {
  const SessionService(this._ref);

  final Ref _ref;

  /// Get the current session state.
  ///
  /// This transforms the auth AsyncValue into a clean SessionState
  /// that abstracts away Riverpod-specific details.
  SessionState get currentState {
    final authState = _ref.read(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SessionInactive();
        }
        return SessionActive(
          userId: user.id,
          // In a real app, you'd extract expiry from the token
          expiresAt: null,
        );
      },
      loading: () => const SessionLoading(),
      error: (error, _) {
        // Auth errors typically mean session is invalid
        if (error is AuthException) {
          return SessionExpired(reason: error.message);
        }
        return const SessionInactive();
      },
    );
  }

  /// Stream of session state changes for reactive consumers.
  ///
  /// This is useful for components that need to react to session changes
  /// without polling.
  Stream<SessionState> get stateChanges async* {
    // Initial state
    yield currentState;

    // This would be connected to auth state changes in a real implementation
    // For now, it yields the current state
  }

  /// Check if the current session is valid.
  ///
  /// This could be extended to perform token validation, refresh, etc.
  Future<bool> validateSession() async {
    final state = currentState;
    if (state is SessionActive) {
      // Could add token validation logic here
      // For now, just check if not expired
      return !state.isExpiringSoon;
    }
    return false;
  }

  /// Attempt to restore a session from stored credentials.
  ///
  /// Returns true if a session was successfully restored.
  Future<bool> restoreSession() async {
    // The auth notifier automatically restores session on init
    // This is a hook for explicit restoration if needed
    return currentState.isAuthenticated;
  }

  /// End the current session.
  ///
  /// This delegates to auth but provides a clean abstraction.
  Future<void> endSession() async {
    final notifier = _ref.read(authNotifierProvider.notifier);
    await notifier.logout();
  }
}

/// Provider for the SessionService.
///
/// This is the main entry point for session-related operations.
final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(ref);
});

/// Provider that exposes the current session state reactively.
///
/// Use this when you need to watch session state changes.
final sessionStateProvider = Provider<SessionState>((ref) {
  // Watch auth state to rebuild when it changes
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
