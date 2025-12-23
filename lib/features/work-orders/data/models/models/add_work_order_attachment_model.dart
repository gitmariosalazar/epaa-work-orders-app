import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_attachment_entity.dart';

class AddWorkOrderAttachmentModel {
  final String workOrderId;
  final String fileName;
  final String fileType;
  final String fileUrl;

  const AddWorkOrderAttachmentModel({
    required this.workOrderId,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
  });

  factory AddWorkOrderAttachmentModel.fromEntity(
    AddWorkOrderAttachmentEntity entity,
  ) {
    return AddWorkOrderAttachmentModel(
      workOrderId: entity.workOrderId,
      fileName: entity.fileName,
      fileType: entity.fileType,
      fileUrl: entity.fileUrl,
    );
  }

  AddWorkOrderAttachmentEntity toEntity() {
    return AddWorkOrderAttachmentEntity(
      workOrderId: workOrderId,
      fileName: fileName,
      fileType: fileType,
      fileUrl: fileUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'fileName': fileName,
      'fileType': fileType,
      'fileUrl': fileUrl,
    };
  }

  factory AddWorkOrderAttachmentModel.fromJson(Map<String, dynamic> json) {
    return AddWorkOrderAttachmentModel(
      workOrderId: json['workOrderId'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileUrl: json['fileUrl'] as String,
    );
  }
}
