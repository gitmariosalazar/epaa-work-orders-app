import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_departments_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'departments_state.dart';

@injectable
class DepartmentsCubit extends Cubit<DepartmentsState> {
  final GetDepartmentsUseCase _getDepartmentsUseCase;
  List<DepartmentEntity>? _cachedDepartments;

  DepartmentsCubit({
    required GetDepartmentsUseCase getDepartmentsUseCase,
  })  : _getDepartmentsUseCase = getDepartmentsUseCase,
        super(const DepartmentsInitial());

  List<DepartmentEntity>? get cachedDepartments => _cachedDepartments;

  Future<void> loadDepartments({bool refresh = false}) async {
    if (!refresh &&
        _cachedDepartments != null &&
        _cachedDepartments!.isNotEmpty) {
      emit(DepartmentsLoaded(_cachedDepartments!));
      return;
    }

    emit(const DepartmentsLoading());

    try {
      final result = await _getDepartmentsUseCase();

      result.when(
        success: (data) {
          _cachedDepartments = data;
          emit(DepartmentsLoaded(data));
        },
        failure: (message, _) {
          emit(
            DepartmentsError(
              message ?? 'Error al cargar departamentos y tipos de trabajo',
            ),
          );
        },
        loading: () {
          if (state is! DepartmentsLoading && !isClosed) {
            emit(const DepartmentsLoading());
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(DepartmentsError('Error inesperado: $e'));
      }
    }
  }
}
