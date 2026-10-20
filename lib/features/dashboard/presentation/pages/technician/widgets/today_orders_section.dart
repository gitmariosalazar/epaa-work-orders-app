// features/dashboard/presentation/pages/technician/widgets/today_orders_section.dart

import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:flutter/material.dart';

class TodayOrdersSection extends StatelessWidget {
  final List<WorkOrderEntity> orders;
  final VoidCallback? onViewAllTap;
  final ValueChanged<WorkOrderEntity>? onOrderTap;

  const TodayOrdersSection({
    super.key,
    required this.orders,
    this.onViewAllTap,
    this.onOrderTap,
  });

  IconData _getOrderIcon(String status) {
    final st = status.trim().toUpperCase();
    if (st.contains('PROCESO') || st == 'ASIGNADA') {
      return Icons.play_arrow_rounded;
    }
    if (st.contains('COMPLETADA') || st.contains('EJECUTADA')) {
      return Icons.check_circle_outline_rounded;
    }
    return Icons.hourglass_top_rounded;
  }

  Color _getOrderIconColor(String status, {required bool isDark}) {
    final st = status.trim().toUpperCase();
    if (st.contains('PROCESO')) {
      return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    }
    if (st.contains('COMPLETADA')) {
      return isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
    }
    return isDark ? const Color(0xFFFFB74D) : const Color(0xFFD97706);
  }

  String _getOrderDescription(WorkOrderEntity order) {
    if (order.description.trim().isNotEmpty) {
      return order.description.trim();
    }
    return MapUtils.getWorkTypeText(order.workTypeId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final countText = orders.isNotEmpty ? ' (${orders.length})' : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ÓRDENES DE HOY$countText',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: cs.onSurfaceVariant,
              ),
            ),
            if (onViewAllTap != null)
              TextButton(
                onPressed: onViewAllTap,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Ver todas',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHighest : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: orders.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No hay órdenes registradas para hoy',
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDark ? cs.outlineVariant : const Color(0xFFF1F5F9),
                  ),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final orderCode = order.orderCode?.trim().isNotEmpty == true
                        ? order.orderCode!.trim()
                        : (order.workOrderId ?? 'OT-${index + 1}');
                    final description = _getOrderDescription(order);
                    final icon = _getOrderIcon(order.status);
                    final iconColor = _getOrderIconColor(
                      order.status,
                      isDark: isDark,
                    );

                    return InkWell(
                      onTap: onOrderTap != null
                          ? () => onOrderTap!(order)
                          : null,
                      borderRadius: index == 0
                          ? const BorderRadius.vertical(
                              top: Radius.circular(16),
                            )
                          : (index == orders.length - 1
                                ? const BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  )
                                : BorderRadius.zero),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: iconColor.withValues(
                                  alpha: isDark ? 0.22 : 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(icon, size: 16, color: iconColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: orderCode,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  •  ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                    TextSpan(
                                      text: description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 18,
                              color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
