// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:clean_architecture/features/auth/presentation/pages/login/login_page.dart'
    as _i9;
import 'package:clean_architecture/features/connections/domain/entities/connection.dart'
    as _i29;
import 'package:clean_architecture/features/connections/form/presentation/screen/update_location_form.dart'
    as _i18;
import 'package:clean_architecture/features/connections/form/presentation/screen/update_meter_number_form_screen.dart'
    as _i19;
import 'package:clean_architecture/features/connections/search/presentation/info/pages/search_connection_page.dart'
    as _i14;
import 'package:clean_architecture/features/connections/search/presentation/manually/pages/manually_screen.dart'
    as _i10;
import 'package:clean_architecture/features/connections/search/presentation/scan/pages/scan_screen.dart'
    as _i13;
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/dashboard_page.dart'
    as _i3;
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/work_orders_dashboard_page.dart'
    as _i23;
import 'package:clean_architecture/features/dashboard/presentation/pages/home/home_page.dart'
    as _i7;
import 'package:clean_architecture/features/dashboard/presentation/pages/home/widgets/priority_dashboard.dart'
    as _i4;
import 'package:clean_architecture/features/dashboard/presentation/pages/home/widgets/work_status_dashboard.dart'
    as _i5;
import 'package:clean_architecture/features/dashboard/presentation/pages/home/widgets/work_type_dashboard.dart'
    as _i6;
import 'package:clean_architecture/features/dashboard/presentation/pages/setting/setting_page.dart'
    as _i15;
import 'package:clean_architecture/features/incidents/presentation/page/create_incident_form.dart'
    as _i1;
import 'package:clean_architecture/features/incidents/presentation/page/incident_history_page.dart'
    as _i8;
import 'package:clean_architecture/features/incidents/presentation/pages/solve_and_changemeter_incident_screen.dart'
    as _i16;
import 'package:clean_architecture/features/incidents/presentation/pages/solve_incident_screen.dart'
    as _i17;
import 'package:clean_architecture/features/products/presentation/pages/products_materials_home_page.dart'
    as _i11;
import 'package:clean_architecture/features/profile/presentation/pages/profile_page.dart'
    as _i12;
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart'
    as _i30;
import 'package:clean_architecture/features/work-orders/presentation/pages/create_work_order_page.dart'
    as _i2;
import 'package:clean_architecture/features/work-orders/presentation/pages/process/work_order_process_page.dart'
    as _i22;
import 'package:clean_architecture/features/work-orders/presentation/pages/work_orders_home_page.dart'
    as _i24;
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/maps/work_order_map_page.dart'
    as _i21;
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/maps/work_orders_map_page.dart'
    as _i25;
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/work_order_detail_page.dart'
    as _i20;
import 'package:clean_architecture/features/workers/presentation/pages/workers_home_page.dart'
    as _i26;
import 'package:flutter/material.dart' as _i28;

/// generated route for
/// [_i1.CreateIncidentForm]
class CreateIncidentForm extends _i27.PageRouteInfo<CreateIncidentFormArgs> {
  CreateIncidentForm({
    _i28.Key? key,
    String connectionId = '',
    List<_i27.PageRouteInfo>? children,
  }) : super(
         CreateIncidentForm.name,
         args: CreateIncidentFormArgs(key: key, connectionId: connectionId),
         initialChildren: children,
       );

  static const String name = 'CreateIncidentForm';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateIncidentFormArgs>(
        orElse: () => const CreateIncidentFormArgs(),
      );
      return _i27.WrappedRoute(
        child: _i1.CreateIncidentForm(
          key: args.key,
          connectionId: args.connectionId,
        ),
      );
    },
  );
}

class CreateIncidentFormArgs {
  const CreateIncidentFormArgs({this.key, this.connectionId = ''});

  final _i28.Key? key;

  final String connectionId;

  @override
  String toString() {
    return 'CreateIncidentFormArgs{key: $key, connectionId: $connectionId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateIncidentFormArgs) return false;
    return key == other.key && connectionId == other.connectionId;
  }

  @override
  int get hashCode => key.hashCode ^ connectionId.hashCode;
}

/// generated route for
/// [_i2.CreateWorkOrderPage]
class CreateWorkOrderRoute extends _i27.PageRouteInfo<void> {
  const CreateWorkOrderRoute({List<_i27.PageRouteInfo>? children})
    : super(CreateWorkOrderRoute.name, initialChildren: children);

  static const String name = 'CreateWorkOrderRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateWorkOrderPage();
    },
  );
}

/// generated route for
/// [_i3.DashboardPage]
class DashboardRoute extends _i27.PageRouteInfo<void> {
  const DashboardRoute({List<_i27.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i3.DashboardPage();
    },
  );
}

/// generated route for
/// [_i4.DashboardPrioritiesPage]
class DashboardPrioritiesRoute extends _i27.PageRouteInfo<void> {
  const DashboardPrioritiesRoute({List<_i27.PageRouteInfo>? children})
    : super(DashboardPrioritiesRoute.name, initialChildren: children);

  static const String name = 'DashboardPrioritiesRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i4.DashboardPrioritiesPage();
    },
  );
}

/// generated route for
/// [_i5.DashboardWorkStatusPage]
class DashboardWorkStatusRoute extends _i27.PageRouteInfo<void> {
  const DashboardWorkStatusRoute({List<_i27.PageRouteInfo>? children})
    : super(DashboardWorkStatusRoute.name, initialChildren: children);

  static const String name = 'DashboardWorkStatusRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i5.DashboardWorkStatusPage();
    },
  );
}

/// generated route for
/// [_i6.DashboardWorkTypesPage]
class DashboardWorkTypesRoute extends _i27.PageRouteInfo<void> {
  const DashboardWorkTypesRoute({List<_i27.PageRouteInfo>? children})
    : super(DashboardWorkTypesRoute.name, initialChildren: children);

  static const String name = 'DashboardWorkTypesRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i6.DashboardWorkTypesPage();
    },
  );
}

/// generated route for
/// [_i7.HomePage]
class HomeRoute extends _i27.PageRouteInfo<void> {
  const HomeRoute({List<_i27.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomePage();
    },
  );
}

/// generated route for
/// [_i8.IncidentHistoryPage]
class IncidentHistoryRoute extends _i27.PageRouteInfo<void> {
  const IncidentHistoryRoute({List<_i27.PageRouteInfo>? children})
    : super(IncidentHistoryRoute.name, initialChildren: children);

  static const String name = 'IncidentHistoryRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return _i27.WrappedRoute(child: const _i8.IncidentHistoryPage());
    },
  );
}

/// generated route for
/// [_i9.LoginPage]
class LoginRoute extends _i27.PageRouteInfo<void> {
  const LoginRoute({List<_i27.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i9.LoginPage();
    },
  );
}

/// generated route for
/// [_i10.ManualEntryConnectionWithPropertiesScreen]
class ManualEntryConnectionWithPropertiesScreen
    extends _i27.PageRouteInfo<void> {
  const ManualEntryConnectionWithPropertiesScreen({
    List<_i27.PageRouteInfo>? children,
  }) : super(
         ManualEntryConnectionWithPropertiesScreen.name,
         initialChildren: children,
       );

  static const String name = 'ManualEntryConnectionWithPropertiesScreen';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return _i27.WrappedRoute(
        child: const _i10.ManualEntryConnectionWithPropertiesScreen(),
      );
    },
  );
}

/// generated route for
/// [_i11.ProductsMaterialsHomePage]
class ProductsMaterialsHomeRoute extends _i27.PageRouteInfo<void> {
  const ProductsMaterialsHomeRoute({List<_i27.PageRouteInfo>? children})
    : super(ProductsMaterialsHomeRoute.name, initialChildren: children);

  static const String name = 'ProductsMaterialsHomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i11.ProductsMaterialsHomePage();
    },
  );
}

/// generated route for
/// [_i12.ProfilePage]
class ProfileRoute extends _i27.PageRouteInfo<void> {
  const ProfileRoute({List<_i27.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i12.ProfilePage();
    },
  );
}

/// generated route for
/// [_i13.PropertyScanPage]
class PropertyScanRoute extends _i27.PageRouteInfo<void> {
  const PropertyScanRoute({List<_i27.PageRouteInfo>? children})
    : super(PropertyScanRoute.name, initialChildren: children);

  static const String name = 'PropertyScanRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return _i27.WrappedRoute(child: const _i13.PropertyScanPage());
    },
  );
}

/// generated route for
/// [_i14.SearchConnectionPage]
class SearchConnectionRoute
    extends _i27.PageRouteInfo<SearchConnectionRouteArgs> {
  SearchConnectionRoute({
    _i28.Key? key,
    String mode = 'update-form',
    List<_i27.PageRouteInfo>? children,
  }) : super(
         SearchConnectionRoute.name,
         args: SearchConnectionRouteArgs(key: key, mode: mode),
         initialChildren: children,
       );

  static const String name = 'SearchConnectionRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchConnectionRouteArgs>(
        orElse: () => const SearchConnectionRouteArgs(),
      );
      return _i27.WrappedRoute(
        child: _i14.SearchConnectionPage(key: args.key, mode: args.mode),
      );
    },
  );
}

class SearchConnectionRouteArgs {
  const SearchConnectionRouteArgs({this.key, this.mode = 'update-form'});

  final _i28.Key? key;

  final String mode;

  @override
  String toString() {
    return 'SearchConnectionRouteArgs{key: $key, mode: $mode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchConnectionRouteArgs) return false;
    return key == other.key && mode == other.mode;
  }

  @override
  int get hashCode => key.hashCode ^ mode.hashCode;
}

/// generated route for
/// [_i15.SettingPage]
class SettingRoute extends _i27.PageRouteInfo<void> {
  const SettingRoute({List<_i27.PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i15.SettingPage();
    },
  );
}

/// generated route for
/// [_i16.SolveAndChangeMeterIncidentScreen]
class SolveAndChangeMeterIncidentScreen
    extends _i27.PageRouteInfo<SolveAndChangeMeterIncidentScreenArgs> {
  SolveAndChangeMeterIncidentScreen({
    _i28.Key? key,
    required String incidentId,
    required String incidentCode,
    String? connectionId,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         SolveAndChangeMeterIncidentScreen.name,
         args: SolveAndChangeMeterIncidentScreenArgs(
           key: key,
           incidentId: incidentId,
           incidentCode: incidentCode,
           connectionId: connectionId,
         ),
         initialChildren: children,
       );

  static const String name = 'SolveAndChangeMeterIncidentScreen';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SolveAndChangeMeterIncidentScreenArgs>();
      return _i27.WrappedRoute(
        child: _i16.SolveAndChangeMeterIncidentScreen(
          key: args.key,
          incidentId: args.incidentId,
          incidentCode: args.incidentCode,
          connectionId: args.connectionId,
        ),
      );
    },
  );
}

class SolveAndChangeMeterIncidentScreenArgs {
  const SolveAndChangeMeterIncidentScreenArgs({
    this.key,
    required this.incidentId,
    required this.incidentCode,
    this.connectionId,
  });

  final _i28.Key? key;

  final String incidentId;

  final String incidentCode;

  final String? connectionId;

  @override
  String toString() {
    return 'SolveAndChangeMeterIncidentScreenArgs{key: $key, incidentId: $incidentId, incidentCode: $incidentCode, connectionId: $connectionId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SolveAndChangeMeterIncidentScreenArgs) return false;
    return key == other.key &&
        incidentId == other.incidentId &&
        incidentCode == other.incidentCode &&
        connectionId == other.connectionId;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      incidentId.hashCode ^
      incidentCode.hashCode ^
      connectionId.hashCode;
}

/// generated route for
/// [_i17.SolveIncidentScreen]
class SolveIncidentScreen extends _i27.PageRouteInfo<SolveIncidentScreenArgs> {
  SolveIncidentScreen({
    _i28.Key? key,
    required String incidentId,
    required String incidentCode,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         SolveIncidentScreen.name,
         args: SolveIncidentScreenArgs(
           key: key,
           incidentId: incidentId,
           incidentCode: incidentCode,
         ),
         initialChildren: children,
       );

  static const String name = 'SolveIncidentScreen';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SolveIncidentScreenArgs>();
      return _i27.WrappedRoute(
        child: _i17.SolveIncidentScreen(
          key: args.key,
          incidentId: args.incidentId,
          incidentCode: args.incidentCode,
        ),
      );
    },
  );
}

class SolveIncidentScreenArgs {
  const SolveIncidentScreenArgs({
    this.key,
    required this.incidentId,
    required this.incidentCode,
  });

  final _i28.Key? key;

  final String incidentId;

  final String incidentCode;

  @override
  String toString() {
    return 'SolveIncidentScreenArgs{key: $key, incidentId: $incidentId, incidentCode: $incidentCode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SolveIncidentScreenArgs) return false;
    return key == other.key &&
        incidentId == other.incidentId &&
        incidentCode == other.incidentCode;
  }

  @override
  int get hashCode =>
      key.hashCode ^ incidentId.hashCode ^ incidentCode.hashCode;
}

/// generated route for
/// [_i18.UpdateLocationFormScreen]
class UpdateLocationFormScreen
    extends _i27.PageRouteInfo<UpdateLocationFormScreenArgs> {
  UpdateLocationFormScreen({
    _i28.Key? key,
    required _i29.ConnectionWithPropertiesEntity connection,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         UpdateLocationFormScreen.name,
         args: UpdateLocationFormScreenArgs(key: key, connection: connection),
         initialChildren: children,
       );

  static const String name = 'UpdateLocationFormScreen';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UpdateLocationFormScreenArgs>();
      return _i18.UpdateLocationFormScreen(
        key: args.key,
        connection: args.connection,
      );
    },
  );
}

class UpdateLocationFormScreenArgs {
  const UpdateLocationFormScreenArgs({this.key, required this.connection});

  final _i28.Key? key;

  final _i29.ConnectionWithPropertiesEntity connection;

  @override
  String toString() {
    return 'UpdateLocationFormScreenArgs{key: $key, connection: $connection}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UpdateLocationFormScreenArgs) return false;
    return key == other.key && connection == other.connection;
  }

  @override
  int get hashCode => key.hashCode ^ connection.hashCode;
}

/// generated route for
/// [_i19.UpdateMeterNumberFormScreen]
class UpdateMeterNumberFormScreen
    extends _i27.PageRouteInfo<UpdateMeterNumberFormScreenArgs> {
  UpdateMeterNumberFormScreen({
    _i28.Key? key,
    required _i29.ConnectionWithPropertiesEntity connection,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         UpdateMeterNumberFormScreen.name,
         args: UpdateMeterNumberFormScreenArgs(
           key: key,
           connection: connection,
         ),
         initialChildren: children,
       );

  static const String name = 'UpdateMeterNumberFormScreen';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UpdateMeterNumberFormScreenArgs>();
      return _i19.UpdateMeterNumberFormScreen(
        key: args.key,
        connection: args.connection,
      );
    },
  );
}

class UpdateMeterNumberFormScreenArgs {
  const UpdateMeterNumberFormScreenArgs({this.key, required this.connection});

  final _i28.Key? key;

  final _i29.ConnectionWithPropertiesEntity connection;

  @override
  String toString() {
    return 'UpdateMeterNumberFormScreenArgs{key: $key, connection: $connection}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UpdateMeterNumberFormScreenArgs) return false;
    return key == other.key && connection == other.connection;
  }

  @override
  int get hashCode => key.hashCode ^ connection.hashCode;
}

/// generated route for
/// [_i20.WorkOrderDetailPage]
class WorkOrderDetailRoute
    extends _i27.PageRouteInfo<WorkOrderDetailRouteArgs> {
  WorkOrderDetailRoute({
    _i28.Key? key,
    required _i30.WorkOrderEntity order,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         WorkOrderDetailRoute.name,
         args: WorkOrderDetailRouteArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'WorkOrderDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WorkOrderDetailRouteArgs>();
      return _i20.WorkOrderDetailPage(key: args.key, order: args.order);
    },
  );
}

class WorkOrderDetailRouteArgs {
  const WorkOrderDetailRouteArgs({this.key, required this.order});

  final _i28.Key? key;

  final _i30.WorkOrderEntity order;

  @override
  String toString() {
    return 'WorkOrderDetailRouteArgs{key: $key, order: $order}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkOrderDetailRouteArgs) return false;
    return key == other.key && order == other.order;
  }

  @override
  int get hashCode => key.hashCode ^ order.hashCode;
}

/// generated route for
/// [_i21.WorkOrderMapPage]
class WorkOrderMapRoute extends _i27.PageRouteInfo<WorkOrderMapRouteArgs> {
  WorkOrderMapRoute({
    _i28.Key? key,
    required _i30.WorkOrderEntity order,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         WorkOrderMapRoute.name,
         args: WorkOrderMapRouteArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'WorkOrderMapRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WorkOrderMapRouteArgs>();
      return _i21.WorkOrderMapPage(key: args.key, order: args.order);
    },
  );
}

class WorkOrderMapRouteArgs {
  const WorkOrderMapRouteArgs({this.key, required this.order});

  final _i28.Key? key;

  final _i30.WorkOrderEntity order;

  @override
  String toString() {
    return 'WorkOrderMapRouteArgs{key: $key, order: $order}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkOrderMapRouteArgs) return false;
    return key == other.key && order == other.order;
  }

  @override
  int get hashCode => key.hashCode ^ order.hashCode;
}

/// generated route for
/// [_i22.WorkOrderProcessPage]
class WorkOrderProcessRoute
    extends _i27.PageRouteInfo<WorkOrderProcessRouteArgs> {
  WorkOrderProcessRoute({
    _i28.Key? key,
    String? initialOrderCode,
    List<_i27.PageRouteInfo>? children,
  }) : super(
         WorkOrderProcessRoute.name,
         args: WorkOrderProcessRouteArgs(
           key: key,
           initialOrderCode: initialOrderCode,
         ),
         initialChildren: children,
       );

  static const String name = 'WorkOrderProcessRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WorkOrderProcessRouteArgs>(
        orElse: () => const WorkOrderProcessRouteArgs(),
      );
      return _i22.WorkOrderProcessPage(
        key: args.key,
        initialOrderCode: args.initialOrderCode,
      );
    },
  );
}

class WorkOrderProcessRouteArgs {
  const WorkOrderProcessRouteArgs({this.key, this.initialOrderCode});

  final _i28.Key? key;

  final String? initialOrderCode;

  @override
  String toString() {
    return 'WorkOrderProcessRouteArgs{key: $key, initialOrderCode: $initialOrderCode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkOrderProcessRouteArgs) return false;
    return key == other.key && initialOrderCode == other.initialOrderCode;
  }

  @override
  int get hashCode => key.hashCode ^ initialOrderCode.hashCode;
}

/// generated route for
/// [_i23.WorkOrdersDashboardPage]
class WorkOrdersDashboardRoute extends _i27.PageRouteInfo<void> {
  const WorkOrdersDashboardRoute({List<_i27.PageRouteInfo>? children})
    : super(WorkOrdersDashboardRoute.name, initialChildren: children);

  static const String name = 'WorkOrdersDashboardRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i23.WorkOrdersDashboardPage();
    },
  );
}

/// generated route for
/// [_i24.WorkOrdersHomePage]
class WorkOrdersHomeRoute extends _i27.PageRouteInfo<void> {
  const WorkOrdersHomeRoute({List<_i27.PageRouteInfo>? children})
    : super(WorkOrdersHomeRoute.name, initialChildren: children);

  static const String name = 'WorkOrdersHomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i24.WorkOrdersHomePage();
    },
  );
}

/// generated route for
/// [_i25.WorkOrdersMapPage]
class WorkOrdersMapRoute extends _i27.PageRouteInfo<void> {
  const WorkOrdersMapRoute({List<_i27.PageRouteInfo>? children})
    : super(WorkOrdersMapRoute.name, initialChildren: children);

  static const String name = 'WorkOrdersMapRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i25.WorkOrdersMapPage();
    },
  );
}

/// generated route for
/// [_i26.WorkersHomePage]
class WorkersHomeRoute extends _i27.PageRouteInfo<void> {
  const WorkersHomeRoute({List<_i27.PageRouteInfo>? children})
    : super(WorkersHomeRoute.name, initialChildren: children);

  static const String name = 'WorkersHomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i26.WorkersHomePage();
    },
  );
}
