import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Application logger with pretty output in debug mode.
///
/// Usage:
/// ```dart
/// final logger = ref.read(loggerProvider);
/// logger.d('Debug message');
/// logger.i('Info message');
/// logger.w('Warning message');
/// logger.e('Error message', error: exception, stackTrace: stack);
/// ```
class AppLogger {
  AppLogger()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
        level: kDebugMode ? Level.debug : Level.warning,
      );

  final Logger _logger;

  /// Log debug message
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  void i(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  void w(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal message
  void f(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log with custom level
  void logMessage(Level level, String message, {Object? error, StackTrace? stackTrace}) {
    _logger.log(level, message, error: error, stackTrace: stackTrace);
  }
}

/// Provider for the application logger
final loggerProvider = Provider<AppLogger>((ref) => AppLogger());
