import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/users/domain/entities/technician_entity.dart';
import 'package:clean_architecture/features/users/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/users/domain/params/user_params.dart';
import 'package:clean_architecture/features/users/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

// ═══════════════════════════════ CONSULTAS ═══════════════════════════════

@lazySingleton
class GetUsersUseCase implements UseCase<List<UserEntity>, PaginationParams> {
  final UserRepository _repo;
  GetUsersUseCase(this._repo);
  @override
  FutureList<UserEntity> call(PaginationParams p) =>
      _repo.findAll(limit: p.limit, offset: p.offset);
}

@lazySingleton
class GetUserByIdUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  GetUserByIdUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String userId) => _repo.findById(userId);
}

@lazySingleton
class FindByUsernameUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  FindByUsernameUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String username) => _repo.findByUsername(username);
}

@lazySingleton
class FindByEmailUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  FindByEmailUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String email) => _repo.findByEmail(email);
}

@lazySingleton
class FindByUsernameOrEmailUseCase
    implements UseCase<UserEntity, UsernameOrEmailParams> {
  final UserRepository _repo;
  FindByUsernameOrEmailUseCase(this._repo);
  @override
  FutureData<UserEntity> call(UsernameOrEmailParams p) =>
      _repo.findByUsernameOrEmail(p.username, p.email);
}

@lazySingleton
class FindByRefreshTokenUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  FindByRefreshTokenUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String token) => _repo.findByRefreshToken(token);
}

@lazySingleton
class FindEmployeeByIdCardUseCase implements UseCase<UserEntity?, String> {
  final UserRepository _repo;
  FindEmployeeByIdCardUseCase(this._repo);
  @override
  FutureData<UserEntity?> call(String idCard) => _repo.findByIdCard(idCard);
}

@lazySingleton
class GetProfileUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  GetProfileUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String usernameOrEmail) =>
      _repo.getProfile(usernameOrEmail);
}

/// En epaa-web `getDetail` usa el mismo endpoint que `getProfile`.
@lazySingleton
class GetUserDetailUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  GetUserDetailUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String usernameOrEmail) =>
      _repo.getProfile(usernameOrEmail);
}

@lazySingleton
class GetCustomerProfileUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  GetCustomerProfileUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String usernameOrEmail) =>
      _repo.getCustomerProfile(usernameOrEmail);
}

/// Usar con [TechnicianType.inspector] o [TechnicianType.instalador].
@lazySingleton
class FindTechniciansUseCase
    implements UseCase<List<TechnicianEntity>, String> {
  final UserRepository _repo;
  FindTechniciansUseCase(this._repo);
  @override
  FutureList<TechnicianEntity> call(String type) => _repo.findTechnicians(type);
}

@lazySingleton
class VerifyCredentialsUseCase implements UseCase<UserEntity, CredentialsParams> {
  final UserRepository _repo;
  VerifyCredentialsUseCase(this._repo);
  @override
  FutureData<UserEntity> call(CredentialsParams p) =>
      _repo.verifyCredentials(p.username, p.password);
}

// ═══════════════════════════════ VALIDACIONES ════════════════════════════

@lazySingleton
class ExistsByUsernameUseCase implements UseCase<bool, String> {
  final UserRepository _repo;
  ExistsByUsernameUseCase(this._repo);
  @override
  FutureBool call(String username) => _repo.existsByUsername(username);
}

@lazySingleton
class ExistsByEmailUseCase implements UseCase<bool, String> {
  final UserRepository _repo;
  ExistsByEmailUseCase(this._repo);
  @override
  FutureBool call(String email) => _repo.existsByEmail(email);
}

@lazySingleton
class ExistsByUsernameOrEmailUseCase
    implements UseCase<bool, UsernameOrEmailParams> {
  final UserRepository _repo;
  ExistsByUsernameOrEmailUseCase(this._repo);
  @override
  FutureBool call(UsernameOrEmailParams p) =>
      _repo.existsByUsernameOrEmail(p.username, p.email);
}

// ═══════════════════════════════ COMANDOS ════════════════════════════════

@lazySingleton
class CreateUserUseCase implements UseCase<UserEntity, CreateUserEmployeeParams> {
  final UserRepository _repo;
  CreateUserUseCase(this._repo);
  @override
  FutureData<UserEntity> call(CreateUserEmployeeParams p) => _repo.createUser(p);
}

@lazySingleton
class UpdateUserUseCase implements UseCase<UserEntity, UpdateUserParams> {
  final UserRepository _repo;
  UpdateUserUseCase(this._repo);
  @override
  FutureData<UserEntity> call(UpdateUserParams p) => _repo.updateUser(p);
}

@lazySingleton
class ChangeUserPasswordUseCase
    implements UseCase<bool, ChangeUserPasswordParams> {
  final UserRepository _repo;
  ChangeUserPasswordUseCase(this._repo);
  @override
  FutureBool call(ChangeUserPasswordParams p) => _repo.changePassword(p);
}

@lazySingleton
class DeleteUserUseCase implements UseCase<bool, String> {
  final UserRepository _repo;
  DeleteUserUseCase(this._repo);
  @override
  FutureBool call(String userId) => _repo.deleteUser(userId);
}

@lazySingleton
class RestoreUserUseCase implements UseCase<UserEntity, String> {
  final UserRepository _repo;
  RestoreUserUseCase(this._repo);
  @override
  FutureData<UserEntity> call(String userId) => _repo.restoreUser(userId);
}

// ═══════════════════════════════ SEGURIDAD ═══════════════════════════════

@lazySingleton
class ResetFailedAttemptsUseCase implements UseCase<bool, String> {
  final UserRepository _repo;
  ResetFailedAttemptsUseCase(this._repo);
  @override
  FutureBool call(String userId) => _repo.resetFailedAttempts(userId);
}

@lazySingleton
class IncrementFailedAttemptsUseCase implements UseCase<bool, String> {
  final UserRepository _repo;
  IncrementFailedAttemptsUseCase(this._repo);
  @override
  FutureBool call(String userId) => _repo.incrementFailedAttempts(userId);
}

// ═══════════════════════════════ ROLES Y PERMISOS ════════════════════════

@lazySingleton
class AssignRoleToUserUseCase implements UseCase<bool, UserRoleParams> {
  final UserRepository _repo;
  AssignRoleToUserUseCase(this._repo);
  @override
  FutureBool call(UserRoleParams p) => _repo.assignRoleToUser(p.userId, p.roleId);
}

@lazySingleton
class RemoveRoleFromUserUseCase implements UseCase<bool, UserRoleParams> {
  final UserRepository _repo;
  RemoveRoleFromUserUseCase(this._repo);
  @override
  FutureBool call(UserRoleParams p) =>
      _repo.removeRoleFromUser(p.userId, p.roleId);
}

@lazySingleton
class AssignPermissionToUserUseCase
    implements UseCase<bool, UserPermissionParams> {
  final UserRepository _repo;
  AssignPermissionToUserUseCase(this._repo);
  @override
  FutureBool call(UserPermissionParams p) =>
      _repo.assignPermissionToUser(p.userId, p.permissionId);
}

@lazySingleton
class RemovePermissionFromUserUseCase
    implements UseCase<bool, UserPermissionParams> {
  final UserRepository _repo;
  RemovePermissionFromUserUseCase(this._repo);
  @override
  FutureBool call(UserPermissionParams p) =>
      _repo.removePermissionFromUser(p.userId, p.permissionId);
}

@lazySingleton
class GetRolesByUserUseCase
    implements UseCase<List<RoleOrPermissionEntity>, String> {
  final UserRepository _repo;
  GetRolesByUserUseCase(this._repo);
  @override
  FutureList<RoleOrPermissionEntity> call(String userId) =>
      _repo.getRolesByUser(userId);
}

@lazySingleton
class GetPermissionsByUserUseCase
    implements UseCase<List<RoleOrPermissionEntity>, String> {
  final UserRepository _repo;
  GetPermissionsByUserUseCase(this._repo);
  @override
  FutureList<RoleOrPermissionEntity> call(String userId) =>
      _repo.getPermissionsByUser(userId);
}

@lazySingleton
class GetUsersByRoleUseCase implements UseCase<List<UserEntity>, int> {
  final UserRepository _repo;
  GetUsersByRoleUseCase(this._repo);
  @override
  FutureList<UserEntity> call(int roleId) => _repo.getUsersByRole(roleId);
}

@lazySingleton
class GetUsersByPermissionUseCase implements UseCase<List<UserEntity>, int> {
  final UserRepository _repo;
  GetUsersByPermissionUseCase(this._repo);
  @override
  FutureList<UserEntity> call(int permissionId) =>
      _repo.getUsersByPermission(permissionId);
}
