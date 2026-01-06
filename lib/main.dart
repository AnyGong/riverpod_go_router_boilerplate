import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_go_router_boilerplate/app/bootstrap.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/theme/theme_notifier.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/connectivity.dart';

void main() async {
  // Initialize app with environment configuration
  await AppBootstrap.initialize(
    environment: Environment.dev, // Change based on build flavor
  );

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize connectivity service
  final connectivityService = ConnectivityService();
  await connectivityService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        connectivityServiceProvider.overrideWithValue(connectivityService),
      ],
      child: const AppBootstrap(),
    ),
  );
}

// Alternative: Use runGuardedApp for additional error catching
// void main() {
//   runGuardedApp(
//     app: const ProviderScope(child: AppBootstrap()),
//     environment: Environment.dev,
//   );
// }
