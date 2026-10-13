import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class WorkOrderSuccessView extends StatelessWidget {
  final String? codigoOrden;
  final VoidCallback onCreateAnother;
  final VoidCallback onGoToOrders;

  const WorkOrderSuccessView({
    super.key,
    required this.codigoOrden,
    required this.onCreateAnother,
    required this.onGoToOrders,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono animado o destacado
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 54,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '¡Orden Creada Exitosamente!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              if (codigoOrden != null && codigoOrden!.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? theme.dividerColor.withValues(alpha: 0.2)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'CÓDIGO DE LA OT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.2,
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        codigoOrden!,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Mensaje informativo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    children: const [
                      TextSpan(text: 'La orden fue registrada en estado '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0x222196F3),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              'NOTIFICADA',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text:
                            '.\nPodrá continuar con la asignación y ejecución en el listado de órdenes.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCreateAnother,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Crear otra OT'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onGoToOrders,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                      label: const Text('Ir a Órdenes'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
