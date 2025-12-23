// features/dashboard/presentation/pages/dashboard/widgets/dashboard_drawer.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25.widthPart(max: 300),
      child: Material(
        color: AppColors.border,
        child: Padding(
          padding: UIHelpers.paddingA24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<DashboardCubit, DashboardState>(
                buildWhen: (previous, current) =>
                    previous.activeIndex != current.activeIndex,
                builder: (context, state) {
                  return Column(
                    children: [
                      BaseText.headline("Dashboard"),
                      UIHelpers.spaceV16,

                      // 1. INICIO - índice 0
                      ListTile(
                        onTap: () => context.read<DashboardCubit>().setIndex(0),
                        visualDensity: const VisualDensity(),
                        horizontalTitleGap: 8,
                        leading: Icon(
                          AppIcons.home,
                          size: 20,
                          color: state.activeIndex == 0
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                        title: BaseText(
                          "Inicio",
                          color: state.activeIndex == 0
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                      ),

                      // 2. ÓRDENES DE TRABAJO - índice 1
                      ListTile(
                        onTap: () => context.read<DashboardCubit>().setIndex(1),
                        visualDensity: const VisualDensity(),
                        horizontalTitleGap: 8,
                        leading: Icon(
                          Icons.assignment, // o tu icono personalizado
                          size: 20,
                          color: state.activeIndex == 1
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                        title: BaseText(
                          "Órdenes de Trabajo",
                          color: state.activeIndex == 1
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                          textType: context.isMobile
                              ? TextType.bodySmall
                              : TextType.bodyMedium,
                        ),
                      ),

                      // 4. TRABAJADORES - índice 2
                      ListTile(
                        onTap: () => context.read<DashboardCubit>().setIndex(2),
                        visualDensity: const VisualDensity(),
                        horizontalTitleGap: 8,
                        leading: Icon(
                          AppIcons.workers,
                          size: 20,
                          color: state.activeIndex == 2
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                        title: BaseText(
                          "Trabajadores",
                          color: state.activeIndex == 2
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                      ),
                      // 5. PRODUCTOS Y MATERIALES - índice 3
                      ListTile(
                        onTap: () => context.read<DashboardCubit>().setIndex(3),
                        visualDensity: const VisualDensity(),
                        horizontalTitleGap: 8,
                        leading: Icon(
                          AppIcons.products_materials,
                          size: 20,
                          color: state.activeIndex == 3
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                        title: BaseText(
                          "Productos",
                          color: state.activeIndex == 3
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                      ),
                      // 6. PERFIL - índice 4
                      ListTile(
                        onTap: () => context.read<DashboardCubit>().setIndex(4),
                        visualDensity: const VisualDensity(),
                        horizontalTitleGap: 8,
                        leading: Icon(
                          AppIcons.profile,
                          size: 20,
                          color: state.activeIndex == 4
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                        title: BaseText(
                          "Perfil",
                          color: state.activeIndex == 4
                              ? AppColors.primary
                              : AppColors.fade.withAlpha(153),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
