import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/data/models/domain_convertible.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';

class UserResponse implements DomainConvertible<User> {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final List<String> roles;
  final List<String> permissions;
  final bool isActive;

  const UserResponse({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.roles,
    required this.permissions,
    required this.isActive,
  });

  factory UserResponse.fromJson(MapDynamic json) {
    return UserResponse(
      userId: json['userId'] ?? json['user_id'] ?? "",
      firstName: json['firstName'] ?? json['first_name'] ?? "",
      lastName: json['lastName'] ?? json['last_name'] ?? "",
      username: json['username'] ?? "",
      email: json['email'] ?? "",
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map(
                (e) => e is Map ? (e['name']?.toString() ?? '') : e.toString(),
              )
              .toList() ??
          [],
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map(
                (e) => e is Map ? (e['name']?.toString() ?? '') : e.toString(),
              )
              .toList() ??
          [],
      isActive: json['isActive'] ?? json['is_active'] ?? false,
    );
  }

  factory UserResponse.fromDomain(User user) {
    return UserResponse(
      userId: user.userId,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      roles: user.roles,
      permissions: user.permissions,
      isActive: user.isActive,
    );
  }

  MapDynamic toJson() => {
    'userId': userId,
    'firstName': firstName,
    'lastName': lastName,
    'username': username,
    'email': email,
    'roles': roles,
    'permissions': permissions,
    'isActive': isActive,
  };

  @override
  User toDomain() {
    return User(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      roles: roles,
      permissions: permissions,
      isActive: isActive,
    );
  }
}
