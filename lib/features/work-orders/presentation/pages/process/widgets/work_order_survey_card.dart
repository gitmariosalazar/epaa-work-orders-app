import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:flutter/material.dart';

class WorkOrderSurveyCard extends StatelessWidget {
  final WorkOrderDetailEntity order;
  final VoidCallback? onRegisterSurvey;

  const WorkOrderSurveyCard({
    super.key,
    required this.order,
    this.onRegisterSurvey,
  });

  @override
  Widget build(BuildContext context) {
    final survey = order.encuestaSatisfaccion;
    final hasSurvey = survey != null;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber.shade800,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Encuesta de Satisfacción',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (!hasSurvey && onRegisterSurvey != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onRegisterSurvey,
                    icon: const Icon(Icons.star, size: 13, color: Colors.white),
                    label: const Text(
                      'Encuestar',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const Divider(height: 16),
            if (!hasSurvey)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Text(
                  'Encuesta de satisfacción pendiente.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else ...[
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final isFilled = index < survey.calificacion;
                      return Icon(
                        isFilled
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: isFilled ? Colors.amber : Colors.grey.shade300,
                        size: 24,
                      );
                    }),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${survey.calificacion} / 5',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
              if (survey.fechaEncuesta != null &&
                  survey.fechaEncuesta!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Fecha: ${survey.fechaEncuesta}',
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
              ],
              if (survey.comentarios != null &&
                  survey.comentarios!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Text(
                    '"${survey.comentarios}"',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
