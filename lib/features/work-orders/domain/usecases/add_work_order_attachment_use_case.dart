import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_attachment_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/add_work_order_attachment_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddWorkOrderAttachmentUseCase
    implements
        UseCase<
          List<AddWorkOrderAttachmentEntity>,
          AddWorkOrderAttachmentParams
        > {
  final AddWorkOrderAttachmentRepository _repository;

  AddWorkOrderAttachmentUseCase(this._repository);

  @override
  FutureData<List<AddWorkOrderAttachmentEntity>> call(
    AddWorkOrderAttachmentParams params,
  ) async {
    try {
      final result = await _repository.addAttachmentToWorkOrders(
        params.workOrderId,
        params.files,
        params.description,
      );
      return SuccessState<List<AddWorkOrderAttachmentEntity>>(
        data: result is SuccessState ? result.data ?? [] : [],
      );
    } catch (e) {
      return FailureState<List<AddWorkOrderAttachmentEntity>>(
        message: e.toString(),
        errorType: ErrorType.unknown,
      );
    }
  }
}

class AddWorkOrderAttachmentParams {
  final String workOrderId;
  final List<PlatformFile> files;
  final String description;

  AddWorkOrderAttachmentParams({
    required this.workOrderId,
    required this.files,
    this.description = '',
  });
}
