// Parámetros (comandos) del módulo de usuarios.
// ISP: cada clase contiene solo los campos que acepta su endpoint.

String? _date(DateTime? d) => d?.toIso8601String().split('T').first;

/// POST /user-employee-gateway/create
class CreateUserEmployeeParams {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final int sexId;
  final String idCard;
  final String citizenId;
  final int positionId;
  final DateTime hireDate;
  final int contractTypeId;
  final double baseSalary;
  final String internalPhone;
  final String internalEmail;

  const CreateUserEmployeeParams({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.sexId,
    required this.idCard,
    required this.citizenId,
    required this.positionId,
    required this.hireDate,
    required this.contractTypeId,
    required this.baseSalary,
    required this.internalPhone,
    required this.internalEmail,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': _date(dateOfBirth),
        'sexId': sexId,
        'idCard': idCard,
        'citizenId': citizenId,
        'positionId': positionId,
        'hireDate': _date(hireDate),
        'contractTypeId': contractTypeId,
        'baseSalary': baseSalary,
        'internalPhone': internalPhone,
        'internalEmail': internalEmail,
      };
}

/// PUT /users-gateway/update-user/:userId — solo envía campos no nulos.
class UpdateUserParams {
  final String userId;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final int? sexId;
  final String? idCard;
  final String? citizenId;
  final int? positionId;
  final int? contractTypeId;
  final int? employeeStatusId;
  final DateTime? terminationDate;
  final double? baseSalary;
  final String? supervisorId;
  final List<int>? assignedZones;
  final String? driverLicense;
  final bool? hasCompanyVehicle;
  final String? internalPhone;
  final String? internalEmail;
  final String? photoUrl;
  final Map<String, dynamic>? metadata;

  const UpdateUserParams({
    required this.userId,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.sexId,
    this.idCard,
    this.citizenId,
    this.positionId,
    this.contractTypeId,
    this.employeeStatusId,
    this.terminationDate,
    this.baseSalary,
    this.supervisorId,
    this.assignedZones,
    this.driverLicense,
    this.hasCompanyVehicle,
    this.internalPhone,
    this.internalEmail,
    this.photoUrl,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': _date(dateOfBirth),
      'sexId': sexId,
      'idCard': idCard,
      'citizenId': citizenId,
      'positionId': positionId,
      'contractTypeId': contractTypeId,
      'employeeStatusId': employeeStatusId,
      'terminationDate': _date(terminationDate),
      'baseSalary': baseSalary,
      'supervisorId': supervisorId,
      'assignedZones': assignedZones,
      'driverLicense': driverLicense,
      'hasCompanyVehicle': hasCompanyVehicle,
      'internalPhone': internalPhone,
      'internalEmail': internalEmail,
      'photoUrl': photoUrl,
      'metadata': metadata,
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }
}

/// PUT /users-gateway/update-password/:userId
class ChangeUserPasswordParams {
  final String userId;
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;

  const ChangeUserPasswordParams({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      };
}

/// Paginación para GET /users-gateway/find-all
class PaginationParams {
  final int limit;
  final int offset;
  const PaginationParams({this.limit = 20, this.offset = 0});
}

/// Par username/email para búsquedas combinadas.
class UsernameOrEmailParams {
  final String username;
  final String email;
  const UsernameOrEmailParams({required this.username, required this.email});
}

/// Credenciales para GET /users-gateway/verify-credentials
class CredentialsParams {
  final String username;
  final String password;
  const CredentialsParams({required this.username, required this.password});
}

/// Asignación/remoción de rol.
class UserRoleParams {
  final String userId;
  final int roleId;
  const UserRoleParams({required this.userId, required this.roleId});
}

/// Asignación/remoción de permiso.
class UserPermissionParams {
  final String userId;
  final int permissionId;
  const UserPermissionParams({required this.userId, required this.permissionId});
}
