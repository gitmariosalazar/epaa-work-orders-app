import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/data/models/requests/process_work_order_requests.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/workers-step/step_assign_workers.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/workers-step/worker_search_dialog.dart';
import 'package:flutter/material.dart';

class WorkOrderWorkersCard extends StatelessWidget {
  final WorkOrderDetailEntity order;
  final Function(List<AddWorkerToWorkOrderRequest> workers) onAddWorkers;
  final Function(String workerId) onRemoveWorker;

  const WorkOrderWorkersCard({
    super.key,
    required this.order,
    required this.onAddWorkers,
    required this.onRemoveWorker,
  });

  bool get _isEditable {
    final status = order.estado.toUpperCase();
    return [
      'PENDIENTE',
      'ASIGNADA',
      'PREPARACION',
      'EN_PROCESO',
      'EN_PROCESO_INSPECCION',
      'EN_PROCESO_INSTALACION',
    ].contains(status);
  }

  Future<void> _openAddWorker(BuildContext context) async {
    final result = await showDialog<WorkerWithRole>(
      context: context,
      builder: (context) => const WorkerSearchDialog(),
    );

    if (result != null) {
      final req = AddWorkerToWorkOrderRequest(
        workerId: result.worker.workerId,
        isResponsible: result.isSupervisor,
        roleId: result.isSupervisor ? 1 : 2,
      );
      onAddWorkers([req]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workers = order.trabajadoresAsignados;

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
                Row(
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Personal en Campo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (_isEditable)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _openAddWorker(context),
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      size: 14,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Agregar',
                      style: TextStyle(fontSize: 11.5, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const Divider(height: 16),
            if (workers.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      color: Colors.grey.shade400,
                      size: 36,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No hay personal asignado a esta orden.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workers.length,
                separatorBuilder: (context, index) => const Divider(height: 12),
                itemBuilder: (context, index) {
                  final w = workers[index];
                  final isLead = w.esResponsable || (w.idRolTrabajador == 1);

                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isLead
                              ? Colors.amber.shade50
                              : Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLead
                              ? Icons.star_rounded
                              : Icons.engineering_outlined,
                          color: isLead
                              ? Colors.amber.shade800
                              : Colors.blue.shade700,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w.nombreCompleto.isNotEmpty
                                  ? w.nombreCompleto
                                  : 'Trabajador ID: ${w.idTrabajador}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLead
                                        ? Colors.amber.shade100
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isLead
                                        ? 'Técnico Responsable'
                                        : (w.nombreRol ?? 'Personal de Apoyo'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isLead
                                          ? Colors.amber.shade900
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (_isEditable)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          tooltip: 'Remover trabajador',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text(
                                  'Confirmar Remoción',
                                  style: TextStyle(fontSize: 15),
                                ),
                                content: Text(
                                  '¿Desea remover a ${w.nombreCompleto} de la orden?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      onRemoveWorker(w.idTrabajador);
                                    },
                                    child: const Text(
                                      'Remover',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
