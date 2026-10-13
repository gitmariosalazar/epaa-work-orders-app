import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class QualityControlDialog extends StatefulWidget {
  final String orderCode;
  final Function(bool approved, String? comments) onSubmit;

  const QualityControlDialog({
    super.key,
    required this.orderCode,
    required this.onSubmit,
  });

  @override
  State<QualityControlDialog> createState() => _QualityControlDialogState();
}

class _QualityControlDialogState extends State<QualityControlDialog> {
  bool _approved = true;
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
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
              color: Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.verified_outlined, color: Colors.purple.shade800, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Control de Calidad',
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
              'Dictamen de Auditoría / Calidad *',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _approved = true),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _approved ? Colors.green.shade50 : Colors.grey.shade100,
                        border: Border.all(
                          color: _approved ? Colors.green : Colors.grey.shade300,
                          width: _approved ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _approved ? Colors.green : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Aprobado',
                            style: TextStyle(
                              fontWeight: _approved ? FontWeight.bold : FontWeight.normal,
                              color: _approved ? Colors.green.shade900 : Colors.grey.shade700,
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
                    onTap: () => setState(() => _approved = false),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_approved ? Colors.red.shade50 : Colors.grey.shade100,
                        border: Border.all(
                          color: !_approved ? Colors.red : Colors.grey.shade300,
                          width: !_approved ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.highlight_off,
                            color: !_approved ? Colors.red : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rechazado',
                            style: TextStyle(
                              fontWeight: !_approved ? FontWeight.bold : FontWeight.normal,
                              color: !_approved ? Colors.red.shade900 : Colors.grey.shade700,
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
              'Observaciones y Dictamen Técnico',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _commentsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Detalle de la inspección técnica o motivos de rechazo...',
                hintStyle: const TextStyle(fontSize: 13),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
            backgroundColor: _approved ? Colors.purple : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(
              _approved,
              _commentsController.text.trim().isEmpty
                  ? null
                  : _commentsController.text.trim(),
            );
          },
          child: const Text('Guardar Dictamen', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
