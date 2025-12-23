// lib/features/work-orders/presentation/pages/work_order_detail_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WorkOrderDetailPage extends StatelessWidget {
  final WorkOrderEntity order;

  const WorkOrderDetailPage({super.key, required this.order});

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
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final assignedWorkers = [];
    final selectedMaterials = [];
    final totalMaterials = selectedMaterials.fold<double>(
      0.0,
      (sum, m) => sum + (m['totalCost'] ?? 0.0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de Orden #: ${order.orderCode}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: context.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal con información general
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OT Nº: ${order.orderCode}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              order.status,
                            ).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getStatusColor(order.status),
                            ),
                          ),
                          child: Text(
                            _getStatusText(order.status),
                            style: TextStyle(
                              color: _getStatusColor(order.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.work, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _getWorkTypeText(order.workTypeId),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.flag,
                          color: _getPriorityColor(order.priorityId),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getPriorityText(order.priorityId),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getPriorityColor(order.priorityId),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Descripción:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.description,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "Creada: ${order.creationDate?.toLocal().toString().split(' ')[0] ?? '—'}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Cliente y conexión
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cliente y Conexión",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Cliente ID: ${order.clientId}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.vpn_key, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Clave Catastral: ${order.cadastralKey}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Dirección: ${order.location}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Trabajadores asignados
            if (assignedWorkers.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Trabajadores Asignados",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...assignedWorkers.map((w) {
                        final isSupervisor = w['isSupervisor'] == true;
                        final isTechnician = w['isTechnician'] == true;
                        final role = isSupervisor
                            ? "Supervisor"
                            : isTechnician
                            ? "Técnico"
                            : "Ayudante";
                        final color = isSupervisor
                            ? Colors.orange
                            : isTechnician
                            ? Colors.teal
                            : Colors.blue;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: color.withOpacity(0.8),
                                child: Text(
                                  w['fullName'][0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      w['fullName'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      "$role • C.I.: ${w['identification']}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Materiales usados
            if (selectedMaterials.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Materiales Utilizados",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...selectedMaterials.map((m) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.inventory_2, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${m['itemName']} (${m['quantity']} ${m['unitOfMeasure']})",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                "\$${m['totalCost'].toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Total estimado: ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${totalMaterials.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
