part of 'add-work_order_assignments_cubit.dart';

sealed class AddWorkOrderAssignmentsState {}

class AddWorkOrderAssignmentsInitial extends AddWorkOrderAssignmentsState {}

class AddWorkOrderAssignmentsLoading extends AddWorkOrderAssignmentsState {}

class AddWorkOrderAssignmentsSuccess extends AddWorkOrderAssignmentsState {
  final List<AddWorkOrderAssignmentEntity> addedAssignments;
  AddWorkOrderAssignmentsSuccess(this.addedAssignments);
}

class AddWorkOrderAssignmentsError extends AddWorkOrderAssignmentsState {
  final String message;
  AddWorkOrderAssignmentsError(this.message);
}
