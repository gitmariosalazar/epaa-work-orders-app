// lib/features/work-orders/presentation/widgets/orders/work_order_detail_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/process/work_order_process_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WorkOrderDetailPage extends StatelessWidget {
  final WorkOrderEntity order;

  const WorkOrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return WorkOrderProcessPage(initialOrderCode: order.orderCode);
  }
}
