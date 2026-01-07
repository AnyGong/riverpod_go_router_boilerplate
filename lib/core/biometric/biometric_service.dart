import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'biometric_service.g.dart';

/// Storage key for biometric authentication preference.
const _biometricEnabledKey = 'biometric_enabled';

/// Result of a biometric authentication attempt.
enum BiometricResult {
  /// Authentication was successful.
  success,

  /// User cancelled the authentication.
  cancelled,

  /// Authentication failed (wrong fingerprint, face, etc.).
  failed,

  /// Biometric authentication is not available on this device.
  notAvailable,

  /// Biometric authentication is not set up on this device.
  notEnrolled,

  /// Device security is not set up (no passcode/PIN).
  noDeviceSecurity,

  /// Too many failed attempts, locked out.
  lockedOut,

  /// Permanent lockout (requires device unlock).
  permanentlyLockedOut,

  /// An unknown error occurred.
  error,
}

/// Service for biometric authentication (fingerprint, Face ID).
///
/// ## Setup Required:
///
/// ### iOS
/// Add to `Info.plist` (already added):
/// ```xml
/// <key>NSFaceIDUsageDescription</key>
/// <string>Use Face ID to securely authenticate and access the app.</string>
/// ```
///
/// ### Android
/// Add to `AndroidManifest.xml`:
/// ```xml
/// <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
/// ```
///
/// ## Usage:
///
/// ```dart
/// // Check if biometric auth is available
/// final isAvailable = await ref.read(biometricServiceProvider).isAvailable();
///
/// // Authenticate user
/// final result = await ref.read(biometricServiceProvider).authenticate(
///   reason: 'Please authenticate to access your account',
/// );
///
/// if (result == BiometricResult.success) {
///   // User authenticated successfully
/// }
///
/// // Enable/disable biometric auth preference
/// await ref.read(biometricServiceProvider).setBiometricEnabled(true);
///
/// // Check if user has enabled biometric auth
/// final isEnabled = await ref.read(biometricServiceProvider).isBiometricEnabled();
/// ```
@Riverpod(keepAlive: true)
BiometricService biometricService(final Ref ref) {
  return BiometricService(ref);
}

/// Provider for checking available biometric types.
@riverpod
Future<List<BiometricType>> availableBiometrics(final Ref ref) async {
  final service = ref.watch(biometricServiceProvider);
  return service.getAvailableBiometrics();
}

/// Provider for checking if biometric auth is available and enrolled.
@riverpod
Future<bool> canUseBiometrics(final Ref ref) async {
  final service = ref.watch(biometricServiceProvider);
  return service.isAvailable();
}

/// Provider for checking if user has enabled biometric auth in settings.
@riverpod
Future<bool> biometricEnabled(final Ref ref) async {
  final service = ref.watch(biometricServiceProvider);
  return service.isBiometricEnabled();
}

/// Biometric authentication service using local_auth.
class BiometricService {
  BiometricService(this._ref);

  final Ref _ref;
  final LocalAuthentication _auth = LocalAuthentication();

  AppLogger get _logger => _ref.read(loggerProvider);

  /// Check if biometric authentication is available on this device.
  ///
  /// Returns true if:
  /// - The device supports biometrics (hardware exists)
  /// - Biometrics are enrolled (fingerprint/face registered)
  Future<bool> isAvailable() async {
    try {
      // Check if device supports biometrics
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate = await _auth.isDeviceSupported();

      if (!canAuthenticateWithBiometrics || !canAuthenticate) {
        return false;
      }

      // Check if any biometrics are enrolled
      final availableBiometrics = await _auth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } on PlatformException catch (e) {
      _logger.e('Error checking biometric availability', error: e);
      return false;
    }
  }

  /// Get the list of available biometric types on this device.
  ///
  /// Returns a list that may contain:
  /// - [BiometricType.fingerprint]
  /// - [BiometricType.face]
  /// - [BiometricType.iris]
  /// - [BiometricType.strong] (Android only, strong biometric)
  /// - [BiometricType.weak] (Android only, weak biometric)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      _logger.e('Error getting available biometrics', error: e);
      return [];
    }
  }

  /// Check if the device has Face ID (iOS) or face recognition (Android).
  Future<bool> hasFaceId() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  /// Check if the device has fingerprint/Touch ID.
  Future<bool> hasFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint);
  }

  /// Authenticate the user using biometrics.
  ///
  /// [reason] - The message shown to the user explaining why authentication is needed.
  /// [biometricOnly] - If true, only biometrics can be used (no PIN fallback).
  /// [sensitiveTransaction] - If true, requires strong authentication (Android).
  ///
  /// Returns a [BiometricResult] indicating the outcome.
  Future<BiometricResult> authenticate({
    required final String reason,
    final bool biometricOnly = false,
    final bool sensitiveTransaction = true,
  }) async {
    try {
      // Check availability first
      if (!await isAvailable()) {
        return BiometricResult.notAvailable;
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
      );

      if (didAuthenticate) {
        _logger.d('Biometric authentication successful');
        return BiometricResult.success;
      } else {
        _logger.d('Biometric authentication failed');
        return BiometricResult.failed;
      }
    } on PlatformException catch (e) {
      _logger.e('Biometric authentication error', error: e);
      return _handlePlatformException(e);
    }
  }

  /// Cancel any ongoing authentication.
  ///
  /// Useful when navigating away from the authentication screen.
  Future<bool> cancelAuthentication() async {
    try {
      return await _auth.stopAuthentication();
    } catch (e) {
      _logger.e('Error cancelling authentication', error: e);
      return false;
    }
  }

  /// Check if the user has enabled biometric authentication in app settings.
  Future<bool> isBiometricEnabled() async {
    final storage = _ref.read(secureStorageProvider);
    final value = await storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  /// Enable or disable biometric authentication preference.
  ///
  /// This only stores the preference; actual biometric enrollment
  /// is managed by the device settings.
  Future<void> setBiometricEnabled(final bool enabled) async {
    final storage = _ref.read(secureStorageProvider);
    await storage.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
    _logger.d('Biometric preference set to: $enabled');
  }

  /// Authenticate if biometric is enabled, otherwise return success.
  ///
  /// Use this for optional biometric gates (e.g., app unlock).
  Future<BiometricResult> authenticateIfEnabled({
    required final String reason,
  }) async {
    final isEnabled = await isBiometricEnabled();
    if (!isEnabled) {
      return BiometricResult.success;
    }
    return authenticate(reason: reason);
  }

  /// Handle platform-specific exceptions and map to [BiometricResult].
  BiometricResult _handlePlatformException(final PlatformException e) {
    // See: https://pub.dev/packages/local_auth#error-handling
    return switch (e.code) {
      'NotAvailable' => BiometricResult.notAvailable,
      'NotEnrolled' => BiometricResult.notEnrolled,
      'LockedOut' => BiometricResult.lockedOut,
      'PermanentlyLockedOut' => BiometricResult.permanentlyLockedOut,
      'PasscodeNotSet' => BiometricResult.noDeviceSecurity,
      'OtherOperatingSystem' => BiometricResult.notAvailable,
      _ when e.message?.contains('cancel') ?? false =>
        BiometricResult.cancelled,
      _ => BiometricResult.error,
    };
  }
}

/// Extension for convenient result checking.
extension BiometricResultExtension on BiometricResult {
  /// Whether the authentication was successful.
  bool get isSuccess => this == BiometricResult.success;

  /// Whether the user cancelled the authentication.
  bool get isCancelled => this == BiometricResult.cancelled;

  /// Whether biometrics are unavailable or not set up.
  bool get isUnavailable =>
      this == BiometricResult.notAvailable ||
      this == BiometricResult.notEnrolled ||
      this == BiometricResult.noDeviceSecurity;

  /// Whether there was a lockout due to too many failed attempts.
  bool get isLockedOut =>
      this == BiometricResult.lockedOut ||
      this == BiometricResult.permanentlyLockedOut;

  /// Get a user-friendly message for this result.
  String get message {
    return switch (this) {
      BiometricResult.success => 'Authentication successful',
      BiometricResult.cancelled => 'Authentication cancelled',
      BiometricResult.failed => 'Authentication failed',
      BiometricResult.notAvailable => 'Biometric authentication not available',
      BiometricResult.notEnrolled =>
        'No biometrics enrolled. Please set up fingerprint or face recognition in device settings.',
      BiometricResult.noDeviceSecurity =>
        'Device security not set up. Please set a PIN or password in device settings.',
      BiometricResult.lockedOut => 'Too many attempts. Please try again later.',
      BiometricResult.permanentlyLockedOut =>
        'Biometrics locked. Please unlock your device first.',
      BiometricResult.error => 'An error occurred. Please try again.',
    };
  }
}
