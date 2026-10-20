import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/users/presentation/widgets/user_picker_dialog.dart';
import 'package:clean_architecture/features/users/users.dart';
import 'package:flutter/material.dart';

/// Fase 2 — Asignar Técnico Responsable.
/// El técnico se elige de los usuarios existentes (módulo users), no por UUID.
class AssignWorkerDialog extends StatefulWidget {
  final String orderCode;
  final Function(String workerId, String? comment) onAssign;

  const AssignWorkerDialog({
    super.key,
    required this.orderCode,
    required this.onAssign,
  });

  @override
  State<AssignWorkerDialog> createState() => _AssignWorkerDialogState();
}

class _AssignWorkerDialogState extends State<AssignWorkerDialog> {
  final _commentController = TextEditingController();
  UserEntity? _selected;
  bool _showError = false;

  Future<void> _selectWorker() async {
    final user = await UserPickerDialog.show(
      context,
      title: 'Seleccionar Técnico',
      filter: isServiceTechnician,
    );
    if (user != null) {
      setState(() {
        _selected = user;
        _showError = false;
      });
    }
  }

  void _submit() {
    if (_selected == null) {
      setState(() => _showError = true);
      return;
    }
    final comment = _commentController.text.trim();
    Navigator.pop(context);
    widget.onAssign(_selected!.userId, comment.isEmpty ? null : comment);
  }

  @override
  void dispose() {
    _commentController.dispose();
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
              color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_alt_1,
              color: AppColors.primary,
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
                  'Asignar Técnico Responsable',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'OT: ${widget.orderCode}',
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
              'Técnico Responsable *',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _selectWorker,
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  suffixIcon: const Icon(Icons.search),
                  errorText: _showError ? 'Debe seleccionar un técnico' : null,
                ),
                child: _selected == null
                    ? Text(
                        'Toca para buscar técnico...',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? cs.onSurfaceVariant
                              : Colors.grey.shade600,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selected!.fullName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if ((_selected!.positionName ?? '').isNotEmpty)
                            Text(
                              _selected!.positionName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? cs.onSurfaceVariant
                                    : Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Comentario / Observación',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Instrucciones u observaciones...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? cs.onSurfaceVariant.withValues(alpha: 0.6)
                      : Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
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
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _submit,
          child: const Text('Asignar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
