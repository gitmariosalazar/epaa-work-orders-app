/// Rol o permiso asignado a un usuario.
class RoleOrPermissionEntity {
  final int id;
  final String name;
  final String? description;

  const RoleOrPermissionEntity({
    required this.id,
    required this.name,
    this.description,
  });
}

/// Entidad de dominio: Usuario / Empleado del sistema EPAA.
/// Espejo de `User` en epaa-web (src/modules/users/domain/models/User.ts).
class UserEntity {
  final String userId;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final int? sexId;
  final String? idCard;
  final String? citizenId;
  final int? positionId;
  final String? positionName;
  final int? contractTypeId;
  final String? contractTypeName;
  final int? employeeStatusId;
  final DateTime? hireDate;
  final DateTime? terminationDate;
  final double? baseSalary;
  final String? supervisorId;
  final List<int> assignedZones;
  final String? driverLicense;
  final bool hasCompanyVehicle;
  final String? internalPhone;
  final String? internalEmail;
  final String? photoUrl;
  final String? createdBy;
  final List<RoleOrPermissionEntity> roles;
  final List<RoleOrPermissionEntity> permissions;
  final bool isActive;
  final DateTime? registeredAt;
  final DateTime? lastLogin;
  final int failedAttempts;
  final bool twoFactorEnabled;
  final String? observations;

  const UserEntity({
    required this.userId,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.sexId,
    this.idCard,
    this.citizenId,
    this.positionId,
    this.positionName,
    this.contractTypeId,
    this.contractTypeName,
    this.employeeStatusId,
    this.hireDate,
    this.terminationDate,
    this.baseSalary,
    this.supervisorId,
    this.assignedZones = const [],
    this.driverLicense,
    this.hasCompanyVehicle = false,
    this.internalPhone,
    this.internalEmail,
    this.photoUrl,
    this.createdBy,
    this.roles = const [],
    this.permissions = const [],
    this.isActive = true,
    this.registeredAt,
    this.lastLogin,
    this.failedAttempts = 0,
    this.twoFactorEnabled = false,
    this.observations,
  });

  /// Nombre completo legible (fallback al username).
  String get fullName {
    final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return name.isEmpty ? username : name;
  }

  bool hasRole(String roleName) =>
      roles.any((r) => r.name.toUpperCase() == roleName.toUpperCase());

  bool hasPermission(String permissionName) => permissions
      .any((p) => p.name.toUpperCase() == permissionName.toUpperCase());
}
