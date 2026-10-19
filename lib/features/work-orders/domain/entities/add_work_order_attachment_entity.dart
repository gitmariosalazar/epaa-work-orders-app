import 'package:equatable/equatable.dart';

class AddWorkOrderAttachmentEntity extends Equatable {
  final String workOrderId;
  final String fileName;
  final String fileType;
  final String fileUrl;
  final String? evidenceStageCode;

  const AddWorkOrderAttachmentEntity({
    required this.workOrderId,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    this.evidenceStageCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'fileName': fileName,
      'fileType': fileType,
      'fileUrl': fileUrl,
      if (evidenceStageCode != null) 'evidenceStageCode': evidenceStageCode,
    };
  }

  @override
  List<Object?> get props => [workOrderId, fileName, fileType, fileUrl];
}
