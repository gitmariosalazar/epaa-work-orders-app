part of 'departments_cubit.dart';

sealed class DepartmentsState {
  const DepartmentsState();
}

class DepartmentsInitial extends DepartmentsState {
  const DepartmentsInitial();
}

class DepartmentsLoading extends DepartmentsState {
  const DepartmentsLoading();
}

class DepartmentsLoaded extends DepartmentsState {
  final List<DepartmentEntity> departments;

  const DepartmentsLoaded(this.departments);

  /// Helper to get all work types paired with their department
  List<({DepartmentEntity department, WorkTypeEntity workType})> get allWorkTypes {
    final list = <({DepartmentEntity department, WorkTypeEntity workType})>[];
    for (final dept in departments) {
      for (final wt in dept.workTypes) {
        list.add((department: dept, workType: wt));
      }
    }
    return list;
  }
}

class DepartmentsError extends DepartmentsState {
  final String message;

  const DepartmentsError(this.message);
}
