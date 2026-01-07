import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

/// Provider for secure storage instance.
/// Use this for storing sensitive data like tokens.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(final Ref ref) {
  return const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}

/// Storage keys used throughout the app.
abstract class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String onboardingCompleted = 'onboarding_completed';
}
