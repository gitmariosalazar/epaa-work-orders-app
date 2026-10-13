import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/users/domain/entities/technician_entity.dart';
import 'package:clean_architecture/features/users/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/users/domain/params/user_params.dart';

/// Contrato del módulo de usuarios (DIP). Espejo de `UserRepository` de epaa-web.
abstract interface class UserRepository {
  // ── Consultas ──────────────────────────────────────────────────────────
  FutureList<UserEntity> findAll({int limit = 20, int offset = 0});
  FutureData<UserEntity> findById(String userId);
  FutureData<UserEntity> findByUsername(String username);
  FutureData<UserEntity> findByEmail(String email);
  FutureData<UserEntity> findByUsernameOrEmail(String username, String email);
  FutureData<UserEntity> findByRefreshToken(String token);
  FutureData<UserEntity?> findByIdCard(String idCard);
  FutureData<UserEntity> getProfile(String usernameOrEmail);
  FutureData<UserEntity> getCustomerProfile(String usernameOrEmail);
  FutureList<TechnicianEntity> findTechnicians(String type);
  FutureData<UserEntity> verifyCredentials(String username, String password);

  // ── Validaciones ───────────────────────────────────────────────────────
  FutureBool existsByUsername(String username);
  FutureBool existsByEmail(String email);
  FutureBool existsByUsernameOrEmail(String username, String email);

  // ── Comandos ───────────────────────────────────────────────────────────
  FutureData<UserEntity> createUser(CreateUserEmployeeParams params);
  FutureData<UserEntity> updateUser(UpdateUserParams params);
  FutureBool changePassword(ChangeUserPasswordParams params);
  FutureBool deleteUser(String userId);
  FutureData<UserEntity> restoreUser(String userId);

  // ── Seguridad ──────────────────────────────────────────────────────────
  FutureBool resetFailedAttempts(String userId);
  FutureBool incrementFailedAttempts(String userId);

  // ── Roles y permisos ───────────────────────────────────────────────────
  FutureBool assignRoleToUser(String userId, int roleId);
  FutureBool removeRoleFromUser(String userId, int roleId);
  FutureBool assignPermissionToUser(String userId, int permissionId);
  FutureBool removePermissionFromUser(String userId, int permissionId);
  FutureList<RoleOrPermissionEntity> getRolesByUser(String userId);
  FutureList<RoleOrPermissionEntity> getPermissionsByUser(String userId);
  FutureList<UserEntity> getUsersByRole(int roleId);
  FutureList<UserEntity> getUsersByPermission(int permissionId);
}
