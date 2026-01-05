import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/app/app.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';

void main() {
  setUpAll(() {
    // Initialize environment before tests
    EnvConfig.initialize(environment: Environment.dev);
  });

  testWidgets('App boots without crashing', (tester) async {
    // Use runAsync to handle real async operations (like timers in SplashPage)
    await tester.runAsync(() async {
      await tester.pumpWidget(const ProviderScope(child: App()));

      // Wait for the splash page timer to complete
      await Future<void>.delayed(const Duration(seconds: 1));
      await tester.pump();
    });

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
