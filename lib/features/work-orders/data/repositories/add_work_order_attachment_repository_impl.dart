import 'package:clean_architecture/features/work-orders/data/datasource/remote/add_work_order_attachment_remote_data_source.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_attachment_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/repositories/add_work_order_attachment_repository.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:injectable/injectable.dart';
import 'package:file_picker/file_picker.dart';

@LazySingleton(as: AddWorkOrderAttachmentRepository)
class AddWorkOrderAttachmentRepositoryImpl
    implements AddWorkOrderAttachmentRepository {
  final AddWorkOrderAttachmentRemoteDataSource _remoteDataSource;

  AddWorkOrderAttachmentRepositoryImpl({
    required AddWorkOrderAttachmentRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  FutureData<List<AddWorkOrderAttachmentEntity>> addAttachmentToWorkOrders(
    String workOrderId,
    List<PlatformFile> attachments,
    String description,
  ) async {
    final result = await _remoteDataSource.addAttachmentToWorkOrders(
      workOrderId,
      attachments,
      description,
    );

    return result.when(
      success: (addedModels) {
        final entities = addedModels.map((model) => model.toEntity()).toList();
        return SuccessState<List<AddWorkOrderAttachmentEntity>>(data: entities);
      },
      failure: (message, errorType) {
        return FailureState<List<AddWorkOrderAttachmentEntity>>(
          message: message,
          errorType: errorType,
        );
      },
      loading: () {
        return LoadingState<List<AddWorkOrderAttachmentEntity>>();
      },
    );
  }
}
