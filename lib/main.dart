import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/bootstrap.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';

void main() async {
  // Initialize app with environment configuration
  await AppBootstrap.initialize(
    environment: Environment.dev, // Change based on build flavor
  );

  runApp(const ProviderScope(child: AppBootstrap()));
}

// Alternative: Use runGuardedApp for additional error catching
// void main() {
//   runGuardedApp(
//     app: const ProviderScope(child: AppBootstrap()),
//     environment: Environment.dev,
//   );
// }
