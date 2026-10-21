// features/dashboard/presentation/cubits/statistics/statistics_cubit.dart
//
// Cubit genérico y reutilizable para cualquier estadística de lista.
// Abierto a extensión (nuevas estadísticas = nuevo use case), cerrado a
// modificación (OCP). Depende de la abstracción `UseCaseNoParameter` (DIP).

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class StatisticsState<T> extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

final class StatisticsInitial<T> extends StatisticsState<T> {
  const StatisticsInitial();
}

final class StatisticsLoading<T> extends StatisticsState<T> {
  const StatisticsLoading();
}

final class StatisticsLoaded<T> extends StatisticsState<T> {
  final List<T> items;

  const StatisticsLoaded(this.items);

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items];
}

final class StatisticsError<T> extends StatisticsState<T> {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}

class StatisticsCubit<T> extends Cubit<StatisticsState<T>> {
  final UseCaseNoParameter<List<T>> _useCase;

  StatisticsCubit(this._useCase) : super(StatisticsInitial<T>());

  Future<void> load() async {
    if (state is StatisticsLoading<T>) return;
    emit(StatisticsLoading<T>());

    try {
      final result = await _useCase();
      if (isClosed) return;
      result.when(
        success: (items) => emit(StatisticsLoaded<T>(items)),
        failure: (message, _) => emit(
          StatisticsError<T>(message ?? 'No se pudieron cargar los datos'),
        ),
        loading: () {},
      );
    } catch (e) {
      if (!isClosed) emit(StatisticsError<T>('Error inesperado: $e'));
    }
  }
}
