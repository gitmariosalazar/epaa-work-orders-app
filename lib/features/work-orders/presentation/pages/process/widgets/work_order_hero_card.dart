import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class WorkOrderHeroCard extends StatelessWidget {
  final WorkOrderDetailEntity order;

  const WorkOrderHeroCard({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NOTIFICADA':
        return const Color(0xFF2563EB);
      case 'PENDIENTE':
        return const Color(0xFFF59E0B);
      case 'ASIGNADA':
        return const Color(0xFF0D9488);
      case 'PREPARACION':
        return const Color(0xFFD97706);
      case 'REVISION_RECHAZADA':
        return const Color(0xFFDC2626);
      case 'EN_PROCESO':
      case 'EN_PROCESO_INSPECCION':
      case 'EN_PROCESO_INSTALACION':
        return const Color(0xFF0284C7);
      case 'EJECUTADA':
      case 'INSPECCION_EJECUTADA':
      case 'INSTALACION_EJECUTADA':
        return const Color(0xFF7C3AED);
      case 'COMPLETADA':
      case 'INSPECCION_COMPLETADA':
      case 'INSTALACION_COMPLETADA':
        return const Color(0xFF059669);
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'BAJA':
        return Colors.green.shade600;
      case 'MEDIA':
        return Colors.blue.shade600;
      case 'ALTA':
        return Colors.orange.shade700;
      case 'URGENTE':
      case 'EMERGENCIA':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = _getStatusColor(order.estado);
    final priorityColor = _getPriorityColor(order.prioridad);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.2 : 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.assignment_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          order.codigoOrden,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: isDark ? theme.colorScheme.onSurfaceVariant : Colors.grey,
                        ),
                        tooltip: 'Copiar código',
                        onPressed: () {
                          FlutterClipboard.copy(order.codigoOrden);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Código copiado al portapapeles'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: isDark ? 0.5 : 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.estado.replaceAll('_', ' '),
                        style: TextStyle(
                          color: isDark && statusColor == const Color(0xFF2563EB)
                              ? Colors.blue.shade300
                              : statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  context,
                  icon: Icons.priority_high_rounded,
                  label: 'Prioridad: ${order.prioridad}',
                  color: priorityColor,
                ),
                _buildInfoChip(
                  context,
                  icon: Icons.category_outlined,
                  label: order.tipoTrabajo,
                  color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey,
                ),
                if (order.idEntidadOrigen != null &&
                    order.idEntidadOrigen!.isNotEmpty)
                  _buildInfoChip(
                    context,
                    icon: Icons.link_rounded,
                    label:
                        'Origen: ${order.tipoOrigen ?? 'Solicitud'} # ${order.codigoEntidadOrigen}',
                    color: isDark ? Colors.indigo.shade200 : Colors.indigo,
                  ),
                if (order.fechaCreacion.isNotEmpty)
                  _buildInfoChip(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: order.fechaCreacion.split('T').first,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
