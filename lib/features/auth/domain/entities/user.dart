import 'package:flutter/foundation.dart';

/// Represents an authenticated user.
@immutable
class User {
  const User({required this.id, required this.email, this.name, this.avatarUrl});

  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  /// Create a User from JSON response.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Convert User to JSON for storage.
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'avatar_url': avatarUrl};
  }

  /// Create a copy with modified fields.
  User copyWith({String? id, String? email, String? name, String? avatarUrl}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode => Object.hash(id, email, name, avatarUrl);

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';
}
