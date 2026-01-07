import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/cache/cache_service.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/constants.dart';
import 'package:riverpod_go_router_boilerplate/core/network/cache_interceptor.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/connectivity.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'dio_provider.g.dart';

/// Provider for the Dio HTTP client.
///
/// Uses native platform adapters for optimal performance:
/// - Android: Cronet (HTTP/3, QUIC, Brotli compression)
/// - iOS/macOS: NSURLSession (HTTP/3, system proxy support)
///
/// Includes interceptors for:
/// - Authentication (token injection, refresh)
/// - Offline caching (automatic cache for GET requests)
/// - Retry (exponential backoff for failed requests)
/// - Logging (request/response logging in debug mode)
///
/// keepAlive: true ensures Dio instance is not disposed when no longer watched.
@Riverpod(keepAlive: true)
Dio dio(final Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Use native HTTP adapter for better performance (HTTP/3, Brotli, system proxy)
  // Only in release mode to preserve debugging capabilities in development
  if (kReleaseMode) {
    dio.httpClientAdapter = NativeAdapter();
  }

  // Add interceptors in order of execution
  dio.interceptors.addAll([
    // 1. Auth interceptor - adds tokens, handles 401 refresh
    AuthInterceptor(
      ref,
      parentDio: dio,
      // Implement your token refresh logic here:
      // onRefreshToken: (refreshToken, saveTokens) async {
      //   final response = await Dio().post(
      //     '${EnvConfig.baseUrl}/auth/refresh',
      //     data: {'refresh_token': refreshToken},
      //   );
      //   await saveTokens(
      //     response.data['access_token'] as String,
      //     response.data['refresh_token'] as String?,
      //   );
      //   return true;
      // },
    ),
    // 2. Cache interceptor - offline-first caching for GET requests
    CacheInterceptor(
      cacheService: ref.read(cacheServiceProvider),
      connectivityService: ref.read(connectivityServiceProvider),
      logger: EnvConfig.enableLogging ? ref.read(loggerProvider) : null,
    ),
    // 3. Retry interceptor - exponential backoff for failed requests
    RetryInterceptor(dio),
    // 4. Logging interceptor - request/response logging (debug only)
    if (EnvConfig.enableLogging) LoggingInterceptor(ref),
  ]);

  return dio;
}

/// Callback type for token refresh logic.
/// Returns true if refresh was successful, false otherwise.
/// Implement this to call your backend's refresh token endpoint.
typedef TokenRefreshCallback =
    Future<bool> Function(
      String? refreshToken,
      Future<void> Function(String accessToken, String? refreshToken)
      saveTokens,
    );

/// Interceptor for adding authentication headers and handling token refresh.
///
/// The refresh logic is injectable via [onRefreshToken] callback, allowing
/// you to customize the refresh behavior for your specific backend.
///
/// Example:
/// ```dart
/// AuthInterceptor(
///   ref,
///   parentDio: dio,
///   onRefreshToken: (refreshToken, saveTokens) async {
///     final response = await Dio().post('/auth/refresh', data: {'token': refreshToken});
///     await saveTokens(response.data['access_token'], response.data['refresh_token']);
///     return true;
///   },
/// )
/// ```
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(
    this._ref, {
    required this.parentDio,
    this.onRefreshToken,
  });

  final Ref _ref;

  /// The parent Dio instance used for retrying requests.
  /// This ensures retry requests use the same configuration (base URL, timeouts, etc.).
  final Dio parentDio;

  /// Optional callback for custom token refresh logic.
  /// If null, token refresh will always return false.
  final TokenRefreshCallback? onRefreshToken;

  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final response = await _retryRequest(err.requestOptions);
          _isRefreshing = false;
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed - clear tokens and let error propagate
        await _clearTokens();
      }

      _isRefreshing = false;
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final storage = _ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: StorageKeys.refreshToken);

    if (refreshToken == null) return false;

    // If no refresh callback is provided, refresh is not supported
    if (onRefreshToken == null) {
      return false;
    }

    try {
      // Use injectable callback for token refresh
      return await onRefreshToken!(
        refreshToken,
        (final accessToken, final newRefreshToken) async {
          await storage.write(key: StorageKeys.accessToken, value: accessToken);
          if (newRefreshToken != null) {
            await storage.write(
              key: StorageKeys.refreshToken,
              value: newRefreshToken,
            );
          }
        },
      );
    } catch (e) {
      return false;
    }
  }

  /// Retry the original request with the new access token.
  /// Uses [parentDio] to preserve configuration (base URL, timeouts, interceptors).
  Future<Response<dynamic>> _retryRequest(final RequestOptions options) async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);
    options.headers['Authorization'] = 'Bearer $token';
    // IMPORTANT: Use parentDio instead of new Dio() to preserve configuration
    return parentDio.fetch(options);
  }

  Future<void> _clearTokens() async {
    final storage = _ref.read(secureStorageProvider);
    await storage.delete(key: StorageKeys.accessToken);
    await storage.delete(key: StorageKeys.refreshToken);
  }
}

/// Interceptor for retrying failed requests.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxRetries = AppConstants.maxRetryAttempts,
    this.retryDelays,
  });

  final Dio _dio;
  final int maxRetries;
  final List<Duration>? retryDelays;

  static const _retryKey = 'retry_count';

  List<Duration> get _delays => retryDelays ?? AppConstants.retryDelays;

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);
    if (!shouldRetry) {
      return handler.next(err);
    }

    final retryCount = err.requestOptions.extra[_retryKey] as int? ?? 0;
    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Wait before retrying
    final delay = _delays[retryCount.clamp(0, _delays.length - 1)];
    await Future<void>.delayed(delay);

    // Retry the request
    try {
      err.requestOptions.extra[_retryKey] = retryCount + 1;
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(final DioException err) {
    // Only retry on network errors or 5xx server errors
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Interceptor for logging requests and responses.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._ref);
  final Ref _ref;

  AppLogger get _logger => _ref.read(loggerProvider);

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      _logger.d('→ ${options.method} ${options.uri}');
      if (options.data != null) {
        _logger.d('   Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    final Response<dynamic> response,
    final ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      _logger.d('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '✖ ${err.response?.statusCode ?? 'NETWORK'} ${err.requestOptions.uri}',
        error: err.message,
      );
    }
    handler.next(err);
  }
}
