/// Técnico/empleado devuelto por `/user-employee-gateway/find-technicians`.
class TechnicianEntity {
  final String id;
  final String fullName;
  final String? firstName;
  final String? lastName;
  final String? idCard;
  final String? email;
  final String? positionName;

  const TechnicianEntity({
    required this.id,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.idCard,
    this.email,
    this.positionName,
  });
}

/// Tipos de técnico soportados por el backend (`?type=`).
abstract final class TechnicianType {
  static const inspector = 'INSPECTOR';
  static const instalador = 'INSTALADOR';
}
