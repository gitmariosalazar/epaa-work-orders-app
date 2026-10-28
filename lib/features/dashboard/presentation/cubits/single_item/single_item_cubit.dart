// features/dashboard/presentation/cubits/single_item/single_item_cubit.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SingleItemState<T> extends Equatable {
  const SingleItemState();

  @override
  List<Object?> get props => [];
}

final class SingleItemInitial<T> extends SingleItemState<T> {
  const SingleItemInitial();
}

final class SingleItemLoading<T> extends SingleItemState<T> {
  const SingleItemLoading();
}

final class SingleItemLoaded<T> extends SingleItemState<T> {
  final T data;

  const SingleItemLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

final class SingleItemError<T> extends SingleItemState<T> {
  final String message;

  const SingleItemError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Cubit genérico y reutilizable para cualquier entidad individual (Single Object).
class SingleItemCubit<T> extends Cubit<SingleItemState<T>> {
  final UseCaseNoParameter<T> _useCase;

  SingleItemCubit(this._useCase) : super(SingleItemInitial<T>());

  Future<void> load() async {
    if (state is SingleItemLoading<T>) return;
    emit(SingleItemLoading<T>());

    try {
      final result = await _useCase();
      if (isClosed) return;
      result.when(
        success: (data) => emit(SingleItemLoaded<T>(data)),
        failure: (message, _) => emit(
          SingleItemError<T>(message ?? 'No se pudo cargar la información'),
        ),
        loading: () {},
      );
    } catch (e) {
      if (!isClosed) emit(SingleItemError<T>('Error inesperado: $e'));
    }
  }
}
