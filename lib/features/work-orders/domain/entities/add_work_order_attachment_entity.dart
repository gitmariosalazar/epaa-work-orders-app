import 'package:equatable/equatable.dart';

class AddWorkOrderAttachmentEntity extends Equatable {
  final String workOrderId;
  final String fileName;
  final String fileType;
  final String fileUrl;

  const AddWorkOrderAttachmentEntity({
    required this.workOrderId,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'workOrderId': workOrderId,
      'fileName': fileName,
      'fileType': fileType,
      'fileUrl': fileUrl,
    };
  }

  @override
  List<Object?> get props => [workOrderId, fileName, fileType, fileUrl];
}
