import 'package:flutter/material.dart';
import '../constants/work_order_create_constants.dart';

class WorkOrderStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<WorkOrderStepItem> steps;
  final void Function(int step)? onStepTapped;

  const WorkOrderStepIndicator({
    super.key,
    required this.currentStep,
    this.steps = WorkOrderCreateConstants.steps,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _buildStepItem(context, steps[i]),
            ),
            if (i < steps.length - 1)
              _buildConnector(context, isCompleted: currentStep > steps[i].id),
          ],
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, WorkOrderStepItem item) {
    final cs = Theme.of(context).colorScheme;
    final isCompleted = currentStep > item.id;
    final isCurrent = currentStep == item.id;

    final circleColor = isCompleted
        ? Colors.green.shade600
        : isCurrent
            ? cs.primary
            : cs.surfaceContainerHighest;

    final iconColor = isCompleted || isCurrent
        ? Colors.white
        : cs.onSurfaceVariant.withValues(alpha: 0.6);

    final textColor = isCurrent
        ? cs.primary
        : isCompleted
            ? Colors.green.shade700
            : cs.onSurfaceVariant;

    return InkWell(
      onTap: onStepTapped != null ? () => onStepTapped!(item.id) : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Icon(
                  isCompleted ? Icons.check_rounded : item.icon,
                  size: 16,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnector(BuildContext context, {required bool isCompleted}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isCompleted
          ? Colors.green.shade600
          : cs.outlineVariant.withValues(alpha: 0.4),
    );
  }
}
