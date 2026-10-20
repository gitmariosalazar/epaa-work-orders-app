// features/dashboard/presentation/pages/technician/widgets/technician_header_section.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:flutter/material.dart';

class TechnicianHeaderSection extends StatelessWidget {
  final VoidCallback? onNotificationPressed;

  const TechnicianHeaderSection({super.key, this.onNotificationPressed});

  String _getFormattedDate() {
    final now = DateTime.now();
    const weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    return '$weekday, ${now.day} $month';
  }

  String _getUserDisplayName() {
    if (SessionUtil.I.isLoggedIn) {
      final full = SessionUtil.I.fullName.trim();
      if (full.isNotEmpty) {
        return full;
      }
      try {
        final user = SessionUtil.I.userData.user;
        if (user.username.trim().isNotEmpty) {
          return user.username.trim();
        }
      } catch (_) {}
    }
    return 'Técnico';
  }

  String _getUserInitials(String displayName) {
    if (SessionUtil.I.isLoggedIn) {
      try {
        final user = SessionUtil.I.userData.user;
        final fn = user.firstName.trim();
        final ln = user.lastName.trim();
        if (fn.isNotEmpty && ln.isNotEmpty) {
          return '${fn[0]}${ln[0]}'.toUpperCase();
        }
        if (fn.isNotEmpty) {
          return fn.length >= 2
              ? fn.substring(0, 2).toUpperCase()
              : fn[0].toUpperCase();
        }
        final un = user.username.trim();
        if (un.isNotEmpty) {
          return un.length >= 2
              ? un.substring(0, 2).toUpperCase()
              : un[0].toUpperCase();
        }
      } catch (_) {}
    }

    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].length >= 2
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0][0].toUpperCase();
    }
    return 'TE';
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? cs.surfaceContainerHighest : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: cs.error, size: 22),
            const SizedBox(width: 10),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas cerrar tu sesión actual?',
          style: TextStyle(fontSize: 13.5, color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              SessionUtil.I.clearSessionData();
            },
            icon: const Icon(Icons.logout_rounded, size: 16),
            label: const Text('Salir'),
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final displayName = _getUserDisplayName();
    final initials = _getUserInitials(displayName);
    final formattedDate = _getFormattedDate();

    final avatarTextColor = isDark ? const Color(0xFF38BDF8) : cs.primary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Avatar con iniciales
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withValues(alpha: isDark ? 0.22 : 0.10),
              border: Border.all(
                color: cs.primary.withValues(alpha: isDark ? 0.45 : 0.25),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: avatarTextColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Saludo y Fecha
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hola, $displayName',
                  style:
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ) ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Campana de notificaciones
          IconButton(
            tooltip: 'Notificaciones',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 24,
                  color: cs.onSurface,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed:
                onNotificationPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No tienes notificaciones pendientes'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
          ),

          // Menú popup desplegable
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: cs.onSurface),
            tooltip: 'Más opciones',
            color: isDark ? cs.surfaceContainerHighest : Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            offset: const Offset(0, 45),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'my_profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 20,
                      color: isDark ? cs.onSurface : AppColors.onSurface,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Mi perfil',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Ajustes',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 20, color: cs.error),
                    const SizedBox(width: 10),
                    Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: cs.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'my_profile':
                  context.router.push(const ProfileRoute());
                  break;
                case 'settings':
                  context.router.push(const SettingRoute());
                  break;
                case 'logout':
                  _showLogoutDialog(context);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
