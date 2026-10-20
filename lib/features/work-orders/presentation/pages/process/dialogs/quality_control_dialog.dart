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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.purple.withValues(alpha: 0.15)
                  : Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_outlined,
              color: isDark ? Colors.purple.shade300 : Colors.purple.shade800,
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
                  'Control de Calidad',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.orderCode,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? cs.onSurfaceVariant : Colors.grey.shade600,
                  ),
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
                        color: _approved
                            ? (isDark
                                ? Colors.green.withValues(alpha: 0.15)
                                : Colors.green.shade50)
                            : (isDark
                                ? cs.surfaceContainerHighest.withValues(
                                    alpha: 0.3,
                                  )
                                : Colors.grey.shade100),
                        border: Border.all(
                          color: _approved
                              ? Colors.green
                              : (isDark
                                  ? theme.dividerColor.withValues(alpha: 0.2)
                                  : Colors.grey.shade300),
                          width: _approved ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _approved
                                ? Colors.green
                                : (isDark
                                    ? cs.onSurfaceVariant
                                    : Colors.grey),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Aprobado',
                            style: TextStyle(
                              fontWeight: _approved
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _approved
                                  ? (isDark
                                      ? Colors.green.shade300
                                      : Colors.green.shade900)
                                  : (isDark
                                      ? cs.onSurfaceVariant
                                      : Colors.grey.shade700),
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
                        color: !_approved
                            ? (isDark
                                ? Colors.red.withValues(alpha: 0.15)
                                : Colors.red.shade50)
                            : (isDark
                                ? cs.surfaceContainerHighest.withValues(
                                    alpha: 0.3,
                                  )
                                : Colors.grey.shade100),
                        border: Border.all(
                          color: !_approved
                              ? Colors.red
                              : (isDark
                                  ? theme.dividerColor.withValues(alpha: 0.2)
                                  : Colors.grey.shade300),
                          width: !_approved ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.highlight_off,
                            color: !_approved
                                ? Colors.red
                                : (isDark
                                    ? cs.onSurfaceVariant
                                    : Colors.grey),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rechazado',
                            style: TextStyle(
                              fontWeight: !_approved
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: !_approved
                                  ? (isDark
                                      ? Colors.red.shade300
                                      : Colors.red.shade900)
                                  : (isDark
                                      ? cs.onSurfaceVariant
                                      : Colors.grey.shade700),
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
                hintText:
                    'Detalle de la inspección técnica o motivos de rechazo...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? cs.onSurfaceVariant.withValues(alpha: 0.6)
                      : Colors.grey.shade500,
                ),
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
            backgroundColor: _approved ? Colors.purple : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
          child: const Text(
            'Guardar Dictamen',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
