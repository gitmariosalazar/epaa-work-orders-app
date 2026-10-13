import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/users/data/constants/user_endpoints.dart';
import 'package:clean_architecture/features/users/data/models/user_models.dart';
import 'package:clean_architecture/features/users/domain/params/user_params.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Fuente remota del módulo de usuarios. Solo conoce HTTP + modelos (SRP).
abstract interface class UserRemoteDataSource {
  FutureList<UserModel> findAll(int limit, int offset);
  FutureData<UserModel> findById(String userId);
  FutureData<UserModel> findByUsername(String username);
  FutureData<UserModel> findByEmail(String email);
  FutureData<UserModel> findByUsernameOrEmail(String username, String email);
  FutureData<UserModel> findByRefreshToken(String token);
  FutureData<UserModel?> findByIdCard(String idCard);
  FutureData<UserModel> getProfile(String usernameOrEmail);
  FutureData<UserModel> getCustomerProfile(String usernameOrEmail);
  FutureList<TechnicianModel> findTechnicians(String type);
  FutureData<UserModel> verifyCredentials(String username, String password);

  FutureBool existsByUsername(String username);
  FutureBool existsByEmail(String email);
  FutureBool existsByUsernameOrEmail(String username, String email);

  FutureData<UserModel> createUser(CreateUserEmployeeParams params);
  FutureData<UserModel> updateUser(UpdateUserParams params);
  FutureBool changePassword(ChangeUserPasswordParams params);
  FutureBool deleteUser(String userId);
  FutureData<UserModel> restoreUser(String userId);

  FutureBool resetFailedAttempts(String userId);
  FutureBool incrementFailedAttempts(String userId);

  FutureBool assignRoleToUser(String userId, int roleId);
  FutureBool removeRoleFromUser(String userId, int roleId);
  FutureBool assignPermissionToUser(String userId, int permissionId);
  FutureBool removePermissionFromUser(String userId, int permissionId);
  FutureList<RoleOrPermissionModel> getRolesByUser(String userId);
  FutureList<RoleOrPermissionModel> getPermissionsByUser(String userId);
  FutureList<UserModel> getUsersByRole(int roleId);
  FutureList<UserModel> getUsersByPermission(int permissionId);
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiService _api;
  const UserRemoteDataSourceImpl({required ApiService apiService})
      : _api = apiService;

  // ── Helpers genéricos (DRY) ─────────────────────────────────────────────

  /// Obtiene `data` crudo de una respuesta estándar `{ data, message }`.
  FutureData<dynamic> _raw(Future<Response> Function() request) =>
      DataHandler.safeApiCall<dynamic, dynamic>(request: request);

  Map<String, dynamic>? _asMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : null;

  FutureData<UserModel> _user(Future<Response> Function() request) async =>
      (await _raw(request)).mapData((d) => UserModel.fromJson(_asMap(d) ?? {}));

  FutureList<T> _list<T>(
    Future<Response> Function() request,
    T Function(dynamic item) parse,
  ) async =>
      (await _raw(request)).mapData(
        (d) => d is List ? d.map(parse).toList() : <T>[],
      );

  FutureList<UserModel> _users(Future<Response> Function() request) =>
      _list(request, (e) => UserModel.fromJson(_asMap(e) ?? {}));

  FutureBool _bool(Future<Response> Function() request) async =>
      (await _raw(request)).mapData((d) => d == true || d == 'true');

  /// Comandos sin payload de respuesta útil: éxito = HTTP 2xx.
  FutureBool _command(Future<Response> Function() request) =>
      DataHandler.safeApiCall<bool, bool>(request: request, staticData: true);

  // ── Consultas ──────────────────────────────────────────────────────────

  @override
  FutureList<UserModel> findAll(int limit, int offset) => _users(
        () => _api.get(UserEndpoints.findAll,
            queryParameters: {'limit': limit, 'offset': offset}),
      );

  @override
  FutureData<UserModel> findById(String userId) =>
      _user(() => _api.get(UserEndpoints.findById(userId)));

  @override
  FutureData<UserModel> findByUsername(String username) =>
      _user(() => _api.get(UserEndpoints.findByUsername(username)));

  @override
  FutureData<UserModel> findByEmail(String email) =>
      _user(() => _api.get(UserEndpoints.findByEmail(email)));

  @override
  FutureData<UserModel> findByUsernameOrEmail(String username, String email) =>
      _user(() => _api.get(UserEndpoints.findByUsernameOrEmail,
          queryParameters: {'username': username, 'email': email}));

  @override
  FutureData<UserModel> findByRefreshToken(String token) => _user(() => _api
      .get(UserEndpoints.findByRefreshToken, queryParameters: {'token': token}));

  @override
  FutureData<UserModel?> findByIdCard(String idCard) async {
    final result = await _raw(() => _api.get(UserEndpoints.findByIdCard(idCard)));
    // Igual que epaa-web: si no existe (404 / error) se retorna null, no falla.
    return result.when(
      success: (d) {
        final map = _asMap(d);
        return SuccessState<UserModel?>(
            data: map == null ? null : UserModel.fromJson(map));
      },
      failure: (_, _) => const SuccessState<UserModel?>(data: null),
      loading: () => LoadingState<UserModel?>(),
    );
  }

  @override
  FutureData<UserModel> getProfile(String usernameOrEmail) =>
      _user(() => _api.get(UserEndpoints.getProfile(usernameOrEmail)));

  @override
  FutureData<UserModel> getCustomerProfile(String usernameOrEmail) =>
      _user(() => _api.get(UserEndpoints.getCustomerProfile(usernameOrEmail)));

  @override
  FutureList<TechnicianModel> findTechnicians(String type) => _list(
        () => _api.get(UserEndpoints.findTechnicians,
            queryParameters: {'type': type}),
        (e) => TechnicianModel.fromJson(_asMap(e) ?? {}),
      );

  @override
  FutureData<UserModel> verifyCredentials(String username, String password) =>
      _user(() => _api.get(UserEndpoints.verifyCredentials,
          queryParameters: {'username': username, 'password': password}));

  // ── Validaciones ───────────────────────────────────────────────────────

  @override
  FutureBool existsByUsername(String username) =>
      _bool(() => _api.get(UserEndpoints.existsByUsername(username)));

  @override
  FutureBool existsByEmail(String email) =>
      _bool(() => _api.get(UserEndpoints.existsByEmail(email)));

  @override
  FutureBool existsByUsernameOrEmail(String username, String email) =>
      _bool(() => _api.get(UserEndpoints.existsByUsernameOrEmail,
          queryParameters: {'username': username, 'email': email}));

  // ── Comandos ───────────────────────────────────────────────────────────

  @override
  FutureData<UserModel> createUser(CreateUserEmployeeParams params) => _user(
      () => _api.post(UserEndpoints.createEmployee, data: params.toJson()));

  @override
  FutureData<UserModel> updateUser(UpdateUserParams params) => _user(() =>
      _api.put(UserEndpoints.updateUser(params.userId), data: params.toJson()));

  @override
  FutureBool changePassword(ChangeUserPasswordParams params) => _command(() =>
      _api.put(UserEndpoints.updatePassword(params.userId),
          data: params.toJson()));

  @override
  FutureBool deleteUser(String userId) =>
      _command(() => _api.delete(UserEndpoints.softDelete(userId)));

  @override
  FutureData<UserModel> restoreUser(String userId) =>
      _user(() => _api.put(UserEndpoints.restore(userId)));

  // ── Seguridad ──────────────────────────────────────────────────────────

  @override
  FutureBool resetFailedAttempts(String userId) =>
      _command(() => _api.put(UserEndpoints.resetFailedAttempts(userId)));

  @override
  FutureBool incrementFailedAttempts(String userId) =>
      _command(() => _api.put(UserEndpoints.incrementFailedAttempts(userId)));

  // ── Roles y permisos ───────────────────────────────────────────────────

  @override
  FutureBool assignRoleToUser(String userId, int roleId) => _command(() =>
      _api.post(UserEndpoints.assignRole,
          data: {'userId': userId, 'roleId': roleId}));

  @override
  FutureBool removeRoleFromUser(String userId, int roleId) =>
      _command(() => _api.delete(UserEndpoints.removeRole(userId, roleId)));

  @override
  FutureBool assignPermissionToUser(String userId, int permissionId) =>
      _command(() => _api.post(UserEndpoints.assignPermission,
          data: {'userId': userId, 'permissionId': permissionId}));

  @override
  FutureBool removePermissionFromUser(String userId, int permissionId) =>
      _command(() =>
          _api.delete(UserEndpoints.removePermission(userId, permissionId)));

  @override
  FutureList<RoleOrPermissionModel> getRolesByUser(String userId) => _list(
      () => _api.get(UserEndpoints.rolesByUser(userId)),
      RoleOrPermissionModel.fromDynamic);

  @override
  FutureList<RoleOrPermissionModel> getPermissionsByUser(String userId) =>
      _list(() => _api.get(UserEndpoints.permissionsByUser(userId)),
          RoleOrPermissionModel.fromDynamic);

  @override
  FutureList<UserModel> getUsersByRole(int roleId) =>
      _users(() => _api.get(UserEndpoints.usersByRole(roleId)));

  @override
  FutureList<UserModel> getUsersByPermission(int permissionId) =>
      _users(() => _api.get(UserEndpoints.usersByPermission(permissionId)));
}
