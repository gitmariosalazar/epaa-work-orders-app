// features/dashboard/presentation/pages/technician/widgets/technician_kpi_card.dart

import 'package:flutter/material.dart';

class TechnicianKpiCard extends StatelessWidget {
  final int pendingCount;
  final int inProgressCount;
  final int completedCount;
  final VoidCallback? onPendingTap;
  final VoidCallback? onInProgressTap;
  final VoidCallback? onCompletedTap;

  const TechnicianKpiCard({
    super.key,
    required this.pendingCount,
    required this.inProgressCount,
    required this.completedCount,
    this.onPendingTap,
    this.onInProgressTap,
    this.onCompletedTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final pendingColor =
        isDark ? const Color(0xFFFFB74D) : const Color(0xFFD97706);
    final inProgressColor =
        isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    final completedColor =
        isDark ? const Color(0xFF34D399) : const Color(0xFF059669);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _KpiItem(
              title: 'Pendientes',
              value: pendingCount.toString(),
              color: pendingColor,
              icon: Icons.hourglass_empty_rounded,
              onTap: onPendingTap,
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: _KpiItem(
              title: 'En Curso',
              value: inProgressCount.toString(),
              color: inProgressColor,
              icon: Icons.pending_actions_rounded,
              onTap: onInProgressTap,
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: _KpiItem(
              title: 'Completas',
              value: completedCount.toString(),
              color: completedColor,
              icon: Icons.task_alt_rounded,
              onTap: onCompletedTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _KpiItem({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
