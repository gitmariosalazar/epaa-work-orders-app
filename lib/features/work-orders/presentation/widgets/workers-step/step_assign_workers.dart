// lib/features/work-orders/presentation/widgets/step_assign_workers.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';

import 'package:clean_architecture/features/work-orders/presentation/widgets/workers-step/worker_search_dialog.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:flutter/material.dart';

class StepAssignWorkers extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) updateData;

  const StepAssignWorkers({
    super.key,
    required this.formData,
    required this.updateData,
  });

  @override
  State<StepAssignWorkers> createState() => _StepAssignWorkersState();
}

class _StepAssignWorkersState extends State<StepAssignWorkers> {
  @override
  Widget build(BuildContext context) {
    final assignedWorkers = List<Map<String, dynamic>>.from(
      widget.formData['assignedWorkers'] ?? [],
    );

    final supervisor = assignedWorkers.firstWhere(
      (w) => w['isSupervisor'] == true,
      orElse: () => {},
    );

    return SingleChildScrollView(
      padding: context.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trabajadores asignados",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _openAddWorkerDialog,
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text(
                    "Agregar",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (supervisor.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.orange),
                  title: Text(
                    supervisor['fullName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Supervisor asignado"),
                ),
              ),
            ),

          if (assignedWorkers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "No hay trabajadores asignados aún",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 32,
                      ),
                      child: DataTable(
                        headingRowColor: MaterialStatePropertyAll(
                          AppColors.primary.withOpacity(0.12),
                        ),
                        columnSpacing: 16,
                        dataRowHeight: 40,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Nombre',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Cédula',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Teléfono',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Rol',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Opción',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                        rows: assignedWorkers.map((w) {
                          final isSupervisor = w['isSupervisor'] == true;
                          final isTechnician = w['isTechnician'] == true;

                          Color badgeColor;
                          String roleText;
                          if (isSupervisor) {
                            badgeColor = Colors.orange;
                            roleText = "Supervisor";
                          } else if (isTechnician) {
                            badgeColor = Colors.teal;
                            roleText = "Técnico";
                          } else {
                            badgeColor = Colors.blue;
                            roleText = "Normal";
                          }

                          return DataRow(
                            color: MaterialStatePropertyAll(
                              isSupervisor
                                  ? Colors.orange.shade50
                                  : isTechnician
                                  ? Colors.teal.shade50
                                  : null,
                            ),
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: badgeColor.withOpacity(
                                        0.8,
                                      ),
                                      child: Text(
                                        w['fullName'][0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        w['fullName'],
                                        style: const TextStyle(fontSize: 10),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  w['identification'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  w['phone'].isEmpty ? "—" : w['phone'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    roleText,
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      assignedWorkers.remove(w);
                                      widget.updateData(
                                        'assignedWorkers',
                                        assignedWorkers,
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (assignedWorkers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Debe asignar al menos un trabajador",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _openAddWorkerDialog() async {
    // ← Convertimos la lista actual a WorkerWithRole para pasarla al diálogo
    final List<WorkerWithRole> currentAssigned =
        (widget.formData['assignedWorkers'] ?? [])
            .map<WorkerWithRole>(
              (w) => WorkerWithRole(
                worker: WorkerEntity(
                  workerId: w['workerId'],
                  firstNames: w['fullName'].split(' ').first,
                  lastNames: w['fullName'].split(' ').skip(1).join(' '),
                  identification: w['identification'],
                  phoneNumber: w['phone'],
                  cellPhone: w['phone'] ?? '',
                  email: '',
                  address: '',
                ),
                isTechnician: w['isTechnician'] ?? false,
                isSupervisor: w['isSupervisor'] ?? false,
              ),
            )
            .toList();

    final result = await showDialog<WorkerWithRole>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WorkerSearchDialog(
        alreadyAssignedWorkers: currentAssigned, // ← PASAMOS LA LISTA AQUÍ
      ),
    );

    if (result != null && mounted) {
      final list = List<Map<String, dynamic>>.from(
        widget.formData['assignedWorkers'] ?? [],
      );

      if (list.any((e) => e['workerId'] == result.worker.workerId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Este trabajador ya está asignado"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (result.isSupervisor && list.any((e) => e['isSupervisor'] == true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ya existe un supervisor asignado"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      list.add({
        "workerId": result.worker.workerId,
        "identification": result.worker.identification,
        "fullName": result.worker.firstNames! + ' ' + result.worker.lastNames!,
        "phone": result.worker.phoneNumber ?? '',
        "isTechnician": result.isTechnician,
        "isSupervisor": result.isSupervisor,
      });

      widget.updateData('assignedWorkers', list);
    }
  }
}

class WorkerWithRole {
  final WorkerEntity worker;
  final bool isTechnician;
  final bool isSupervisor;

  WorkerWithRole({
    required this.worker,
    required this.isTechnician,
    required this.isSupervisor,
  });
}
