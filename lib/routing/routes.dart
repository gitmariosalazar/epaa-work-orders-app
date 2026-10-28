import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/routing/guards/authenticated_guard.dart';
import 'package:clean_architecture/routing/helper/route_data.dart';
import 'package:clean_architecture/routing/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: LoginRoute.page, path: LOGIN_PATH),
    AutoRoute(
      path: DASHBOARD_PATH,
      page: DashboardRoute.page,
      initial: true,
      guards: const [AuthenticatedGuard()],
      children: [
        AutoRoute(
          path: TECHNICIAN_INITIAL_PATH,
          page: TechnicianInitialRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: WORK_ORDERS_PATH,
          page: WorkOrdersHomeRoute.page,
        ),
        AutoRoute(path: HOME_PATH, page: HomeRoute.page),
        AutoRoute(path: SETTING_PATH, page: SettingRoute.page),
        AutoRoute(
          path: CREATE_WORK_ORDER_PATH,
          page: CreateWorkOrderRoute.page,
        ),
        AutoRoute(path: WORKERS_PATH, page: WorkersHomeRoute.page),
        AutoRoute(
          path: 'property-scan',
          page: PropertyScanRoute.page,
        ),
        AutoRoute(
          path: 'manually-entry-properties',
          page: ManualEntryConnectionWithPropertiesScreen.page,
        ),
        AutoRoute(
          path: 'update-connection-number',
          page: UpdateMeterNumberFormScreen.page,
        ),
        AutoRoute(
          path: 'update-location-form',
          page: UpdateLocationFormScreen.page,
        ),
        AutoRoute(
          path: 'search-connection',
          page: SearchConnectionRoute.page,
        ),
        AutoRoute(
          path: 'create-incident',
          page: CreateIncidentForm.page,
        ),
        AutoRoute(
          path: 'incidents-history',
          page: IncidentHistoryRoute.page,
        ),
        AutoRoute(
          path: 'solve-incident',
          page: SolveIncidentScreen.page,
        ),
        AutoRoute(
          path: 'solve-and-change-meter',
          page: SolveAndChangeMeterIncidentScreen.page,
        ),
        AutoRoute(
          path: PRODUCTS_MATERIALS_PATH,
          page: ProductsMaterialsHomeRoute.page,
        ),
        AutoRoute(path: PROFILE_PATH, page: ProfileRoute.page),
        AutoRoute(
          path: WORK_ORDER_DETAIL_PATH,
          page: WorkOrderDetailRoute.page,
        ),
        AutoRoute(
          path: WORK_ORDER_PROCESS_PATH,
          page: WorkOrderProcessRoute.page,
        ),
        AutoRoute(path: WORK_ORDER_MAP_PATH, page: WorkOrderMapRoute.page),
        AutoRoute(path: WORK_ORDERS_MAP_PATH, page: WorkOrdersMapRoute.page),
        AutoRoute(
          path: DASHBOARD_PRIORITIES_PATH,
          page: DashboardPrioritiesRoute.page,
        ),
        AutoRoute(
          path: DASHBOARD_STATUSES_PATH,
          page: DashboardWorkStatusRoute.page,
        ),
        AutoRoute(
          path: DASHBOARD_WORK_TYPES_PATH,
          page: DashboardWorkTypesRoute.page,
        ),
        AutoRoute(
          path: DASHBOARD_WORKERS_PATH,
          page: WorkOrdersDashboardRoute.page,
        ),
        AutoRoute(
          path: GENERAL_DASHBOARD_PATH,
          page: GeneralDashboardRoute.page,
        ),
      ],
    ),
  ];
}
