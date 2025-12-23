// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:clean_architecture/features/auth/presentation/pages/login/login_page.dart'
    as _i4;
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/dashboard_page.dart'
    as _i2;
import 'package:clean_architecture/features/dashboard/presentation/pages/home/home_page.dart'
    as _i3;
import 'package:clean_architecture/features/dashboard/presentation/pages/setting/setting_page.dart'
    as _i7;
import 'package:clean_architecture/features/products/presentation/pages/products_materials_home_page.dart'
    as _i5;
import 'package:clean_architecture/features/profile/presentation/pages/profile_page.dart'
    as _i6;
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart'
    as _i13;
import 'package:clean_architecture/features/work-orders/presentation/pages/create_work_order_page.dart'
    as _i1;
import 'package:clean_architecture/features/work-orders/presentation/pages/work_orders_home_page.dart'
    as _i9;
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/work_order_detail_page.dart'
    as _i8;
import 'package:clean_architecture/features/workers/presentation/pages/workers_home_page.dart'
    as _i10;
import 'package:flutter/material.dart' as _i12;

/// generated route for
/// [_i1.CreateWorkOrderPage]
class CreateWorkOrderRoute extends _i11.PageRouteInfo<void> {
  const CreateWorkOrderRoute({List<_i11.PageRouteInfo>? children})
    : super(CreateWorkOrderRoute.name, initialChildren: children);

  static const String name = 'CreateWorkOrderRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.CreateWorkOrderPage();
    },
  );
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardRoute extends _i11.PageRouteInfo<void> {
  const DashboardRoute({List<_i11.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.DashboardPage();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i11.PageRouteInfo<void> {
  const LoginRoute({List<_i11.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginPage();
    },
  );
}

/// generated route for
/// [_i5.ProductsMaterialsHomePage]
class ProductsMaterialsHomeRoute extends _i11.PageRouteInfo<void> {
  const ProductsMaterialsHomeRoute({List<_i11.PageRouteInfo>? children})
    : super(ProductsMaterialsHomeRoute.name, initialChildren: children);

  static const String name = 'ProductsMaterialsHomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.ProductsMaterialsHomePage();
    },
  );
}

/// generated route for
/// [_i6.ProfilePage]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute({List<_i11.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.ProfilePage();
    },
  );
}

/// generated route for
/// [_i7.SettingPage]
class SettingRoute extends _i11.PageRouteInfo<void> {
  const SettingRoute({List<_i11.PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.SettingPage();
    },
  );
}

/// generated route for
/// [_i8.WorkOrderDetailPage]
class WorkOrderDetailRoute
    extends _i11.PageRouteInfo<WorkOrderDetailRouteArgs> {
  WorkOrderDetailRoute({
    _i12.Key? key,
    required _i13.WorkOrderEntity order,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         WorkOrderDetailRoute.name,
         args: WorkOrderDetailRouteArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'WorkOrderDetailRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WorkOrderDetailRouteArgs>();
      return _i8.WorkOrderDetailPage(key: args.key, order: args.order);
    },
  );
}

class WorkOrderDetailRouteArgs {
  const WorkOrderDetailRouteArgs({this.key, required this.order});

  final _i12.Key? key;

  final _i13.WorkOrderEntity order;

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
/// [_i9.WorkOrdersHomePage]
class WorkOrdersHomeRoute extends _i11.PageRouteInfo<void> {
  const WorkOrdersHomeRoute({List<_i11.PageRouteInfo>? children})
    : super(WorkOrdersHomeRoute.name, initialChildren: children);

  static const String name = 'WorkOrdersHomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.WorkOrdersHomePage();
    },
  );
}

/// generated route for
/// [_i10.WorkersHomePage]
class WorkersHomeRoute extends _i11.PageRouteInfo<void> {
  const WorkersHomeRoute({List<_i11.PageRouteInfo>? children})
    : super(WorkersHomeRoute.name, initialChildren: children);

  static const String name = 'WorkersHomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.WorkersHomePage();
    },
  );
}
