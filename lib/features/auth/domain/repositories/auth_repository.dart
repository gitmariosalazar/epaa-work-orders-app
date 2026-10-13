import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/entities/verify_user_result.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';

abstract interface class AuthRepository {
  FutureData<UserData> login(Authentication authentication);
  FutureBool saveUserData(UserData userData);
  FutureData<UserData> getUserData();
  FutureBool checkAuth();
  FutureBool removeUserData();

  FutureBool logout();
  FutureData<UserData> refreshToken(String refreshToken);
  FutureData<VerifyUserResult> verifyUser(String usernameOrEmail);
  FutureBool changePassword(String userId, ChangePasswordRequest request);
}
