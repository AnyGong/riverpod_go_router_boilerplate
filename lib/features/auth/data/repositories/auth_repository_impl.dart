import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Result<User>> login(String email, String password) async {
    return Success(User(id: '1', email: email));
  }

  @override
  Future<Result<User>> restoreSession() async {
    return const FailureResult('No session');
  }
}
