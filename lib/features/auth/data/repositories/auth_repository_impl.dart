import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:clean_architecture/features/auth/data/models/requests/authentication_request.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/entities/verify_user_result.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  final InternetService _internet;
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required InternetService internet,
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _internet = internet;

  @override
  FutureData<UserData> login(Authentication authentication) async {
    final response = await DataHandler.fetchWithFallbackAndMap(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.login(
        AuthenticationRequest.fromDomain(authentication),
      ),
    );

    if (response is SuccessState) {
      final userData = response.data!;
      final hasAccess = userData.user.roles.any((role) {
        final upperRole = role.toUpperCase();
        return upperRole == 'SUPER ADMINISTRADOR' || upperRole == 'EMPLEADO';
      });

      if (!hasAccess) {
        return FailureState<UserData>(
          message:
              'Acceso denegado. Esta aplicación es exclusiva para los usuarios internos de la EPAA-AA.',
          errorType: ErrorType.unknown,
        );
      }
    }

    return response;
  }

  @override
  FutureBool saveUserData(UserData userData) =>
      _localDataSource.saveUserData(UserDataResponse.fromDomain(userData));

  @override
  FutureData<UserData> getUserData() {
    return DataHandler.fetchFromLocalAndMap(
      localCallback: _localDataSource.getUserData,
    );
  }

  @override
  FutureBool checkAuth() {
    return DataHandler.fetchWithFallback(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.checkAUth(),
    );
  }

  @override
  FutureBool removeUserData() => _localDataSource.removeUserData();

  @override
  FutureBool logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {}

    await _localDataSource.removeUserData();
    return const SuccessState(data: true);
  }

  @override
  FutureData<UserData> refreshToken(String refreshToken) async {
    final response = await DataHandler.fetchWithFallbackAndMap(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.refreshToken(refreshToken),
    );

    if (response is SuccessState) {
      await _localDataSource.saveUserData(
        UserDataResponse.fromDomain(response.data!),
      );
    }

    return response;
  }

  @override
  FutureData<VerifyUserResult> verifyUser(String usernameOrEmail) async {
    final response = await DataHandler.fetchWithFallback(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.verifyUser(usernameOrEmail),
    );

    if (response is SuccessState) {
      final result = response.data!;
      if (!result.exists || result.isActive == false) {
        return SuccessState(
          data: VerifyUserResult(
            exists: false,
            userId: result.userId,
            username: result.username,
            email: result.email,
            isActive: result.isActive,
          ),
        );
      }
    }
    return response;
  }

  @override
  FutureBool changePassword(String userId, ChangePasswordRequest request) {
    return DataHandler.fetchWithFallback(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.changePassword(userId, request),
    );
  }
}
