import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_attachment_entity.dart';
import 'package:file_picker/file_picker.dart';

abstract class AddWorkOrderAttachmentRepository {
  FutureData<List<AddWorkOrderAttachmentEntity>> addAttachmentToWorkOrders(
    String workOrderId,
    List<PlatformFile> attachments,
    String description,
  );
}
