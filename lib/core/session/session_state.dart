/// Session state representing the current user session status.
///
/// This abstracts auth state from the rest of the app, providing a
/// clean interface for components that need to know session status
/// without coupling to auth implementation details.
sealed class SessionState {
  const SessionState();

  /// Whether the user has an active session
  bool get isAuthenticated => switch (this) {
    SessionActive() => true,
    SessionInactive() || SessionExpired() || SessionLoading() => false,
  };

  /// Whether session is being restored/validated
  bool get isLoading => this is SessionLoading;

  /// Whether session has expired (requires re-auth)
  bool get isExpired => this is SessionExpired;
}

/// Session is being restored or validated
final class SessionLoading extends SessionState {
  const SessionLoading();

  @override
  String toString() => 'SessionLoading()';
}

/// User has an active, valid session
final class SessionActive extends SessionState {
  const SessionActive({required this.userId, this.expiresAt});

  final String userId;
  final DateTime? expiresAt;

  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    final timeUntilExpiry = expiresAt!.difference(DateTime.now());
    return timeUntilExpiry.inMinutes < 5;
  }

  @override
  String toString() => 'SessionActive(userId: $userId, expiresAt: $expiresAt)';
}

/// No active session (user logged out or never logged in)
final class SessionInactive extends SessionState {
  const SessionInactive();

  @override
  String toString() => 'SessionInactive()';
}

/// Session expired and needs re-authentication
final class SessionExpired extends SessionState {
  const SessionExpired({this.reason});

  final String? reason;

  @override
  String toString() => 'SessionExpired(reason: $reason)';
}
