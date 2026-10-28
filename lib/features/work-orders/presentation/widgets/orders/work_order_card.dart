// features/work-orders/presentation/widgets/orders/work_order_card.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/change_status_dialog.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:flutter/material.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrderEntity order;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WorkOrderCard({
    super.key,
    required this.order,
    this.onEdit,
    this.onDelete,
  });

  // Prioridad
  String _getPriorityText(int priorityId) {
    switch (priorityId) {
      case 1:
        return 'Baja';
      case 2:
        return 'Media';
      case 3:
        return 'Alta';
      case 4:
        return 'Urgente';
      case 5:
        return 'Emergencia';
      default:
        return 'Desconocida';
    }
  }

  Color _getPriorityColor(int priorityId, {required bool isDark}) {
    if (isDark) {
      switch (priorityId) {
        case 1:
          return const Color(0xFF81C784); // Verde claro
        case 2:
          return const Color(0xFFAED581); // Verde lima suave
        case 3:
          return const Color(0xFFFFB74D); // Naranja brillante
        case 4:
          return const Color(0xFFEF5350); // Rojo brillante
        case 5:
          return const Color(0xFFFF6E6E); // Rojo coral luminoso
        default:
          return const Color(0xFFB0BEC5); // Gris azulado
      }
    }

    switch (priorityId) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.red[900]!;
      default:
        return Colors.grey;
    }
  }

  bool _isUrgent(int priorityId) => priorityId >= 4;

  // Estado (catálogo único: WorkOrderStatus / MapUtils)
  String _getStatusText(String status) => MapUtils.getStatusText(status);

  Color _getStatusColor(String status) => MapUtils.getStatusColor(status);

  // Tipo de trabajo + Icono personalizado
  String _getDepartmentText(int departmentId) =>
      MapUtils.getDepartmentText(departmentId);

  IconData _getDepartmentIcon(int departmentId) =>
      MapUtils.getDepartmentIcon(departmentId);

  Color _getDepartmentColor(int departmentId) =>
      MapUtils.getDepartmentColor(departmentId);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isUrgent = _isUrgent(order.priorityId);

    final cardBackgroundColor = isDark
        ? colorScheme.surfaceContainerHighest
        : colorScheme.surface;

    final cardBorderColor = isDark
        ? colorScheme.outlineVariant
        : colorScheme.outlineVariant.withValues(alpha: 0.35);

    final connectionIconColor = isDark
        ? const Color(0xFF64B5F6)
        : Colors.lightBlue;

    final locationButtonColor = isDark ? const Color(0xFF81C784) : Colors.green;
    final printButtonColor = isDark ? const Color(0xFF64B5F6) : Colors.blue;

    final dateString = order.creationDate != null
        ? order.creationDate!.toLocal().toString().split(' ')[0]
        : 'N/A';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      color: cardBackgroundColor,
      elevation: isDark ? 0 : 2,
      shadowColor: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: cardBorderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          context.router.push(WorkOrderDetailRoute(order: order));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OT Nº: ${order.orderCode ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: context.isMobileSmall ? 12 : 14,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              _getDepartmentIcon(order.departmentId ?? 0),
                              size: 16,
                              color: _getDepartmentColor(
                                order.departmentId ?? 0,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getDepartmentText(order.departmentId ?? 0),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? colorScheme.onSurfaceVariant
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Estado y prioridad siempre visibles, con transparencia
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _StatusChip(
                        text: _getStatusText(order.status),
                        color: _getStatusColor(order.status),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 4),
                      _PriorityChip(
                        text: _getPriorityText(order.priorityId),
                        color: _getPriorityColor(
                          order.priorityId,
                          isDark: isDark,
                        ),
                        isUrgent: isUrgent,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Descripción
              Text(
                order.description,
                style: TextStyle(
                  fontSize: context.isMobileSmall ? 11 : 13,
                  color: isDark
                      ? colorScheme.onSurface.withValues(alpha: 0.9)
                      : AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              // Fecha
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'F. de creación: $dateString',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? colorScheme.onSurfaceVariant
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // Clave + Botones
              Row(
                children: [
                  Icon(
                    AppIcons.connection,
                    size: 14,
                    color: connectionIconColor,
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      Text(
                        'C.C:',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? colorScheme.onSurfaceVariant
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.cadastralKey,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? colorScheme.onSurface
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Botones de acción
                  IconButton(
                    onPressed: () {
                      context.router.push(WorkOrderMapRoute(order: order));
                    },
                    icon: Icon(
                      Icons.location_on,
                      size: 14,
                      color: locationButtonColor,
                    ),
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      side: BorderSide(color: locationButtonColor),
                    ),
                    tooltip: 'Ver en el mapa',
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(Icons.print, size: 14, color: printButtonColor),
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      side: BorderSide(color: printButtonColor),
                    ),
                    tooltip: 'Imprimir orden',
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDark
                          ? colorScheme.onSurfaceVariant
                          : AppColors.fade,
                    ),
                    color: isDark
                        ? colorScheme.surfaceContainerHighest
                        : colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark
                            ? colorScheme.outlineVariant
                            : colorScheme.outlineVariant.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    offset: const Offset(0, 40),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'manage',
                        child: Row(
                          children: [
                            Icon(
                              Icons.timeline_rounded,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Gestionar proceso",
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? colorScheme.onSurface
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_rounded,
                              size: 18,
                              color: isDark
                                  ? colorScheme.onSurfaceVariant
                                  : AppColors.fade,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Ver detalles",
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? colorScheme.onSurface
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'print',
                        child: Row(
                          children: [
                            Icon(
                              Icons.print,
                              size: 18,
                              color: isDark
                                  ? colorScheme.onSurfaceVariant
                                  : AppColors.fade,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Imprimir orden",
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? colorScheme.onSurface
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'manage':
                        case 'details':
                          context.router.push(
                            WorkOrderDetailRoute(order: order),
                          );
                          break;
                        case 'print':
                          if (onEdit != null) {
                            onEdit!();
                          }
                          break;
                        case 'status':
                          showDialog(
                            context: context,
                            builder: (_) => ChangeStatusDialog(order: order),
                          );
                          break;
                        case 'edit':
                          if (onEdit != null) {
                            onEdit!();
                          }
                          break;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Chip personalizado con transparencia adaptativa
class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool isDark;

  const _StatusChip({
    required this.text,
    required this.color,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.22 : 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.85 : 1.0),
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: isDark
              ? Color.lerp(color, Colors.white, 0.15) ?? color
              : color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool isUrgent;
  final bool isDark;

  const _PriorityChip({
    required this.text,
    required this.color,
    required this.isUrgent,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: isDark ? (isUrgent ? 0.30 : 0.18) : (isUrgent ? 0.20 : 0.10),
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.85 : 1.0),
          width: isUrgent ? 2.0 : 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUrgent) ...[
            Icon(Icons.warning_amber_rounded, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              color: isDark
                  ? Color.lerp(color, Colors.white, 0.15) ?? color
                  : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
