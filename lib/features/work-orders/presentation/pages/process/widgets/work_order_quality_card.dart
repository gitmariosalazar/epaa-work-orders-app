import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:flutter/material.dart';

class WorkOrderQualityCard extends StatelessWidget {
  final WorkOrderDetailEntity order;
  final VoidCallback? onRegisterQuality;

  const WorkOrderQualityCard({
    super.key,
    required this.order,
    this.onRegisterQuality,
  });

  @override
  Widget build(BuildContext context) {
    final qc = order.controlCalidad;
    final hasQc = qc != null;
    final isApproved = qc?.aprobado ?? false;

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
                      Icons.shield_outlined,
                      color: hasQc
                          ? (isApproved
                                ? Colors.green.shade700
                                : Colors.red.shade700)
                          : Colors.purple.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Control de Calidad',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (hasQc)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isApproved
                            ? Colors.green.shade400
                            : Colors.red.shade400,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isApproved ? Icons.check_circle : Icons.cancel,
                          size: 13,
                          color: isApproved
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isApproved ? 'Aprobado' : 'Rechazado',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isApproved
                                ? Colors.green.shade900
                                : Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (onRegisterQuality != null &&
                    order.estado == 'COMPLETADA')
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
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
                    onPressed: onRegisterQuality,
                    icon: const Icon(
                      Icons.verified_user_outlined,
                      size: 13,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Auditar',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const Divider(height: 16),
            if (!hasQc)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Text(
                  'El control de calidad no ha sido registrado aún.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else ...[
              if (qc.auditor != null && qc.auditor!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Text(
                        'Auditor: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(qc.auditor!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              if (qc.fechaControl != null && qc.fechaControl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Text(
                        'Fecha de Inspección: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        qc.fechaControl!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              if (qc.comentarios != null && qc.comentarios!.isNotEmpty) ...[
                const SizedBox(height: 6),
                const Text(
                  'Observaciones / Dictamen:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    qc.comentarios!,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
