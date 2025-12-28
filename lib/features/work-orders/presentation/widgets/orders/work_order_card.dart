// features/work-orders/presentation/widgets/work_order_card.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/change_status_dialog.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/components/button/widget_button.dart';
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

  Color _getPriorityColor(int priorityId) {
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

  // Estado
  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Pendiente';
      case 2:
        return 'Asignada';
      case 3:
        return 'Reasignada';
      case 4:
        return 'En Progreso';
      case 5:
        return 'En Espera';
      case 6:
        return 'Reanudada';
      case 7:
        return 'Completada';
      case 8:
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
      case 2:
      case 3:
        return Colors.orange;
      case 4:
      case 5:
      case 6:
        return Colors.blue;
      case 7:
        return Colors.green;
      case 8:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Tipo de trabajo + Icono personalizado
  String _getWorkTypeText(int workTypeId) {
    switch (workTypeId) {
      case 1:
        return 'ALCANTARILLADO';
      case 2:
        return 'AGUA POTABLE';
      case 3:
        return 'COMERCIALIZACION';
      case 4:
        return 'MANTENIMIENTO';
      case 5:
        return 'LABORATORIO';
      default:
        return 'DESCONOCIDO';
    }
  }

  IconData _getWorkTypeIcon(int workTypeId) {
    switch (workTypeId) {
      case 1:
        return Icons.plumbing; // Alcantarillado
      case 2:
        return Icons.water_drop; // Agua potable
      case 3:
        return Icons.store; // Comercialización
      case 4:
        return Icons.build; // Mantenimiento
      case 5:
        return Icons.science; // Laboratorio
      default:
        return Icons.work;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUrgent = _isUrgent(order.priorityId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: Número de orden + Tipo de trabajo + Estado/Prioridad
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OT Nº: ${order.orderCode}',
                        style: TextStyle(
                          fontSize: context.isMobileSmall ? 12 : 14,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getWorkTypeIcon(order.workTypeId),
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getWorkTypeText(order.workTypeId),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
                    ),
                    const SizedBox(height: 4),
                    _PriorityChip(
                      text: _getPriorityText(order.priorityId),
                      color: _getPriorityColor(order.priorityId),
                      isUrgent: isUrgent,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Descripción
            Text(
              order.description,
              style: TextStyle(fontSize: context.isMobileSmall ? 11 : 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // Fecha
            Row(
              children: [
                const Spacer(),
                Text(
                  'F. de creación: ${order.creationDate!.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            // Clave + Botones
            Row(
              children: [
                Icon(AppIcons.connection, size: 14, color: Colors.lightBlue),
                const SizedBox(width: 4),
                Row(
                  children: [
                    Text(
                      'C.C:',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      order.cadastralKey,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Botones de acción
                // Location, Editar, Eliminar, Más opciones
                IconButton(
                  onPressed: () => {
                    context.router.push(WorkOrderMapRoute(order: order)),
                  },
                  icon: const Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 14),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 14, color: Colors.red),
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  style: IconButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  offset: const Offset(
                    0,
                    40,
                  ), // Para que aparezca debajo del botón
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'details',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 14),
                          SizedBox(width: 8),
                          Text("Ver detalles", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'status',
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Cambiar estado",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text("Editar orden", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    // Puedes agregar más opciones aquí, por ejemplo:
                    // const PopupMenuItem(
                    //   value: 'cancel',
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.cancel, size: 18, color: Colors.red),
                    //       SizedBox(width: 8),
                    //       Text("Cancelar orden", style: TextStyle(fontSize: 13, color: Colors.red)),
                    //     ],
                    //   ),
                    // ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'details':
                        context.router.push(
                          WorkOrderDetailRoute(
                            order: order,
                          ), // ← Así sí funciona
                        );
                        break;
                      case 'status':
                        showDialog(
                          context: context,
                          builder: (_) => ChangeStatusDialog(order: order),
                        );
                        break;
                      case 'edit':
                        // Navegar a editar orden
                        if (onEdit != null) {
                          onEdit!();
                        }
                        break;
                      // case 'cancel':
                      //   _confirmCancelOrder(order);
                      //   break;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Chip personalizado con transparencia
class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        // Fondo muy suave/transparente
        color: color.withOpacity(
          0.1,
        ), // Muy tenue, puedes subir a 0.15 si quieres un poco más visible
        borderRadius: BorderRadius.circular(12),
        // Borde intenso con el color completo
        border: Border.all(
          color: color,
          width: 1.5, // Grosor visible pero elegante
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool isUrgent;

  const _PriorityChip({
    super.key,
    required this.text,
    required this.color,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        // Fondo muy suave/transparente
        color: color.withOpacity(
          isUrgent ? 0.2 : 0.1,
        ), // Ajusta 0.1 y 0.2 según prefieras
        borderRadius: BorderRadius.circular(20),
        // Borde intenso con el color completo
        border: Border.all(
          color: color,
          width: isUrgent
              ? 2.0
              : 1.5, // Puedes hacer el borde más grueso en urgente
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUrgent) ...[
            Icon(Icons.warning, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
