// features/dashboard/presentation/pages/setting/setting_page.dart
//
// Ruta de Configuración: delega en el feature `settings` (SRP).
import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) => const SettingsScreen();
}
