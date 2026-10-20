import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_tracking_entity.dart';
import 'package:flutter/material.dart';

class WorkOrderTimelineCard extends StatelessWidget {
  final WorkOrderTrackingEntity? tracking;

  const WorkOrderTimelineCard({super.key, this.tracking});

  @override
  Widget build(BuildContext context) {
    final milestones = tracking?.historial ?? [];
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
              children: [
                Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Historial de Trazabilidad y Auditoría',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 16),
            if (milestones.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Text(
                  'No hay eventos de trazabilidad registrados.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? cs.onSurfaceVariant : Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: milestones.length,
                itemBuilder: (context, index) {
                  final m = milestones[index];
                  final isLast = index == milestones.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? AppColors.primary
                                  : (isDark
                                      ? cs.outlineVariant
                                      : Colors.grey.shade400),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? cs.surface : Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.3 : 0.1,
                                  ),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 48,
                              color: isDark
                                  ? theme.dividerColor.withValues(alpha: 0.3)
                                  : Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    m.estado.replaceAll('_', ' '),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                      color: index == 0
                                          ? AppColors.primary
                                          : cs.onSurface,
                                    ),
                                  ),
                                  Text(
                                    m.fecha.split('T').first,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? cs.onSurfaceVariant
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              if (m.usuario != null &&
                                  m.usuario!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Por: ${m.usuario}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? cs.onSurfaceVariant
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                              if (m.comentario != null &&
                                  m.comentario!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  m.comentario!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? cs.onSurface
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
