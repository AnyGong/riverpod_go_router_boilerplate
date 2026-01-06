import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/network/api_client.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_mock.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_remote.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Provider for the auth repository.
///
/// Automatically switches between mock and remote implementation
/// based on the current environment:
/// - Development/Staging: Uses [AuthRepositoryMock]
/// - Production: Uses [AuthRepositoryRemote]
///
/// To force a specific implementation, override this provider in tests:
/// ```dart
/// ProviderScope(
///   overrides: [
///     authRepositoryProvider.overrideWithValue(AuthRepositoryMock(...)),
///   ],
///   child: MyApp(),
/// )
/// ```
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);

  // Use mock repository for development and staging
  if (EnvConfig.useMockRepositories) {
    return AuthRepositoryMock(secureStorage: secureStorage);
  }

  // Use real repository for production
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepositoryRemote(apiClient: apiClient, secureStorage: secureStorage);
});
