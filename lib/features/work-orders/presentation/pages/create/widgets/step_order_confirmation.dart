import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../constants/work_order_create_constants.dart';
import '../models/work_order_form_state.dart';

class StepOrderConfirmation extends StatelessWidget {
  final WorkOrderFormState form;

  const StepOrderConfirmation({
    super.key,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final originItem = WorkOrderCreateConstants.origins.firstWhere(
      (o) => o.value == form.origin,
      orElse: () => WorkOrderCreateConstants.origins.first,
    );

    final workTypeItem = WorkOrderCreateConstants.workTypes.firstWhere(
      (t) => t.id == form.workTypeId,
      orElse: () => WorkOrderCreateConstants.workTypes.first,
    );

    final priorityItem = WorkOrderCreateConstants.priorities.firstWhere(
      (p) => p.id == form.priorityId,
      orElse: () => WorkOrderCreateConstants.priorities[1],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── BANNER INFORMATIVO ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revisa antes de confirmar',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Verifica que todos los datos sean correctos. Una vez creada, la OT entrará automáticamente al estado NOTIFICADA.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.blue.shade200 : Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── RESUMEN CLIENTE ──────────────────────────────────────────
          _buildSummaryCard(
            context,
            icon: Icons.person_rounded,
            iconColor: AppColors.primary,
            title: 'Datos del Cliente',
            children: [
              _buildRow(
                context,
                icon: Icons.badge_outlined,
                label: 'Identificación',
                value: form.clientId.isNotEmpty ? form.clientId : '—',
              ),
              _buildRow(
                context,
                icon: Icons.person_outline,
                label: 'Titular / Razón Social',
                value: form.clientName.isNotEmpty ? form.clientName : '—',
              ),
              _buildRow(
                context,
                icon: Icons.email_outlined,
                label: 'Correo Electrónico',
                value: form.clientEmail.isNotEmpty ? form.clientEmail : '—',
              ),
              _buildRow(
                context,
                icon: Icons.phone_outlined,
                label: 'Teléfono',
                value: form.clientPhone.isNotEmpty ? form.clientPhone : '—',
              ),
              _buildRow(
                context,
                icon: Icons.business_outlined,
                label: 'Tipo de Persona',
                value: form.tipoPersona,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── RESUMEN ORDEN ────────────────────────────────────────────
          _buildSummaryCard(
            context,
            icon: Icons.build_rounded,
            iconColor: Colors.teal,
            title: 'Detalle de la Orden de Trabajo',
            children: [
              _buildRow(
                context,
                icon: originItem.icon,
                label: 'Origen',
                value: originItem.label,
              ),
              _buildRow(
                context,
                icon: workTypeItem.icon,
                label: 'Tipo de Trabajo',
                value: workTypeItem.label,
              ),
              _buildRow(
                context,
                icon: Icons.flag_rounded,
                label: 'Prioridad',
                customValue: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityItem.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: priorityItem.color.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: priorityItem.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        priorityItem.label,
                        style: TextStyle(
                          color: priorityItem.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildRow(
                context,
                icon: Icons.place_outlined,
                label: 'Dirección del Trabajo',
                value: form.location.isNotEmpty ? form.location : '—',
              ),
              if (form.cadastralKey.isNotEmpty)
                _buildRow(
                  context,
                  icon: Icons.tag_rounded,
                  label: 'Clave Catastral',
                  value: form.cadastralKey,
                ),
              if (form.latitude != null && form.longitude != null)
                _buildRow(
                  context,
                  icon: Icons.gps_fixed_rounded,
                  label: 'Coordenadas GPS',
                  value:
                      '${form.latitude!.toStringAsFixed(6)}, ${form.longitude!.toStringAsFixed(6)}',
                ),
              if (form.description.isNotEmpty)
                _buildRow(
                  context,
                  icon: Icons.description_outlined,
                  label: 'Descripción / Observaciones',
                  value: form.description,
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ── NOTA DE ESTADO INICIAL ───────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'NOTIFICADA',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Estado inicial que se asignará al guardar',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? theme.dividerColor.withValues(alpha: 0.2) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    Widget? customValue,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: customValue ??
                Text(
                  value ?? '—',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
