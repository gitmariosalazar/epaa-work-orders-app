import os

base_dir = '/home/mariosalazar/Desktop/Epaa/Git/frontend/work_orders_epaa/lib/features/auth'

files = {
    # DOMAIN ENTITIES
    'domain/entities/role_or_permission.dart': '''import 'package:equatable/equatable.dart';

class RoleOrPermission extends Equatable {
  final int id;
  final String name;
  final String description;

  const RoleOrPermission({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, description];

  bool isAdmin() {
    return name.toUpperCase() == 'SUPER ADMINISTRADOR' ||
        name.toUpperCase() == 'ADMINISTRADOR';
  }

  bool isCustomer() {
    return name.toUpperCase() == 'ABONADO PORTAL WEB';
  }
}
''',
    'domain/entities/user_entity.dart': '''import 'package:equatable/equatable.dart';
import 'package:clean_architecture/features/auth/domain/entities/role_or_permission.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final List<RoleOrPermission> roles;
  final List<RoleOrPermission> permissions;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.roles,
    required this.permissions,
    required this.isActive,
  });

  @override
  List<Object> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    roles,
    permissions,
    isActive,
  ];
}
''',
    'domain/entities/auth_response.dart': '''import 'package:equatable/equatable.dart';
import 'package:clean_architecture/features/auth/domain/entities/user_entity.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, user];
}
''',
    'domain/entities/verify_user_result.dart': '''import 'package:equatable/equatable.dart';

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
''',
    'domain/models/requests/change_password_request.dart': '''class ChangePasswordRequest {
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
''',
    'domain/entities/authentication.dart': '''class Authentication {
  final String usernameOrEmail;
  final String password;

  const Authentication({required this.usernameOrEmail, required this.password});
}
''',
    
    # REPOSITORY INTERFACE
    'domain/repositories/auth_repository.dart': '''import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/entities/auth_response.dart';
import 'package:clean_architecture/features/auth/domain/entities/verify_user_result.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';

abstract interface class AuthRepository {
  FutureData<AuthResponse> login(Authentication authentication);
  FutureBool logout();
  FutureData<AuthResponse> checkAuthStatus();
  FutureData<AuthResponse> refreshToken(String refreshToken);
  FutureData<VerifyUserResult> verifyUser(String usernameOrEmail);
  FutureBool changePassword(String userId, ChangePasswordRequest request);
}
''',

    # USE CASES
    'domain/use_cases/login_use_case.dart': '''import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/entities/auth_response.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LoginUseCase implements UseCase<AuthResponse, Authentication> {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  FutureData<AuthResponse> call(Authentication params) => _repository.login(params);
}
''',
    'domain/use_cases/logout_use_case.dart': '''import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LogoutUseCase implements UseCaseNoParameter<bool> {
  final AuthRepository _repository;

  LogoutUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  FutureBool call() => _repository.logout();
}
''',
    'domain/use_cases/check_auth_status_use_case.dart': '''import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/auth_response.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CheckAuthStatusUseCase implements UseCaseNoParameter<AuthResponse> {
  final AuthRepository _repository;

  CheckAuthStatusUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  FutureData<AuthResponse> call() => _repository.checkAuthStatus();
}
''',
    'domain/use_cases/verify_user_use_case.dart': '''import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/verify_user_result.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class VerifyUserParams {
  final String usernameOrEmail;
  const VerifyUserParams({required this.usernameOrEmail});
}

@LazySingleton()
class VerifyUserUseCase implements UseCase<VerifyUserResult, VerifyUserParams> {
  final AuthRepository _repository;

  VerifyUserUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  FutureData<VerifyUserResult> call(VerifyUserParams params) => _repository.verifyUser(params.usernameOrEmail);
}
''',
    'domain/use_cases/refresh_token_use_case.dart': '''import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/auth_response.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class RefreshTokenParams {
  final String refreshToken;
  const RefreshTokenParams({required this.refreshToken});
}

@LazySingleton()
class RefreshTokenUseCase implements UseCase<AuthResponse, RefreshTokenParams> {
  final AuthRepository _repository;

  RefreshTokenUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  FutureData<AuthResponse> call(RefreshTokenParams params) => _repository.refreshToken(params.refreshToken);
}
''',
    'domain/use_cases/change_password_use_case.dart': '''import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class ChangePasswordParams {
  final String userId;
  final ChangePasswordRequest request;
  const ChangePasswordParams({required this.userId, required this.request});
}

@LazySingleton()
class ChangePasswordUseCase implements UseCase<bool, ChangePasswordParams> {
  final AuthRepository _repository;

  ChangePasswordUseCase({required AuthRepository repository}) : _repository = repository;

  @override
  FutureBool call(ChangePasswordParams params) => _repository.changePassword(params.userId, params.request);
}
''',

    # DATA MODELS
    'data/models/role_or_permission_model.dart': '''import 'package:clean_architecture/features/auth/domain/entities/role_or_permission.dart';

class RoleOrPermissionModel extends RoleOrPermission {
  const RoleOrPermissionModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory RoleOrPermissionModel.fromJson(Map<String, dynamic> json) {
    return RoleOrPermissionModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
''',
    'data/models/user_entity_model.dart': '''import 'package:clean_architecture/features/auth/domain/entities/role_or_permission.dart';
import 'package:clean_architecture/features/auth/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/auth/data/models/role_or_permission_model.dart';

class UserEntityModel extends UserEntity {
  const UserEntityModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.roles,
    required super.permissions,
    required super.isActive,
  });

  factory UserEntityModel.fromJson(Map<String, dynamic> json) {
    return UserEntityModel(
      id: json['userId'] as String? ?? json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)?.map((e) {
            if (e is String) return RoleOrPermissionModel(id: 0, name: e, description: '');
            if (e is int) return RoleOrPermissionModel(id: e, name: e.toString(), description: '');
            return RoleOrPermissionModel.fromJson(e as Map<String, dynamic>);
          }).toList() ?? [],
      permissions: (json['permissions'] as List<dynamic>?)?.map((e) {
            if (e is String) return RoleOrPermissionModel(id: 0, name: e, description: '');
            if (e is int) return RoleOrPermissionModel(id: e, name: e.toString(), description: '');
            return RoleOrPermissionModel.fromJson(e as Map<String, dynamic>);
          }).toList() ?? [],
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'roles': roles.map((r) => (r as RoleOrPermissionModel).toJson()).toList(),
      'permissions': permissions.map((p) => (p as RoleOrPermissionModel).toJson()).toList(),
      'isActive': isActive,
    };
  }
}
''',
    'data/models/auth_response_model.dart': '''import 'package:clean_architecture/features/auth/domain/entities/auth_response.dart';
import 'package:clean_architecture/features/auth/data/models/user_entity_model.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required UserEntityModel user,
  }) : super(user: user);

  @override
  UserEntityModel get user => super.user as UserEntityModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: UserEntityModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}
''',
    'data/models/verify_user_result_model.dart': '''import 'package:clean_architecture/features/auth/domain/entities/verify_user_result.dart';

class VerifyUserResultModel extends VerifyUserResult {
  const VerifyUserResultModel({
    required super.exists,
    super.userId,
    super.username,
    super.email,
    super.isActive,
  });

  factory VerifyUserResultModel.fromJson(Map<String, dynamic> json) {
    return VerifyUserResultModel(
      exists: json['exists'] as bool? ?? false,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }
}
''',
    'data/models/requests/auth_request_model.dart': '''import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';

class AuthRequestModel {
  final String usernameOrEmail;
  final String password;

  const AuthRequestModel({
    required this.usernameOrEmail,
    required this.password,
  });

  factory AuthRequestModel.fromDomain(Authentication auth) {
    return AuthRequestModel(
      usernameOrEmail: auth.usernameOrEmail,
      password: auth.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username_or_email': usernameOrEmail,
      'password': password,
    };
  }
}
''',

    # LOCAL DATASOURCE
    'data/data_sources/auth_local_data_source.dart': '''import 'dart:convert';
import 'package:clean_architecture/features/auth/data/models/auth_response_model.dart';
import 'package:clean_architecture/features/auth/data/models/user_entity_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> cacheUser(UserEntityModel user);
  Future<AuthResponseModel?> getAuthResponse();
  Future<void> clearUser();
}

const String CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';
const String CACHED_USER_DATA = 'CACHED_USER_DATA';

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(CACHED_AUTH_TOKEN, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(CACHED_AUTH_TOKEN);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(CACHED_AUTH_TOKEN);
  }

  @override
  Future<void> cacheUser(UserEntityModel user) async {
    await sharedPreferences.setString(
      CACHED_USER_DATA,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<AuthResponseModel?> getAuthResponse() async {
    final token = sharedPreferences.getString(CACHED_AUTH_TOKEN);
    final jsonString = sharedPreferences.getString(CACHED_USER_DATA);

    if (jsonString != null && token != null) {
      try {
        final userModel = UserEntityModel.fromJson(jsonDecode(jsonString));
        return AuthResponseModel(
          accessToken: token,
          refreshToken: '',
          user: userModel,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(CACHED_USER_DATA);
  }
}
''',

    # REMOTE DATASOURCE
    'data/data_sources/auth_remote_data_source.dart': '''import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/data/models/requests/auth_request_model.dart';
import 'package:clean_architecture/features/auth/data/models/responses/auth_response_model.dart';
import 'package:clean_architecture/features/auth/data/models/verify_user_result_model.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteDataSource {
  FutureData<AuthResponseModel> login(AuthRequestModel request);
  FutureData<AuthResponseModel> refreshToken(String refreshToken);
  FutureBool logout();
  FutureData<VerifyUserResultModel> verifyUser(String usernameOrEmail);
  FutureBool changePassword(String userId, ChangePasswordRequest request);
}

@LazySingleton(as: AuthRemoteDataSource)
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _dioClient;

  const AuthRemoteDataSourceImpl({required ApiService dioClient}) : _dioClient = dioClient;

  @override
  FutureData<AuthResponseModel> login(AuthRequestModel request) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.post('/auth/signin', data: request.toJson()),
      fromJson: (json) => AuthResponseModel.fromJson(json['data'] ?? json),
    );
  }

  @override
  FutureData<AuthResponseModel> refreshToken(String refreshToken) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.post('/auth/refresh', data: {'refreshToken': refreshToken}),
      fromJson: (json) => AuthResponseModel.fromJson(json['data'] ?? json),
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
  FutureData<VerifyUserResultModel> verifyUser(String usernameOrEmail) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.post('/auth/verify', data: {'username_or_email': usernameOrEmail}),
      fromJson: (json) => VerifyUserResultModel.fromJson(json['data'] ?? json),
    );
  }

  @override
  FutureBool changePassword(String userId, ChangePasswordRequest request) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.put('/users-gateway/update-password/$userId', data: request.toJson()),
      fromJson: (json) => true,
    );
  }
}
''',

    # REPOSITORY IMPL
    'data/repositories/auth_repository_impl.dart': '''import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:clean_architecture/features/auth/data/models/requests/auth_request_model.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/entities/auth_response.dart';
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
  FutureData<AuthResponse> login(Authentication authentication) async {
    final response = await DataHandler.fetchWithFallback(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.login(AuthRequestModel.fromDomain(authentication)),
    );

    if (response is SuccessState) {
      final authResponse = response.data!;
      final hasAccess = authResponse.user.roles.any((role) {
        final upperRole = role.name.toUpperCase();
        return upperRole == 'SUPER ADMINISTRADOR' || upperRole == 'EMPLEADO';
      });

      if (!hasAccess) {
        return FailureState(
          message: 'Acceso denegado. Esta aplicación es exclusiva para los usuarios internos de la EPAA-AA.',
          errorType: ErrorType.client,
        );
      }

      await _localDataSource.cacheToken(authResponse.accessToken);
      await _localDataSource.cacheUser(authResponse.user);
      
      // Optionally connect WebSocket here if available
    }

    return response;
  }

  @override
  FutureData<AuthResponse> refreshToken(String refreshToken) async {
    final response = await DataHandler.fetchWithFallback(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.refreshToken(refreshToken),
    );

    if (response is SuccessState) {
      await _localDataSource.cacheToken(response.data!.accessToken);
      await _localDataSource.cacheUser(response.data!.user);
    }
    
    return response;
  }

  @override
  FutureBool logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {}
    
    await _localDataSource.clearToken();
    await _localDataSource.clearUser();
    
    return const SuccessState(data: true);
  }

  @override
  FutureData<AuthResponse> checkAuthStatus() async {
    try {
      final token = await _localDataSource.getToken();
      final authResponse = await _localDataSource.getAuthResponse();
      if (token != null && token.isNotEmpty && authResponse != null) {
        return SuccessState(data: authResponse);
      }
      return FailureState(message: 'No active session', errorType: ErrorType.client);
    } catch (_) {
      return FailureState(message: 'Error checking session', errorType: ErrorType.client);
    }
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
  FutureBool changePassword(String userId, ChangePasswordRequest request) async {
    return DataHandler.fetchWithFallback(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.changePassword(userId, request),
    );
  }
}
'''
}

for filepath, content in files.items():
    full_path = os.path.join(base_dir, filepath)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, 'w') as f:
        f.write(content)

