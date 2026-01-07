// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the Dio HTTP client.
///
/// Uses native platform adapters for optimal performance:
/// - Android: Cronet (HTTP/3, QUIC, Brotli compression)
/// - iOS/macOS: NSURLSession (HTTP/3, system proxy support)
///
/// keepAlive: true ensures Dio instance is not disposed when no longer watched.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Provider for the Dio HTTP client.
///
/// Uses native platform adapters for optimal performance:
/// - Android: Cronet (HTTP/3, QUIC, Brotli compression)
/// - iOS/macOS: NSURLSession (HTTP/3, system proxy support)
///
/// keepAlive: true ensures Dio instance is not disposed when no longer watched.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Provider for the Dio HTTP client.
  ///
  /// Uses native platform adapters for optimal performance:
  /// - Android: Cronet (HTTP/3, QUIC, Brotli compression)
  /// - iOS/macOS: NSURLSession (HTTP/3, system proxy support)
  ///
  /// keepAlive: true ensures Dio instance is not disposed when no longer watched.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'8f00f69b0b3ce69707f0884e5d7d6da010396ff2';
