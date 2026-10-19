import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ChecklistDialog extends StatefulWidget {
  final String orderCode;
  final Function(bool passed, String? observations) onSubmit;

  const ChecklistDialog({
    super.key,
    required this.orderCode,
    required this.onSubmit,
  });

  @override
  State<ChecklistDialog> createState() => _ChecklistDialogState();
}

class _ChecklistDialogState extends State<ChecklistDialog> {
  bool _passed = true;
  final TextEditingController _observationsController = TextEditingController();

  @override
  void dispose() {
    _observationsController.dispose();
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
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.checklist,
              color: Colors.amber.shade800,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Checklist de Preparación',
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultado de la Inspección Previa',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _passed = true),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _passed
                            ? Colors.green.shade50
                            : Colors.grey.shade100,
                        border: Border.all(
                          color: _passed ? Colors.green : Colors.grey.shade300,
                          width: _passed ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: _passed ? Colors.green : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Aprobada',
                            style: TextStyle(
                              fontWeight: _passed
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _passed
                                  ? Colors.green.shade900
                                  : Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _passed = false),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_passed
                            ? Colors.red.shade50
                            : Colors.grey.shade100,
                        border: Border.all(
                          color: !_passed ? Colors.red : Colors.grey.shade300,
                          width: !_passed ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel,
                            color: !_passed ? Colors.red : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rechazada',
                            style: TextStyle(
                              fontWeight: !_passed
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: !_passed
                                  ? Colors.red.shade900
                                  : Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Observaciones del Checklist',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _observationsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                    'Detalle el estado de herramientas, permisos y condiciones...',
                hintStyle: const TextStyle(fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _passed ? Colors.green : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(
              _passed,
              _observationsController.text.trim().isEmpty
                  ? null
                  : _observationsController.text.trim(),
            );
          },
          child: const Text(
            'Guardar Checklist',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
