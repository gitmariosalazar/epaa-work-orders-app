import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StepItemData {
  final String label;
  final IconData icon;

  const StepItemData(this.label, this.icon);
}

class WorkOrderProcessStepper extends StatelessWidget {
  final String status;
  final int executionSubStep;

  const WorkOrderProcessStepper({
    super.key,
    required this.status,
    required this.executionSubStep,
  });

  static const List<StepItemData> steps = [
    StepItemData('Recepción', Icons.inbox_outlined),
    StepItemData('Asignación', Icons.person_outline),
    StepItemData('Preparación', Icons.checklist_rtl_outlined),
    StepItemData('Personal y Mat.', Icons.build_outlined),
    StepItemData('Evidencias', Icons.photo_camera_outlined),
    StepItemData('Calidad', Icons.verified_outlined),
    StepItemData('Cierre', Icons.star_outline_rounded),
  ];

  int get currentStepIndex {
    final upper = status.trim().toUpperCase();
    if (upper == 'NOTIFICADA') return 0;
    if (upper == 'PENDIENTE') return 1;
    if (['ASIGNADA', 'PREPARACION', 'REVISION_RECHAZADA'].contains(upper)) {
      return 2;
    }
    if ([
      'EN_PROCESO',
      'EN_PROCESO_INSPECCION',
      'EN_PROCESO_INSTALACION',
    ].contains(upper)) {
      return 3 + (executionSubStep > 0 ? 1 : 0);
    }
    if ([
      'EJECUTADA',
      'INSPECCION_EJECUTADA',
      'INSTALACION_EJECUTADA',
    ].contains(upper)) {
      return 5;
    }
    if ([
      'COMPLETADA',
      'INSPECCION_COMPLETADA',
      'INSTALACION_COMPLETADA',
    ].contains(upper)) {
      return 6;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = currentStepIndex;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? cs.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(color: theme.dividerColor.withValues(alpha: 0.2))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(steps.length, (index) {
            final isCompleted = index < activeIndex;
            final isCurrent = index == activeIndex;
            final step = steps[index];

            Color iconBgColor;
            Color iconColor;
            Color textColor;

            if (isCompleted) {
              iconBgColor = Colors.green.shade600;
              iconColor = Colors.white;
              textColor = isDark
                  ? Colors.green.shade300
                  : Colors.green.shade800;
            } else if (isCurrent) {
              iconBgColor = AppColors.primary;
              iconColor = Colors.white;
              textColor = AppColors.primary;
            } else {
              iconBgColor = isDark
                  ? cs.surfaceContainerHighest
                  : Colors.grey.shade100;
              iconColor = isDark
                  ? cs.onSurfaceVariant.withValues(alpha: 0.6)
                  : Colors.grey.shade500;
              textColor = isDark
                  ? cs.onSurfaceVariant
                  : Colors.grey.shade600;
            }

            return Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : step.icon,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 76,
                      child: Text(
                        step.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 20,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 20),
                    color: index < activeIndex
                        ? Colors.green.shade500
                        : (isDark
                            ? theme.dividerColor.withValues(alpha: 0.3)
                            : Colors.grey.shade300),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
