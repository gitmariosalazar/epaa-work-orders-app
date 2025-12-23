import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_material_work_order_entity.dart';

abstract interface class AddMaterialWorkOrderRepository {
  FutureData<List<AddMaterialWorkOrderEntity>> addMaterialToWorkOrders(
    List<AddMaterialWorkOrderEntity> materials,
  );
}
