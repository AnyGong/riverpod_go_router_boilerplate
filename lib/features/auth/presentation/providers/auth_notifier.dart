import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<User?> {
  final _repo = AuthRepositoryImpl();

  @override
  Future<User?> build() async {
    final result = await _repo.restoreSession();
    return result is Success<User> ? result.data : null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final result = await _repo.login(email, password);

    state = result is Success<User>
        ? AsyncData(result.data)
        : AsyncError((result as FailureResult).message, StackTrace.current);
  }
}
