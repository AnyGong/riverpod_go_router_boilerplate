import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_freezed.freezed.dart';
part 'user_freezed.g.dart';

/// Represents an authenticated user.
///
/// This is a freezed model with automatic:
/// - Equality
/// - copyWith
/// - JSON serialization
///
/// Run `dart run build_runner build` to generate the files.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    @Default(false) bool isEmailVerified,
    DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Example of a union type for API response
@freezed
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({required T data}) = ApiSuccess<T>;
  const factory ApiResponse.error({required String message, String? code}) = ApiError<T>;
  const factory ApiResponse.loading() = ApiLoading<T>;
}
