// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(biometricService)
final biometricServiceProvider = BiometricServiceProvider._();

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

final class BiometricServiceProvider
    extends
        $FunctionalProvider<
          BiometricService,
          BiometricService,
          BiometricService
        >
    with $Provider<BiometricService> {
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
  BiometricServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricServiceHash();

  @$internal
  @override
  $ProviderElement<BiometricService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BiometricService create(Ref ref) {
    return biometricService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BiometricService>(value),
    );
  }
}

String _$biometricServiceHash() => r'97a0917f07808518fe8e358cf85ce90f15a9b539';

/// Provider for checking available biometric types.

@ProviderFor(availableBiometrics)
final availableBiometricsProvider = AvailableBiometricsProvider._();

/// Provider for checking available biometric types.

final class AvailableBiometricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BiometricType>>,
          List<BiometricType>,
          FutureOr<List<BiometricType>>
        >
    with
        $FutureModifier<List<BiometricType>>,
        $FutureProvider<List<BiometricType>> {
  /// Provider for checking available biometric types.
  AvailableBiometricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableBiometricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableBiometricsHash();

  @$internal
  @override
  $FutureProviderElement<List<BiometricType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BiometricType>> create(Ref ref) {
    return availableBiometrics(ref);
  }
}

String _$availableBiometricsHash() =>
    r'f34985b5348c5ab879a2f310b6aaa8c6fbbb33cd';

/// Provider for checking if biometric auth is available and enrolled.

@ProviderFor(canUseBiometrics)
final canUseBiometricsProvider = CanUseBiometricsProvider._();

/// Provider for checking if biometric auth is available and enrolled.

final class CanUseBiometricsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for checking if biometric auth is available and enrolled.
  CanUseBiometricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canUseBiometricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canUseBiometricsHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canUseBiometrics(ref);
  }
}

String _$canUseBiometricsHash() => r'8496c8e2e53f0450ac3e37f25ca843ae19e74fa7';

/// Provider for checking if user has enabled biometric auth in settings.

@ProviderFor(biometricEnabled)
final biometricEnabledProvider = BiometricEnabledProvider._();

/// Provider for checking if user has enabled biometric auth in settings.

final class BiometricEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for checking if user has enabled biometric auth in settings.
  BiometricEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return biometricEnabled(ref);
  }
}

String _$biometricEnabledHash() => r'61965eb869f167c7b8c72cc044a1c8634f2c6777';
