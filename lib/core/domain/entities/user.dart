import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final List<String> roles;
  final List<String> permissions;
  final bool isActive;

  const User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.roles,
    required this.permissions,
    required this.isActive,
  });

  const User.empty()
    : userId = "",
      firstName = "",
      lastName = "",
      username = "",
      email = "",
      roles = const [],
      permissions = const [],
      isActive = false;

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    username,
    email,
    roles,
    permissions,
    isActive,
  ];
}
