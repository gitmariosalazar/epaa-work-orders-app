import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/base_bottom_navigation.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/dashboard_drawer.dart';
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/shared_ui/ui/feedback/bottom_nav_snackbar_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  /// Espacio reservado bajo el contenido para la barra flotante.
  static const double _contentBottomPadding = 50;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<DashboardCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<ScreenObserverCubit, ScreenObserverState>(
        buildWhen: (previous, current) =>
            previous.desktopLayoutChanges != current.desktopLayoutChanges,
        builder: (context, state) {
          final isDesktopLargeScreen = ScreenUtil.I.isWebDesktopScreen;
          return Row(
            children: [
              if (isDesktopLargeScreen) DashboardDrawer(),
              Flexible(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: _contentBottomPadding,
                        ),
                        child: isDesktopLargeScreen
                            ? const AutoRouter()
                            : const BottomNavSnackBarScope(
                                navigationHeight: BaseBottomNavigation.height,
                                reservedBottom: _contentBottomPadding,
                                child: AutoRouter(),
                              ),
                      ),
                      if (!isDesktopLargeScreen)
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: BaseBottomNavigation(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
