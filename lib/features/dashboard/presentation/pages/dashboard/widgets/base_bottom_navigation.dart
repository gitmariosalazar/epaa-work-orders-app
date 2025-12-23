// features/dashboard/presentation/pages/dashboard/widgets/base_bottom_navigation.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/base_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBottomNavigation extends StatelessWidget {
  const BaseBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = [
      AppIcons.home, // Inicio
      Icons.construction, // Órdenes
      AppIcons.workers, // Trabajadores
      AppIcons.products_materials, // Productos y Materiales
      AppIcons.profile, // Perfil
    ];

    final labels = ['Inicio', 'Órdenes', 'Trabaj...', 'Productos', 'Perfil'];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.black10, spreadRadius: 2, blurRadius: 4),
        ],
      ),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) =>
            previous.activeIndex != current.activeIndex,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final isActive = index == state.activeIndex;
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseIconButton(
                      onPressed: () =>
                          context.read<DashboardCubit>().setIndex(index),
                      padding: const EdgeInsets.all(12),
                      icon: Icon(
                        icons[index],
                        size: 26,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.fade.withAlpha(153),
                      ),
                    ),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.fade.withAlpha(153),
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
