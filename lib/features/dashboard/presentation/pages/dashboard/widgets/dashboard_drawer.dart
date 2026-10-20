// features/dashboard/presentation/pages/dashboard/widgets/dashboard_drawer.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Modelo inmutable que representa un destino de navegación en el drawer.
/// Cumple con Single Responsibility Principle (SRP).
class DrawerNavigationItem {
  final IconData icon;
  final String title;
  final int index;

  const DrawerNavigationItem({
    required this.icon,
    required this.title,
    required this.index,
  });
}

/// Drawer lateral para pantallas de escritorio del Dashboard.
/// Adaptado para Light y Dark theme respetando Clean Architecture y principios SOLID.
class DashboardDrawer extends StatelessWidget {
  final double? width;
  final List<DrawerNavigationItem>? items;
  final ValueChanged<int>? onItemSelected;

  const DashboardDrawer({
    super.key,
    this.width,
    this.items,
    this.onItemSelected,
  });

  /// Lista por defecto de elementos de navegación (abierta a extensión - OCP).
  static const List<DrawerNavigationItem> defaultItems = [
    DrawerNavigationItem(
      icon: AppIcons.home,
      title: 'Inicio',
      index: 0,
    ),
    DrawerNavigationItem(
      icon: Icons.assignment,
      title: 'Órdenes de Trabajo',
      index: 1,
    ),
    DrawerNavigationItem(
      icon: AppIcons.workers,
      title: 'Trabajadores',
      index: 2,
    ),
    DrawerNavigationItem(
      icon: AppIcons.products_materials,
      title: 'Productos',
      index: 3,
    ),
    DrawerNavigationItem(
      icon: AppIcons.profile,
      title: 'Perfil',
      index: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Colores semánticos adaptados según el tema actual
    final backgroundColor = isDark
        ? colorScheme.surfaceContainerHighest
        : colorScheme.surface;

    final borderColor = isDark
        ? colorScheme.outlineVariant
        : AppColors.border.withValues(alpha: 0.6);

    final activeColor = colorScheme.primary;

    final inactiveColor = isDark
        ? colorScheme.onSurfaceVariant
        : AppColors.fade.withValues(alpha: 0.85);

    final activeBackgroundColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.16 : 0.10,
    );

    final hoverColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.08 : 0.04,
    );

    final navItems = items ?? defaultItems;
    final drawerWidth = width ?? 25.widthPart(min: 200, max: 300);

    return SizedBox(
      width: drawerWidth,
      child: Material(
        color: backgroundColor,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: UIHelpers.paddingA24,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText.headline(
                    "Dashboard",
                    color: colorScheme.onSurface,
                  ),
                  UIHelpers.spaceV16,
                  BlocBuilder<DashboardCubit, DashboardState>(
                    buildWhen: (previous, current) =>
                        previous.activeIndex != current.activeIndex,
                    builder: (context, state) {
                      final int activeIndex = state.activeIndex;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: navItems.map((item) {
                          final isActive = item.index == activeIndex;
                          return _DrawerItemTile(
                            item: item,
                            isActive: isActive,
                            activeColor: activeColor,
                            inactiveColor: inactiveColor,
                            activeBackgroundColor: activeBackgroundColor,
                            hoverColor: hoverColor,
                            onTap: () {
                              if (onItemSelected != null) {
                                onItemSelected!(item.index);
                              } else {
                                context
                                    .read<DashboardCubit>()
                                    .setIndex(item.index);
                              }
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget encapsulado para renderizar un ítem individual de navegación.
/// Cumple con Single Responsibility (SRP) e Interface Segregation (ISP).
class _DrawerItemTile extends StatelessWidget {
  final DrawerNavigationItem item;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBackgroundColor;
  final Color hoverColor;
  final VoidCallback onTap;

  const _DrawerItemTile({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeBackgroundColor,
    required this.hoverColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        onTap: onTap,
        selected: isActive,
        tileColor: Colors.transparent,
        selectedTileColor: activeBackgroundColor,
        hoverColor: hoverColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Icon(
          item.icon,
          size: 20,
          color: isActive ? activeColor : inactiveColor,
        ),
        title: BaseText(
          item.title,
          color: isActive ? activeColor : inactiveColor,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          textType: TextType.bodyMedium,
        ),
      ),
    );
  }
}
