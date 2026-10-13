import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/data/models/requests/process_work_order_requests.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _unitCostController = TextEditingController(text: '0.00');

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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.monetization_on_outlined, color: Colors.blue.shade800, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Agregar Costo Adicional',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.orderCode,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Concepto / Descripción *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _conceptController,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Ingrese el concepto del gasto';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Ej. Transporte, Alquiler de Bomba...',
                  hintStyle: const TextStyle(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cantidad *',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          validator: (val) {
                            final parsed = double.tryParse(val ?? '');
                            if (parsed == null || parsed <= 0) {
                              return 'Inválido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Costo Unit. (\$) *',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _unitCostController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          validator: (val) {
                            final parsed = double.tryParse(val ?? '');
                            if (parsed == null || parsed < 0) {
                              return 'Inválido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal Estimado:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      '\$${_subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(context);
              final req = AddAdditionalCostRequest(
                concept: _conceptController.text.trim(),
                quantity: double.parse(_quantityController.text.trim()),
                unitCost: double.parse(_unitCostController.text.trim()),
              );
              widget.onSubmit(req);
            }
          },
          child: const Text('Agregar Costo', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
