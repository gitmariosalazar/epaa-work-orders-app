// features/work-orders/data/datasources/remote/add_work_order_attachment_remote_data_source.dart

import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/work-orders/data/models/models/add_work_order_attachment_model.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

abstract class AddWorkOrderAttachmentRemoteDataSource {
  FutureData<List<AddWorkOrderAttachmentModel>> addAttachmentToWorkOrders(
    String workOrderId,
    List<PlatformFile> attachments,
    String description,
  );
}

@LazySingleton(as: AddWorkOrderAttachmentRemoteDataSource)
class AddWorkOrderAttachmentRemoteDataSourceImpl
    implements AddWorkOrderAttachmentRemoteDataSource {
  final ApiService _apiService;

  const AddWorkOrderAttachmentRemoteDataSourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  @override
  FutureData<List<AddWorkOrderAttachmentModel>> addAttachmentToWorkOrders(
    String workOrderId,
    List<PlatformFile> attachments,
    String description,
  ) {
    return DataHandler.safeApiCall<
      List<AddWorkOrderAttachmentModel>,
      AddWorkOrderAttachmentModel
    >(
      request: () async {
        final formData = FormData();

        formData.fields.addAll([
          MapEntry('workOrderId', workOrderId),
          MapEntry('descripcion', description),
        ]);

        for (final file in attachments) {
          if (file.path == null) continue;

          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(file.path!, filename: file.name),
            ),
          );
        }

        return await _apiService.post(
          ApiEndpoints.addWorkOrderAttachment,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            receiveTimeout: const Duration(seconds: 60),
            sendTimeout: const Duration(seconds: 60),
          ),
        );
      },
      fromJson: (json) => AddWorkOrderAttachmentModel.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
