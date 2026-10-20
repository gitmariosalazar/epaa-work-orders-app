// features/dashboard/presentation/pages/technician/widgets/quick_actions_bar.dart

import 'package:flutter/material.dart';

class QuickActionsBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNewOrderTap;
  final VoidCallback? onSyncTap;
  final bool isSyncing;

  const QuickActionsBar({
    super.key,
    this.onSearchTap,
    this.onNewOrderTap,
    this.onSyncTap,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACCIONES RÁPIDAS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.search_rounded,
                label: 'Buscar OT',
                accentColor:
                    isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                onTap: onSearchTap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_circle_outline_rounded,
                label: 'Nueva OT',
                accentColor:
                    isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                onTap: onNewOrderTap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _QuickActionButton(
                icon: isSyncing
                    ? Icons.hourglass_empty_rounded
                    : Icons.sync_rounded,
                label: isSyncing ? 'Sincronizando' : 'Sincronizar',
                accentColor:
                    isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
                isLoading: isSyncing,
                onTap: isSyncing ? null : onSyncTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback? onTap;
  final bool isLoading;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.accentColor,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? cs.surfaceContainerHighest : Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: isDark ? 0 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? cs.outlineVariant : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.22 : 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: accentColor,
                        ),
                      )
                    : Icon(
                        icon,
                        color: accentColor,
                        size: 20,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
