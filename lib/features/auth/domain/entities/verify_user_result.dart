import 'package:equatable/equatable.dart';

class VerifyUserResult extends Equatable {
  final bool exists;
  final String? userId;
  final String? username;
  final String? email;
  final bool? isActive;

  const VerifyUserResult({
    required this.exists,
    this.userId,
    this.username,
    this.email,
    this.isActive,
  });

  @override
  List<Object?> get props => [exists, userId, username, email, isActive];
}
