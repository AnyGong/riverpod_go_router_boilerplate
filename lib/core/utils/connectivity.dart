import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity status representing network state
enum ConnectivityStatus { connected, disconnected }

/// Service for monitoring network connectivity.
///
/// Usage:
/// ```dart
/// final isOnline = ref.watch(isOnlineProvider);
/// final status = ref.watch(connectivityStatusProvider);
/// ```
class ConnectivityService {
  ConnectivityService() : _connectivity = Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _statusController = StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get statusStream => _statusController.stream;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    _emitStatus(results);

    _subscription = _connectivity.onConnectivityChanged.listen(_emitStatus);
  }

  void _emitStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) => result != ConnectivityResult.none);
    _statusController.add(
      hasConnection ? ConnectivityStatus.connected : ConnectivityStatus.disconnected,
    );
  }

  /// Check current connectivity status
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Dispose the service
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for connectivity status stream
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});

/// Provider for checking if device is online
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.maybeWhen(
    data: (s) => s == ConnectivityStatus.connected,
    orElse: () => true, // Assume connected if unknown
  );
});
