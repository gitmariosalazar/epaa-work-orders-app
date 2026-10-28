import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/data/models/requests/authentication_request.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:clean_architecture/features/auth/domain/entities/verify_user_result.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';

import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteDataSource {
  FutureData<UserDataResponse> login(AuthenticationRequest request);
  FutureBool checkAUth();
  FutureBool logout();
  FutureData<UserDataResponse> refreshToken(String refreshToken);
  FutureData<VerifyUserResult> verifyUser(String usernameOrEmail);
  FutureBool changePassword(String userId, ChangePasswordRequest request);
}

@LazySingleton(as: AuthRemoteDataSource)
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _dioClient;

  const AuthRemoteDataSourceImpl({required ApiService dioClient})
    : _dioClient = dioClient;

  @override
  FutureData<UserDataResponse> login(AuthenticationRequest request) {
    return DataHandler.safeApiCall(
      request: () =>
          _dioClient.post(ApiEndpoints.login, data: request.toJson()),
      fromJson: UserDataResponse.fromJson,
    );
  }

  @override
  FutureBool checkAUth() {
    return DataHandler.safeApiCall(
      request: () => _dioClient.get(ApiEndpoints.checkAuth),
      fromJson: (json) => true,
    );
  }

  @override
  FutureBool logout() {
    return DataHandler.safeApiCall(
      request: () => _dioClient.post('/auth/signout'),
      fromJson: (json) => true,
    );
  }

  @override
  FutureData<UserDataResponse> refreshToken(String refreshToken) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      ),
      fromJson: UserDataResponse.fromJson,
    );
  }

  @override
  FutureData<VerifyUserResult> verifyUser(String usernameOrEmail) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.post(
        '/auth/verify',
        data: {'username_or_email': usernameOrEmail},
      ),
      fromJson: (json) => VerifyUserResult(
        exists: json['exists'] ?? false,
        userId: json['userId'],
        username: json['username'],
        email: json['email'],
        isActive: json['isActive'],
      ),
    );
  }

  @override
  FutureBool changePassword(String userId, ChangePasswordRequest request) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.put(
        '/users-gateway/update-password/$userId',
        data: request.toJson(),
      ),
      fromJson: (json) => true,
    );
  }
}
