import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/network/api_client.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

/// Provider for the auth repository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

/// Implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required ApiClient apiClient, required this.secureStorage})
    : _apiClient = apiClient;

  final ApiClient _apiClient;
  final dynamic secureStorage;

  @override
  Future<Result<User>> login(String email, String password) async {
    // TODO: Replace with actual API call
    // final result = await _apiClient.post<Map<String, dynamic>>(
    //   '/auth/login',
    //   data: {'email': email, 'password': password},
    //   fromJson: (json) => json as Map<String, dynamic>,
    // );
    //
    // return result.fold(
    //   onSuccess: (data) async {
    //     await secureStorage.write(
    //       key: StorageKeys.accessToken,
    //       value: data['token'] as String,
    //     );
    //     return Success(User.fromJson(data['user'] as Map<String, dynamic>));
    //   },
    //   onFailure: (error) => Failure(error),
    // );

    // Mock implementation for boilerplate
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Simulate storing token
    await secureStorage.write(
      key: StorageKeys.accessToken,
      value: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );

    return Success(User(id: '1', email: email, name: 'Test User'));
  }

  @override
  Future<Result<User>> restoreSession() async {
    final token = await secureStorage.read(key: StorageKeys.accessToken);

    if (token == null) {
      return Failure(AuthException.noSession());
    }

    // TODO: Replace with actual API call to validate token
    // return _apiClient.get<User>(
    //   '/auth/me',
    //   fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
    // );

    // Mock implementation for boilerplate
    return Failure(AuthException.noSession());
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await secureStorage.delete(key: StorageKeys.accessToken);
      await secureStorage.delete(key: StorageKeys.refreshToken);
      await secureStorage.delete(key: StorageKeys.userId);
      return const Success(null);
    } catch (e, stackTrace) {
      return Failure(CacheException(message: 'Failed to clear session', stackTrace: stackTrace));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: StorageKeys.accessToken);
    return token != null;
  }

  // Keep reference to apiClient for future use
  ApiClient get apiClient => _apiClient;
}
