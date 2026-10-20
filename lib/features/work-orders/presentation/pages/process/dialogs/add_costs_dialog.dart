import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/data/models/requests/process_work_order_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCostsDialog extends StatefulWidget {
  final String orderCode;
  final Function(AddAdditionalCostRequest cost) onSubmit;

  const AddCostsDialog({
    super.key,
    required this.orderCode,
    required this.onSubmit,
  });

  @override
  State<AddCostsDialog> createState() => _AddCostsDialogState();
}

class _AddCostsDialogState extends State<AddCostsDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _conceptController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController _unitCostController = TextEditingController(
    text: '0.00',
  );

  double get _subtotal {
    final qty = double.tryParse(_quantityController.text) ?? 0.0;
    final cost = double.tryParse(_unitCostController.text) ?? 0.0;
    return qty * cost;
  }

  @override
  void dispose() {
    _conceptController.dispose();
    _quantityController.dispose();
    _unitCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: cs.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con icono estilizado y cierre rápido
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 16),
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.3)
                    : Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? theme.dividerColor.withValues(alpha: 0.2)
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.payments_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agregar Costo Adicional',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'Orden: ',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? cs.surfaceContainerHighest
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.orderCode,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: cs.onSurfaceVariant,
                    ),
                    splashRadius: 20,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Contenido del Formulario
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Concepto / Descripción
                      Text(
                        'Concepto / Descripción',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _conceptController,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: cs.onSurface,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingrese el concepto del gasto';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Ej. Transporte, Alquiler de Bomba...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? cs.onSurfaceVariant.withValues(alpha: 0.6)
                                : Colors.grey.shade400,
                          ),
                          prefixIcon: Icon(
                            Icons.edit_note_rounded,
                            size: 22,
                            color: cs.onSurfaceVariant,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? cs.surfaceContainerHighest.withValues(
                                  alpha: 0.2,
                                )
                              : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? theme.dividerColor.withValues(alpha: 0.2)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? theme.dividerColor.withValues(alpha: 0.2)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Cantidad y Costo Unitario en Fila
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo Cantidad
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cantidad',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                    color: cs.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _quantityController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*'),
                                    ),
                                  ],
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                  validator: (val) {
                                    final parsed = double.tryParse(val ?? '');
                                    if (parsed == null || parsed <= 0) {
                                      return 'Inválido';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.format_list_numbered_rounded,
                                      size: 18,
                                      color: cs.onSurfaceVariant,
                                    ),
                                    filled: true,
                                    fillColor: isDark
                                        ? cs.surfaceContainerHighest.withValues(
                                            alpha: 0.2,
                                          )
                                        : const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? theme.dividerColor.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? theme.dividerColor.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Campo Costo Unitario
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Costo Unitario',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                    color: cs.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _unitCostController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*'),
                                    ),
                                  ],
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                  validator: (val) {
                                    final parsed = double.tryParse(val ?? '');
                                    if (parsed == null || parsed < 0) {
                                      return 'Inválido';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Container(
                                      width: 32,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '\$',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: isDark
                                        ? cs.surfaceContainerHighest.withValues(
                                            alpha: 0.2,
                                          )
                                        : const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? theme.dividerColor.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: isDark
                                            ? theme.dividerColor.withValues(
                                                alpha: 0.2,
                                              )
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tarjeta de Subtotal Dinámica
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? cs.primaryContainer.withValues(alpha: 0.3)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? cs.primary.withValues(alpha: 0.4)
                                : Colors.blue.shade200,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isDark ? Colors.black : Colors.blue.shade100)
                                  .withValues(alpha: isDark ? 0.2 : 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? cs.primary.withValues(alpha: 0.2)
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.calculate_outlined,
                                    size: 18,
                                    color: isDark
                                        ? cs.primary
                                        : Colors.blue.shade900,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Subtotal Estimado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$${_subtotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                letterSpacing: -0.5,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer con Acciones
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.3)
                    : Colors.grey.shade50,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? theme.dividerColor.withValues(alpha: 0.2)
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? cs.onSurfaceVariant
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text(
                      'Agregar Costo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.pop(context);
                        final req = AddAdditionalCostRequest(
                          concept: _conceptController.text.trim(),
                          quantity: double.parse(
                            _quantityController.text.trim(),
                          ),
                          unitCost: double.parse(
                            _unitCostController.text.trim(),
                          ),
                        );
                        widget.onSubmit(req);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
