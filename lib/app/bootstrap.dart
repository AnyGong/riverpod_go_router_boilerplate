import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:hooks_riverpod/hooks_riverpod.dart' show ProviderScope;
import 'package:riverpod_go_router_boilerplate/app/app.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/connectivity.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bootstrap the application.
/// Handles initialization, error handling, and app startup.
class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  /// Initialize the app before running.
  /// Call this before runApp().
  static Future<void> initialize({
    final Environment environment = Environment.dev,
  }) async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize environment configuration
    EnvConfig.initialize(environment: environment);
    AppLogger.instance.i('Environment initialized: ${environment.name}');

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // Set up error handling
    _setupErrorHandling();

    AppLogger.instance.i('App bootstrap completed');

    // Add any other initialization here:
    // - Firebase.initializeApp()
    // - Initialize analytics
    // - Load remote config
    // - etc.
  }

  /// Set up global error handling.
  static void _setupErrorHandling() {
    // Handle Flutter errors
    FlutterError.onError = (final details) {
      FlutterError.presentError(details);
      AppLogger.instance.e(
        'Flutter error: ${details.exceptionAsString()}',
        error: details.exception,
        stackTrace: details.stack,
      );
      if (kReleaseMode) {
        _logToCrashReporting(details.exception, details.stack);
      }
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (final error, final stack) {
      AppLogger.instance.e('Async error', error: error, stackTrace: stack);
      if (kReleaseMode) {
        _logToCrashReporting(error, stack);
      }
      return true;
    };
  }

  /// Log error to crash reporting service.
  /// TODO: Implement with your preferred crash reporting (Firebase Crashlytics, Sentry, etc.)
  static void _logToCrashReporting(
    final Object error,
    final StackTrace? stack,
  ) {
    // Example: FirebaseCrashlytics.instance.recordError(error, stack);
    AppLogger.instance.w('Error sent to crash reporting: $error');
  }

  @override
  Widget build(final BuildContext context) {
    return const App();
  }
}

/// Run a guarded zone for the app with comprehensive error catching.
///
/// This wraps the app in [runZonedGuarded] to catch any uncaught async errors
/// that might otherwise be silently dropped. Use this in production for
/// better error visibility and crash reporting.
///
/// The [appBuilder] callback receives the initialized services and returns
/// the root widget (typically a [ProviderScope] with overrides).
///
/// Example:
/// ```dart
/// void main() {
///   runGuardedApp(
///     environment: Environment.prod,
///     appBuilder: (sharedPrefs, connectivity) => ProviderScope(
///       overrides: [
///         sharedPreferencesProvider.overrideWithValue(sharedPrefs),
///         connectivityServiceProvider.overrideWithValue(connectivity),
///       ],
///       child: const AppBootstrap(),
///     ),
///   );
/// }
/// ```
Future<void> runGuardedApp({
  required final Widget Function(
    SharedPreferences sharedPreferences,
    ConnectivityService connectivity,
  )
  appBuilder,
  final Environment environment = Environment.dev,
}) async {
  await runZonedGuarded(
    () async {
      // Initialize bootstrap (bindings, error handling, etc.)
      await AppBootstrap.initialize(environment: environment);

      // Initialize services that need to be ready before UI
      final sharedPreferences = await SharedPreferences.getInstance();
      final connectivityService = ConnectivityService();
      await connectivityService.initialize();

      // Run the app with initialized services
      runApp(appBuilder(sharedPreferences, connectivityService));
    },
    (final error, final stack) {
      AppLogger.instance.f(
        'Uncaught zone error',
        error: error,
        stackTrace: stack,
      );
      if (kReleaseMode) {
        AppBootstrap._logToCrashReporting(error, stack);
      }
    },
  );
}
