// features/work-orders/presentation/widgets/loading_work_orders.dart

import 'package:flutter/material.dart';

class LoadingWorkOrders extends StatelessWidget {
  const LoadingWorkOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6, // número de skeletons
      itemBuilder: (context, index) {
        return const Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey),
            title: _GreyPlaceholder(height: 16, width: 200),
            subtitle: _GreyPlaceholder(height: 14, width: 150),
            trailing: Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}

class _GreyPlaceholder extends StatelessWidget {
  final double height;
  final double width;

  const _GreyPlaceholder({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
