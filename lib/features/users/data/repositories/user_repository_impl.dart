import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/users/data/datasources/user_remote_datasource.dart';
import 'package:clean_architecture/features/users/domain/entities/technician_entity.dart';
import 'package:clean_architecture/features/users/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/users/domain/params/user_params.dart';
import 'package:clean_architecture/features/users/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

/// Implementación del repositorio: conectividad + mapeo Model → Entity.
@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final InternetService _internet;
  final UserRemoteDataSource _remote;

  UserRepositoryImpl({
    required InternetService internet,
    required UserRemoteDataSource remoteDataSource,
  })  : _internet = internet,
        _remote = remoteDataSource;

  FutureData<T> _online<T>(FutureData<T> Function() call) =>
      DataHandler.fetchWithFallback<T>(_internet.isConnected,
          remoteCallback: call);

  // ── Consultas ──────────────────────────────────────────────────────────

  @override
  FutureList<UserEntity> findAll({int limit = 20, int offset = 0}) async =>
      (await _online(() => _remote.findAll(limit, offset)))
          .mapData((l) => l.map((m) => m.toEntity()).toList());

  @override
  FutureData<UserEntity> findById(String userId) async =>
      (await _online(() => _remote.findById(userId))).mapData((m) => m.toEntity());

  @override
  FutureData<UserEntity> findByUsername(String username) async =>
      (await _online(() => _remote.findByUsername(username)))
          .mapData((m) => m.toEntity());

  @override
  FutureData<UserEntity> findByEmail(String email) async =>
      (await _online(() => _remote.findByEmail(email))).mapData((m) => m.toEntity());

  @override
  FutureData<UserEntity> findByUsernameOrEmail(String username, String email) async =>
      (await _online(() => _remote.findByUsernameOrEmail(username, email)))
          .mapData((m) => m.toEntity());

  @override
  FutureData<UserEntity> findByRefreshToken(String token) async =>
      (await _online(() => _remote.findByRefreshToken(token)))
          .mapData((m) => m.toEntity());

  @override
  FutureData<UserEntity?> findByIdCard(String idCard) async =>
      (await _online(() => _remote.findByIdCard(idCard)))
          .mapData((m) => m?.toEntity());

  @override
  FutureData<UserEntity> getProfile(String usernameOrEmail) async =>
      (await _online(() => _remote.getProfile(usernameOrEmail)))
          .mapData((m) => m.toEntity());

  @override
  FutureData<UserEntity> getCustomerProfile(String usernameOrEmail) async =>
      (await _online(() => _remote.getCustomerProfile(usernameOrEmail)))
          .mapData((m) => m.toEntity());

  @override
  FutureList<TechnicianEntity> findTechnicians(String type) async =>
      (await _online(() => _remote.findTechnicians(type))).mapData((l) => l
          .map((m) => m.toEntity())
          .where((t) => t.id.isNotEmpty)
          .toList());

  @override
  FutureData<UserEntity> verifyCredentials(String username, String password) async =>
      (await _online(() => _remote.verifyCredentials(username, password)))
          .mapData((m) => m.toEntity());

  // ── Validaciones ───────────────────────────────────────────────────────

  @override
  FutureBool existsByUsername(String username) =>
      _online(() => _remote.existsByUsername(username));

  @override
  FutureBool existsByEmail(String email) =>
      _online(() => _remote.existsByEmail(email));

  @override
  FutureBool existsByUsernameOrEmail(String username, String email) =>
      _online(() => _remote.existsByUsernameOrEmail(username, email));

  // ── Comandos ───────────────────────────────────────────────────────────

  @override
  FutureData<UserEntity> createUser(CreateUserEmployeeParams params) async =>
      (await _online(() => _remote.createUser(params))).mapData((m) => m.toEntity());

  @override
  FutureData<UserEntity> updateUser(UpdateUserParams params) async =>
      (await _online(() => _remote.updateUser(params))).mapData((m) => m.toEntity());

  @override
  FutureBool changePassword(ChangeUserPasswordParams params) =>
      _online(() => _remote.changePassword(params));

  @override
  FutureBool deleteUser(String userId) => _online(() => _remote.deleteUser(userId));

  @override
  FutureData<UserEntity> restoreUser(String userId) async =>
      (await _online(() => _remote.restoreUser(userId))).mapData((m) => m.toEntity());

  // ── Seguridad ──────────────────────────────────────────────────────────

  @override
  FutureBool resetFailedAttempts(String userId) =>
      _online(() => _remote.resetFailedAttempts(userId));

  @override
  FutureBool incrementFailedAttempts(String userId) =>
      _online(() => _remote.incrementFailedAttempts(userId));

  // ── Roles y permisos ───────────────────────────────────────────────────

  @override
  FutureBool assignRoleToUser(String userId, int roleId) =>
      _online(() => _remote.assignRoleToUser(userId, roleId));

  @override
  FutureBool removeRoleFromUser(String userId, int roleId) =>
      _online(() => _remote.removeRoleFromUser(userId, roleId));

  @override
  FutureBool assignPermissionToUser(String userId, int permissionId) =>
      _online(() => _remote.assignPermissionToUser(userId, permissionId));

  @override
  FutureBool removePermissionFromUser(String userId, int permissionId) =>
      _online(() => _remote.removePermissionFromUser(userId, permissionId));

  @override
  FutureList<RoleOrPermissionEntity> getRolesByUser(String userId) async =>
      (await _online(() => _remote.getRolesByUser(userId)))
          .mapData((l) => l.map((m) => m.toEntity()).toList());

  @override
  FutureList<RoleOrPermissionEntity> getPermissionsByUser(String userId) async =>
      (await _online(() => _remote.getPermissionsByUser(userId)))
          .mapData((l) => l.map((m) => m.toEntity()).toList());

  @override
  FutureList<UserEntity> getUsersByRole(int roleId) async =>
      (await _online(() => _remote.getUsersByRole(roleId)))
          .mapData((l) => l.map((m) => m.toEntity()).toList());

  @override
  FutureList<UserEntity> getUsersByPermission(int permissionId) async =>
      (await _online(() => _remote.getUsersByPermission(permissionId)))
          .mapData((l) => l.map((m) => m.toEntity()).toList());
}
