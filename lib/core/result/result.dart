/// A type-safe Result monad for handling success/failure outcomes.
/// Use this instead of throwing exceptions for expected failures.
sealed class Result<T> {
  const Result();

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [Failure].
  bool get isFailure => this is Failure<T>;

  /// Returns the data if [Success], otherwise returns null.
  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  /// Returns the error if [Failure], otherwise returns null.
  AppException? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  /// Pattern match on the result.
  ///
  /// ```dart
  /// final result = await repository.fetchUser();
  /// result.fold(
  ///   onSuccess: (user) => print(user.name),
  ///   onFailure: (error) => print(error.message),
  /// );
  /// ```
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  }) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Failure(:final error) => onFailure(error),
    };
  }

  /// Transform the success value.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Success(transform(data)),
      Failure(:final error) => Failure(error),
    };
  }

  /// Chain another Result-returning operation.
  Future<Result<R>> flatMap<R>(Future<Result<R>> Function(T data) transform) async {
    return switch (this) {
      Success(:final data) => transform(data),
      Failure(:final error) => Failure(error),
    };
  }

  /// Returns the data or throws the error.
  T getOrThrow() {
    return switch (this) {
      Success(:final data) => data,
      Failure(:final error) => throw error,
    };
  }

  /// Returns the data or a default value.
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success(:final data) => data,
      Failure() => defaultValue,
    };
  }
}

/// Represents a successful result with data.
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result with an error.
final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppException error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && runtimeType == other.runtimeType && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Base exception class for all app exceptions.
/// Extend this for specific error types.
sealed class AppException implements Exception {
  const AppException({required this.message, this.code, this.stackTrace});

  final String message;
  final String? code;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Network-related exceptions.
final class NetworkException extends AppException {
  const NetworkException({required super.message, super.code, super.stackTrace, this.statusCode});

  final int? statusCode;

  factory NetworkException.noConnection() =>
      const NetworkException(message: 'No internet connection', code: 'NO_CONNECTION');

  factory NetworkException.timeout() =>
      const NetworkException(message: 'Request timed out', code: 'TIMEOUT');

  factory NetworkException.serverError([int? statusCode]) => NetworkException(
    message: 'Server error occurred',
    code: 'SERVER_ERROR',
    statusCode: statusCode,
  );

  factory NetworkException.unauthorized() =>
      const NetworkException(message: 'Unauthorized access', code: 'UNAUTHORIZED', statusCode: 401);
}

/// Authentication-related exceptions.
final class AuthException extends AppException {
  const AuthException({required super.message, super.code, super.stackTrace});

  factory AuthException.invalidCredentials() =>
      const AuthException(message: 'Invalid email or password', code: 'INVALID_CREDENTIALS');

  factory AuthException.sessionExpired() =>
      const AuthException(message: 'Session expired. Please login again', code: 'SESSION_EXPIRED');

  factory AuthException.noSession() =>
      const AuthException(message: 'No active session', code: 'NO_SESSION');
}

/// Validation-related exceptions.
final class ValidationException extends AppException {
  const ValidationException({required super.message, super.code, super.stackTrace, this.field});

  final String? field;
}

/// Cache/Storage-related exceptions.
final class CacheException extends AppException {
  const CacheException({required super.message, super.code, super.stackTrace});
}

/// Generic unexpected exception.
final class UnexpectedException extends AppException {
  const UnexpectedException({
    required super.message,
    super.code,
    super.stackTrace,
    this.originalError,
  });

  final Object? originalError;
}
