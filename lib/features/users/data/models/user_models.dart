import 'package:clean_architecture/features/users/domain/entities/technician_entity.dart';
import 'package:clean_architecture/features/users/domain/entities/user_entity.dart';

/// Utilidades de parseo tolerante (el backend puede enviar números como String).
abstract final class _P {
  static String? str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int? integer(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? double.tryParse(v)?.toInt();
    return null;
  }

  static double? dbl(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static bool boolean(dynamic v, [bool fallback = false]) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v.toLowerCase() == 'true' || v == '1';
    return fallback;
  }

  static DateTime? date(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());
}

class RoleOrPermissionModel {
  final int id;
  final String name;
  final String? description;

  const RoleOrPermissionModel({required this.id, required this.name, this.description});

  /// Acepta objeto `{id, name}` o un String plano (algunos endpoints devuelven nombres).
  factory RoleOrPermissionModel.fromDynamic(dynamic json) {
    if (json is Map) {
      final m = Map<String, dynamic>.from(json);
      return RoleOrPermissionModel(
        id: _P.integer(m['id'] ?? m['roleId'] ?? m['permissionId']) ?? 0,
        name: _P.str(m['name'] ?? m['nombre']) ?? '',
        description: _P.str(m['description'] ?? m['descripcion']),
      );
    }
    return RoleOrPermissionModel(id: 0, name: json?.toString() ?? '');
  }

  RoleOrPermissionEntity toEntity() =>
      RoleOrPermissionEntity(id: id, name: name, description: description);
}

class UserModel {
  final Map<String, dynamic> _json;
  const UserModel._(this._json);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel._(json);

  List<RoleOrPermissionEntity> _list(dynamic v) => v is List
      ? v.map((e) => RoleOrPermissionModel.fromDynamic(e).toEntity()).toList()
      : const [];

  /// Mapper único (cubre User y UserEmployeeResponse del backend).
  UserEntity toEntity() {
    final j = _json;
    return UserEntity(
      userId: _P.str(j['userId'] ?? j['user_id'] ?? j['employeeId'] ?? j['id']) ?? '',
      username: _P.str(j['username']) ?? '',
      email: _P.str(j['email'] ?? j['internalEmail']) ?? '',
      firstName: _P.str(j['firstName'] ?? j['first_name']),
      lastName: _P.str(j['lastName'] ?? j['last_name']),
      dateOfBirth: _P.date(j['dateOfBirth']),
      sexId: _P.integer(j['sexId']),
      idCard: _P.str(j['idCard'] ?? j['cardId']),
      citizenId: _P.str(j['citizenId']),
      positionId: _P.integer(j['positionId']),
      positionName: _P.str(j['positionName']),
      contractTypeId: _P.integer(j['contractTypeId']),
      contractTypeName: _P.str(j['contractTypeName']),
      employeeStatusId: _P.integer(j['employeeStatusId']),
      hireDate: _P.date(j['hireDate']),
      terminationDate: _P.date(j['terminationDate']),
      baseSalary: _P.dbl(j['baseSalary']),
      supervisorId: _P.str(j['supervisorId']),
      assignedZones: j['assignedZones'] is List
          ? (j['assignedZones'] as List).map(_P.integer).whereType<int>().toList()
          : const [],
      driverLicense: _P.str(j['driverLicense']),
      hasCompanyVehicle: _P.boolean(j['hasCompanyVehicle']),
      internalPhone: _P.str(j['internalPhone']),
      internalEmail: _P.str(j['internalEmail']),
      photoUrl: _P.str(j['photoUrl']),
      createdBy: _P.str(j['createdBy']),
      roles: _list(j['roles']),
      permissions: _list(j['permissions']),
      isActive: _P.boolean(j['isActive'], true),
      registeredAt: _P.date(j['registeredAt'] ?? j['createdAt']),
      lastLogin: _P.date(j['lastLogin']),
      failedAttempts: _P.integer(j['failedAttempts']) ?? 0,
      twoFactorEnabled: _P.boolean(j['twoFactorEnabled']),
      observations: _P.str(j['observations']),
    );
  }
}

class TechnicianModel {
  final Map<String, dynamic> _json;
  const TechnicianModel._(this._json);

  factory TechnicianModel.fromJson(Map<String, dynamic> json) =>
      TechnicianModel._(json);

  /// Mismo mapeo que ManageWorkersModal.tsx en epaa-web.
  TechnicianEntity toEntity() {
    final j = _json;
    final first = _P.str(j['firstName'] ?? j['first_name'] ?? j['nombres']);
    final last = _P.str(j['lastName'] ?? j['last_name'] ?? j['apellidos']);
    final id = _P.str(j['userId'] ?? j['user_id'] ?? j['employeeId'] ??
            j['employee_id'] ?? j['id']) ??
        '';
    final full = _P.str(j['fullName'] ?? j['full_name']) ??
        '${first ?? ''} ${last ?? ''}'.trim();
    return TechnicianEntity(
      id: id,
      fullName: full.isEmpty ? (id.isEmpty ? '(sin nombre)' : id) : full,
      firstName: first,
      lastName: last,
      idCard: _P.str(j['idCard'] ?? j['cardId']),
      email: _P.str(j['email'] ?? j['internalEmail']),
      positionName: _P.str(j['positionName']),
    );
  }
}
