/// Session management module.
///
/// Provides:
/// - [SessionState] - Sealed class representing session status
/// - [SessionService] - Service for session operations
/// - [sessionStateProvider] - Reactive session state
/// - [isAuthenticatedProvider] - Simple auth check
library;

export 'session_service.dart';
export 'session_state.dart';
