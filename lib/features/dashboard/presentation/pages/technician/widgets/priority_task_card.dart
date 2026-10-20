// features/dashboard/presentation/pages/technician/widgets/priority_task_card.dart

import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:flutter/material.dart';

class PriorityTaskCard extends StatelessWidget {
  final WorkOrderEntity? order;
  final ValueChanged<WorkOrderEntity>? onContinueOrder;
  final ValueChanged<WorkOrderEntity>? onViewMap;
  final VoidCallback? onEmptyAction;

  const PriorityTaskCard({
    super.key,
    required this.order,
    this.onContinueOrder,
    this.onViewMap,
    this.onEmptyAction,
  });

  String _getStatusText(String status) {
    final normalized = status.replaceAll('_', ' ').trim();
    if (normalized.toUpperCase().contains('PROCESO')) {
      return 'EN PROCESO';
    }
    return MapUtils.getStatusText(status);
  }

  Color _getStatusColor(String status, {required bool isDark}) {
    final st = status.trim().toUpperCase();
    if (st.contains('PROCESO')) {
      return isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    }
    if (st.contains('PENDIENTE')) {
      return isDark ? const Color(0xFFFFB74D) : const Color(0xFFD97706);
    }
    if (st.contains('COMPLETADA')) {
      return isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
    }
    return MapUtils.getStatusColor(status);
  }

  String _getTitle(WorkOrderEntity currentOrder) {
    if (currentOrder.description.trim().isNotEmpty) {
      return currentOrder.description.trim();
    }
    return MapUtils.getWorkTypeText(currentOrder.workTypeId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TAREA PRIORITARIA / EN CURSO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (order == null)
          _buildEmptyState(context, isDark, cs)
        else
          _buildOrderCard(context, order!, isDark, cs),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isDark,
    ColorScheme cs,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 40,
            color: cs.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 10),
          Text(
            'No tienes tareas en curso en este momento',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona una orden de trabajo de tu lista para iniciar labores.',
            style: TextStyle(
              fontSize: 12,
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (onEmptyAction != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onEmptyAction,
              icon: const Icon(Icons.list_alt_rounded, size: 16),
              label: const Text('Ver Órdenes Asignadas'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    WorkOrderEntity currentOrder,
    bool isDark,
    ColorScheme cs,
  ) {
    final statusColor = _getStatusColor(currentOrder.status, isDark: isDark);
    final statusLabel = _getStatusText(currentOrder.status);
    final orderCode =
        currentOrder.orderCode?.trim().isNotEmpty == true
            ? currentOrder.orderCode!.trim()
            : (currentOrder.workOrderId ?? 'OT-2026-90');
    final formattedCode =
        orderCode.startsWith('#') ? orderCode : '#$orderCode';
    final title = _getTitle(currentOrder);

    final sector = currentOrder.location.isNotEmpty
        ? currentOrder.location
        : 'Sector 5';
    final key = currentOrder.cadastralKey.isNotEmpty
        ? currentOrder.cadastralKey
        : '5-102';
    final locationText = '$sector - Clave: $key';

    final subscriber = currentOrder.clientId.isNotEmpty
        ? currentOrder.clientId
        : 'Carlos Andrade';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? cs.outlineVariant
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: Badge de estado y código
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: isDark ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withValues(alpha: isDark ? 0.6 : 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formattedCode,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Título de la tarea
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Ubicación
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 16,
                color: cs.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  locationText,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Abonado
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: 16,
                color: cs.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Abonado: $subscriber',
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onContinueOrder != null
                      ? () => onContinueOrder!(currentOrder)
                      : null,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                  ),
                  label: const Text(
                    'Continuar Orden',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewMap != null
                      ? () => onViewMap!(currentOrder)
                      : null,
                  icon: const Icon(
                    Icons.map_outlined,
                    size: 16,
                  ),
                  label: const Text(
                    'Ver Mapa',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.onSurface,
                    side: BorderSide(
                      color: isDark ? cs.outlineVariant : const Color(0xFFCBD5E1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
