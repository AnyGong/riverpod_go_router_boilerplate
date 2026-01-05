import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_go_router_boilerplate/app/app.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';

/// Bootstrap the application.
/// Handles initialization, error handling, and app startup.
class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  /// Initialize the app before running.
  /// Call this before runApp().
  static Future<void> initialize({Environment environment = Environment.dev}) async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize environment configuration
    EnvConfig.initialize(environment: environment);

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

    // Add any other initialization here:
    // - Firebase.initializeApp()
    // - Initialize analytics
    // - Load remote config
    // - etc.
  }

  /// Set up global error handling.
  static void _setupErrorHandling() {
    // Handle Flutter errors
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        // Log to crash reporting service
        _logError(details.exception, details.stack);
      }
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Async error: $error');
        debugPrint('$stack');
      }
      if (kReleaseMode) {
        _logError(error, stack);
      }
      return true;
    };
  }

  /// Log error to crash reporting service.
  /// TODO: Implement with your preferred crash reporting (Firebase Crashlytics, Sentry, etc.)
  static void _logError(Object error, StackTrace? stack) {
    // Example: FirebaseCrashlytics.instance.recordError(error, stack);
    if (kDebugMode) {
      debugPrint('Error logged: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

/// Run a guarded zone for the app.
/// Use this in main() to catch all errors.
Future<void> runGuardedApp({required Widget app, Environment environment = Environment.dev}) async {
  await runZonedGuarded(
    () async {
      await AppBootstrap.initialize(environment: environment);
      runApp(app);
    },
    (error, stack) {
      if (kDebugMode) {
        debugPrint('Uncaught error: $error');
        debugPrint('$stack');
      }
      // Log to crash reporting in production
    },
  );
}
