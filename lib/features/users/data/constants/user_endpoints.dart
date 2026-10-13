/// Endpoints del módulo de usuarios (idénticos a epaa-web UserRepositoryImpl).
abstract final class UserEndpoints {
  static const _users = 'users-gateway';
  static const _employees = 'user-employee-gateway';

  // Consultas
  static const findAll = '$_users/find-all';
  static String findById(String id) => '$_users/find-by-id/$id';
  static String findByUsername(String u) => '$_users/find-by-username/$u';
  static String findByEmail(String e) => '$_users/find-by-email/$e';
  static const findByUsernameOrEmail = '$_users/find-by-username-or-email';
  static const findByRefreshToken = '$_users/find-by-refresh-token';
  static String getProfile(String v) => '$_users/get-profile/$v';
  static String getCustomerProfile(String v) => '$_users/get-customer-profile/$v';
  static const verifyCredentials = '$_users/verify-credentials';

  // Validaciones
  static String existsByUsername(String u) => '$_users/exists-by-username/$u';
  static String existsByEmail(String e) => '$_users/exists-by-email/$e';
  static const existsByUsernameOrEmail = '$_users/exists-by-username-or-email';

  // Comandos
  static String updateUser(String id) => '$_users/update-user/$id';
  static String updatePassword(String id) => '$_users/update-password/$id';
  static String softDelete(String id) => '$_users/soft-delete/$id';
  static String restore(String id) => '$_users/restore/$id';

  // Seguridad
  static String resetFailedAttempts(String id) => '$_users/reset-failed-attempts/$id';
  static String incrementFailedAttempts(String id) =>
      '$_users/increment-failed-attempts/$id';

  // Roles y permisos
  static const assignRole = '$_users/assign-role-to-user';
  static const assignPermission = '$_users/assign-permission-to-user';
  static String removeRole(String userId, int roleId) =>
      '$_users/remove-role-from-user/$userId/$roleId';
  static String removePermission(String userId, int permissionId) =>
      '$_users/remove-permission-from-user/$userId/$permissionId';
  static String rolesByUser(String id) => '$_users/get-roles-by-user/$id';
  static String permissionsByUser(String id) => '$_users/get-permissions-by-user/$id';
  static String usersByRole(int id) => '$_users/get-users-by-role/$id';
  static String usersByPermission(int id) => '$_users/get-users-by-permission/$id';

  // Empleados
  static const createEmployee = '$_employees/create';
  static String findByIdCard(String c) => '$_employees/find-by-id-card/$c';
  static const findTechnicians = '$_employees/find-technicians';
}
