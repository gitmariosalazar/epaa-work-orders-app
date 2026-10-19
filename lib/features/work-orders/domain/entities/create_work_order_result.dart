import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';

class CreateWorkOrderResult {
  final WorkOrderEntity order;

  /// Mensaje si la orden se creó pero las evidencias no se pudieron subir.
  final String? evidenceWarning;

  const CreateWorkOrderResult({required this.order, this.evidenceWarning});
}
