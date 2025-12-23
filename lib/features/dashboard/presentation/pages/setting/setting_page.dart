// features/dashboard/presentation/pages/setting/setting_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/primary_button.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = SessionUtil.I.fullName ?? 'Mario Salazar';
    final userEmail = 'email@empresa.com';
    final userRole = 'Sowftware Developer';
    return BaseScaffold(
      onPopInvokedWithResult: () => context.read<DashboardCubit>().setIndex(0),
      isScrollable: true,
      usePadding: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Fondo azul superior con foto de perfil
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primary],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Foto de perfil
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: const AssetImage(
                        'assets/images/epaa.png',
                      ), // opcional: agrega una foto por defecto
                      child: SessionUtil.I.fullName == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white70,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userRole,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userEmail,
                    style: const TextStyle(fontSize: 14, color: Colors.white60),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Opciones del perfil
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _ProfileOption(
                    icon: Icons.person_outline,
                    title: 'Editar Perfil',
                    onTap: () {
                      // TODO: Navegar a pantalla de edición de perfil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Editar perfil - Próximamente'),
                        ),
                      );
                    },
                  ),
                  _ProfileOption(
                    icon: Icons.lock_outline,
                    title: 'Cambiar Contraseña',
                    onTap: () {
                      // TODO: Navegar a cambiar contraseña
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cambiar contraseña - Próximamente'),
                        ),
                      );
                    },
                  ),
                  _ProfileOption(
                    icon: Icons.notifications_outlined,
                    title: 'Notificaciones',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notificaciones - Próximamente'),
                        ),
                      );
                    },
                  ),

                  // Botón de Logout
                  PrimaryButton(
                    onTap: () {
                      SessionUtil.I.clearSessionData();
                      context.router.replaceAll([const LoginRoute()]);
                    },
                    text: "Cerrar Sesión",
                    color: AppColors.error,
                    expandWidth: true,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Opción del perfil (reutilizable y atractiva)
class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
