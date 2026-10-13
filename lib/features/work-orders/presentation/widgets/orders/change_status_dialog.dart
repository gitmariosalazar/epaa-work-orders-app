import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:clean_architecture/core/constants/work_order_status.dart';
// lib/features/work-orders/presentation/widgets/change_status_dialog.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:flutter/material.dart';

class ChangeStatusDialog extends StatefulWidget {
  final WorkOrderEntity order;

  const ChangeStatusDialog({super.key, required this.order});

  @override
  State<ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends State<ChangeStatusDialog> {
  late final String _current = WorkOrderStatus.normalize(widget.order.status);
  late String? selectedStatus = _current;

  /// Estados del flujo de la OT + Cancelada (catálogo único).
  late final List<Map<String, dynamic>> statuses = [
    for (final code in [
      ...WorkOrderStatus.flowOf(_current),
      WorkOrderStatus.cancelada,
    ])
      {
        'id': code,
        'name': WorkOrderStatus.labelOf(code),
        'color': MapUtils.getStatusColor(code),
      },
  ];

  String _getStatusText(String status) => WorkOrderStatus.labelOf(status);

  // Solo permite el siguiente estado o Cancelada (si no es final)
  bool _isStatusAllowed(String statusId) {
    if (WorkOrderStatus.isFinal(_current)) return false;
    return statusId == WorkOrderStatus.nextOf(_current) ||
        statusId == WorkOrderStatus.cancelada;
  }

  bool _isPreviousStatus(String statusId) {
    final flow = WorkOrderStatus.flowOf(_current);
    final i = flow.indexOf(statusId);
    final c = flow.indexOf(_current);
    return i >= 0 && c >= 0 && i < c;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasChanged =
        selectedStatus != _current && selectedStatus != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          const Text(
            "Cambiar Estado",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: double.maxFinite,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Orden #${widget.order.orderCode}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.order.description,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Seleccione el nuevo estado:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              ...statuses.map((status) {
                final String id = status['id'] as String;
                final isSelected = selectedStatus == id;
                final isAllowed = _isStatusAllowed(id);
                final isPrevious = _isPreviousStatus(id);
                final Color statusColor = status['color'] as Color;

                if (isPrevious) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: Colors.grey, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            status['name'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            "(Anterior)",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isAllowed
                        ? () {
                            setState(() {
                              selectedStatus = id;
                            });
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? statusColor.withOpacity(0.15)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? statusColor
                              : (isAllowed
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade400),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Opacity(
                        opacity: isAllowed ? 1.0 : 0.5,
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: statusColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              status['name'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? statusColor
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(fontSize: 14)),
        ),
        ElevatedButton.icon(
          onPressed: hasChanged
              ? () async {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Estado cambiado a: ${_getStatusText(selectedStatus!)}",
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );

                  // NO llamamos al Cubit aquí — la página principal recargará automáticamente al volver o cuando lo necesite
                }
              : null,
          icon: const Icon(Icons.check, size: 18),
          label: const Text("Confirmar", style: TextStyle(fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
