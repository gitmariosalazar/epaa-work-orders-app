// Pantalla de Configuración (portada de app-properties).
//
//  - Presentación pura: lee la sesión vía [SessionService] (DIP, inyectado
//    con GetIt) y delega el cierre de sesión al servicio.
//  - Control de tema reactivo vía [ThemeCubit] (Clean Architecture + SOLID).
//  - Cada widget privado/compartido tiene una sola responsabilidad (SRP).
import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:clean_architecture/features/theme/presentation/cubits/theme_cubit.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatefulWidget {
  final SessionService? session;

  const SettingsScreen({super.key, this.session});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SessionService _session =
      widget.session ?? GetIt.I<SessionService>();
  bool _notifications = true;

  static const _appVersion = '1.0.0';

  @override
  Widget build(BuildContext context) {
    final user = _session.isLoggedIn ? _session.userData.user : null;
    final isDark = context.watch<ThemeCubit>().isDark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const BaseAppBar(
        title: 'Configuración',
        showBottomBorder: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          if (user != null) _ProfileBanner(user: user, onEdit: _openProfile),

          // ── General ───────────────────────────────────────────────
          const SectionHeader('General'),
          SettingsCard(
            children: [
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 10, left: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                        : const Color(0xFF1A2035).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    size: 20,
                    color: isDark
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF1A2035),
                  ),
                ),
                title: Text(
                  isDark ? 'Modo oscuro' : 'Modo claro',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  isDark ? 'Interfaz en tono oscuro' : 'Interfaz en tono claro',
                  style: const TextStyle(fontSize: 12),
                ),
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                // Track activo: ámbar en dark, azul marino en light
                activeTrackColor: isDark
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF1A2035),
                // Thumb SIEMPRE blanco — máximo contraste sobre cualquier track
                activeThumbColor: Colors.white,
                // Track inactivo: neutro sutil
                inactiveTrackColor: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.15),
                inactiveThumbColor: Colors.white,
              ),
              const Divider(height: 1, indent: 56),
              SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 10, left: 6),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1565C0,
                    ).withValues(alpha: isDark ? 0.20 : 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    size: 20,
                    color: Color(0xFF1565C0),
                  ),
                ),
                title: const Text(
                  'Notificaciones',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Alertas de órdenes de trabajo e incidencias',
                  style: TextStyle(fontSize: 12),
                ),
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
                activeTrackColor: const Color(0xFF1565C0),
                activeThumbColor: Colors.white,
                inactiveTrackColor: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.15),
                inactiveThumbColor: Colors.white,
              ),
              const Divider(height: 1, indent: 56),
              SettingsTile(
                icon: Icons.security_rounded,

                iconColor: const Color(0xFF2E7D32),
                iconBg: const Color(0xFFE8F5E9),
                title: 'Estado de seguridad',
                subtitle: 'Verificar estado de autenticación',
                onTap: () => _showSecurityStatus(context),
              ),
            ],
          ),

          // ── Organización ──────────────────────────────────────────
          const SectionHeader('Organización'),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.person_rounded,
                iconColor: const Color(0xFF1565C0),
                iconBg: const Color(0xFFE3F2FD),
                title: 'Mi Perfil',
                subtitle: 'Ver información personal y cambiar contraseña',
                onTap: _openProfile,
              ),
              const Divider(height: 1, indent: 56),
              const SettingsTile(
                icon: Icons.location_city_rounded,
                iconColor: Color(0xFF6A1B9A),
                iconBg: Color(0xFFF3E5F5),
                title: 'EPAA-AA',
                subtitle:
                    'Empresa de Agua Potable y Alcantarillado de Antonio Ante',
                trailing: SizedBox.shrink(),
              ),
            ],
          ),

          // ── Aplicación ────────────────────────────────────────────
          const SectionHeader('Aplicación'),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.assignment_rounded,
                iconColor: const Color(0xFF1565C0),
                iconBg: const Color(0xFFE3F2FD),
                title: 'Órdenes de Trabajo',
                subtitle: 'Listado y gestión de órdenes',
                onTap: () => context.router.push(const WorkOrdersHomeRoute()),
              ),
              const Divider(height: 1, indent: 56),
              SettingsTile(
                icon: Icons.report_problem_rounded,
                iconColor: const Color(0xFFC62828),
                iconBg: const Color(0xFFFFEBEE),
                title: 'Incidencias',
                subtitle: 'Historial de incidentes reportados',
                onTap: () => context.router.push(const IncidentHistoryRoute()),
              ),
              const Divider(height: 1, indent: 56),
              SettingsTile(
                icon: Icons.qr_code_scanner_rounded,
                iconColor: const Color(0xFF00695C),
                iconBg: const Color(0xFFE0F2F1),
                title: 'Escaneo QR',
                subtitle: 'Acceder rápido a predios por código QR',
                onTap: () => context.router.push(const PropertyScanRoute()),
              ),
            ],
          ),

          // ── Soporte ───────────────────────────────────────────────
          const SectionHeader('Soporte'),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.info_rounded,
                iconColor: const Color(0xFF607D8B),
                iconBg: const Color(0xFFECEFF1),
                title: 'Acerca de la aplicación',
                subtitle: 'Versión $_appVersion · EPAA-AA © 2026',
                onTap: () => _showAbout(context),
              ),
            ],
          ),

          // ── Cerrar sesión ─────────────────────────────────────────
          const SizedBox(height: 20),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.logout_rounded,
                iconColor: const Color(0xFFC62828),
                iconBg: const Color(0xFFFFEBEE),
                title: 'Cerrar sesión',
                titleColor: const Color(0xFFC62828),
                subtitle: user != null
                    ? '${user.firstName} ${user.lastName}'
                    : 'Sesión activa',
                onTap: () => _confirmSignOut(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openProfile() => context.router.push(const ProfileRoute());

  void _showSecurityStatus(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Estado de seguridad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SecurityItem(
              icon: _session.isLoggedIn
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              color: _session.isLoggedIn
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFC62828),
              label: _session.isLoggedIn
                  ? 'Sesión autenticada con JWT'
                  : 'Sin sesión activa',
            ),
            const SizedBox(height: 8),
            const SecurityItem(
              icon: Icons.check_circle_rounded,
              color: Color(0xFF2E7D32),
              label: 'Renovación automática de token',
            ),
            const SizedBox(height: 8),
            const SecurityItem(
              icon: Icons.check_circle_rounded,
              color: Color(0xFF2E7D32),
              label: 'Datos almacenados de forma segura',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Órdenes de Trabajo EPAA-AA',
      applicationVersion: _appVersion,
      applicationLegalese: '© 2026 EPAA-AA · Antonio Ante, Ecuador',
      children: const [
        SizedBox(height: 12),
        Text(
          'Sistema de gestión de órdenes de trabajo, incidencias y acometidas '
          'de la Empresa de Agua Potable y Alcantarillado de Antonio Ante.',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión? Se perderá la sesión activa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              _session.clearSessionData();
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta con los datos del usuario autenticado.
class _ProfileBanner extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;

  const _ProfileBanner({required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = user.roles.any(
      (r) => r.toUpperCase() == 'SUPER ADMINISTRADOR',
    );
    final dotColor = isSuperAdmin
        ? const Color(0xFFFFC107)
        : const Color(0xFF1EB980);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1628), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 6),
                if (user.roles.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.roles.first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSuperAdmin ? 'Super Administrador' : 'Administrador',
                      style: TextStyle(
                        color: isSuperAdmin
                            ? const Color(0xFFFFC107)
                            : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white70,
              size: 20,
            ),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
