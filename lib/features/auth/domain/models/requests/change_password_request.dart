class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    };
  }
}
