// features/dashboard/presentation/pages/dashboard/widgets/base_bottom_navigation.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBottomNavigation extends StatelessWidget {
  /// Altura de la barra (fuente única de verdad para el layout).
  static const double height = 70;

  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const BaseBottomNavigation({
    super.key,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Colores adaptativos para Light y Dark theme
    final backgroundColor = isDark
        ? colorScheme.surfaceContainerHighest
        : colorScheme.surface;

    final borderColor = isDark
        ? colorScheme.outlineVariant
        : AppColors.border.withValues(alpha: 0.6);

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.45)
        : AppColors.black10;

    final activeColor = colorScheme.primary;

    final inactiveColor = isDark
        ? colorScheme.onSurfaceVariant
        : AppColors.fade.withValues(alpha: 0.85);

    final activeIndicatorColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.16 : 0.10,
    );

    final splashColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.18 : 0.12,
    );

    final highlightColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.10 : 0.06,
    );

    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);

    final icons = [
      AppIcons.home, // Inicio
      Icons.construction, // Órdenes
      AppIcons.workers, // Trabajadores
      AppIcons.products_materials, // Productos y Materiales
      AppIcons.profile, // Perfil
    ];

    final labels = ['Inicio', 'Órdenes', 'Trabaj...', 'Productos', 'Perfil'];

    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveRadius,
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: isDark ? 0 : 2,
            blurRadius: isDark ? 10 : 6,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BlocBuilder<DashboardCubit, DashboardState>(
          buildWhen: (previous, current) =>
              previous.activeIndex != current.activeIndex,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(icons.length, (index) {
                final isActive = index == state.activeIndex;
                return Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          context.read<DashboardCubit>().setIndex(index),
                      splashColor: splashColor,
                      highlightColor: highlightColor,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? activeIndicatorColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                icons[index],
                                size: 24,
                                color: isActive ? activeColor : inactiveColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                color: isActive ? activeColor : inactiveColor,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              child: Text(
                                labels[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
