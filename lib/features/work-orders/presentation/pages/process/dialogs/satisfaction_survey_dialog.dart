import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SatisfactionSurveyDialog extends StatefulWidget {
  final String orderCode;
  final Function(int rating, String? comments) onSubmit;

  const SatisfactionSurveyDialog({
    super.key,
    required this.orderCode,
    required this.onSubmit,
  });

  @override
  State<SatisfactionSurveyDialog> createState() =>
      _SatisfactionSurveyDialogState();
}

class _SatisfactionSurveyDialogState extends State<SatisfactionSurveyDialog> {
  int _rating = 5;
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
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.star, color: Colors.amber.shade800, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Encuesta de Satisfacción',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Calificación del Cliente',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                final isSelected = starValue <= _rating;
                return IconButton(
                  iconSize: 25,
                  icon: Icon(
                    isSelected
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: isSelected ? Colors.amber : Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = starValue;
                    });
                  },
                );
              }),
            ),
            Text(
              '$_rating de 5 Estrellas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.amber.shade900,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Comentarios / Sugerencias del Cliente',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _commentsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Opinión del usuario sobre el trabajo realizado...',
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
            backgroundColor: Colors.amber.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(
              _rating,
              _commentsController.text.trim().isEmpty
                  ? null
                  : _commentsController.text.trim(),
            );
          },
          child: const Text(
            'Registrar Encuesta',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
