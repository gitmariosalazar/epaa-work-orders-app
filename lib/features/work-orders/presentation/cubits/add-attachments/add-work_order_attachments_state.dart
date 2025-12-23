part of 'add-work_order_attachments_cubit.dart';

sealed class AddWorkOrderAttachmentsState {}

class AddWorkOrderAttachmentsInitial extends AddWorkOrderAttachmentsState {}

class AddWorkOrderAttachmentsLoading extends AddWorkOrderAttachmentsState {}

class AddWorkOrderAttachmentsSuccess extends AddWorkOrderAttachmentsState {
  final List<AddWorkOrderAttachmentEntity> addedAttachments;
  AddWorkOrderAttachmentsSuccess(this.addedAttachments);
}

class AddWorkOrderAttachmentsError extends AddWorkOrderAttachmentsState {
  final String message;
  AddWorkOrderAttachmentsError(this.message);
}
