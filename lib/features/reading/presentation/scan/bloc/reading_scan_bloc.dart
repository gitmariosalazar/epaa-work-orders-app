import 'package:injectable/injectable.dart';
// lib/features/scan/presentation/blocs/reading_bloc.dart
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/features/reading/domain/usecases/get_reading_info.dart';
import 'reading_scan_event.dart';
import 'reading_scan_state.dart';

@injectable
class ReadingScanBloc extends Bloc<ReadingScanEvent, ReadingScanState> {
  final GetReadingInfo getReadingInfo;

  ReadingScanBloc(this.getReadingInfo) : super(ReadingScanInitial()) {
    on<LoadReadingScanInfo>(_onLoadReadingInfo);
    on<ResetReadingScan>(_onResetReadingScan);
  }

  Future<void> _onLoadReadingInfo(
    LoadReadingScanInfo event,
    Emitter<ReadingScanState> emit,
  ) async {
    emit(ReadingScanLoading());
    try {
      final result = await getReadingInfo(event.cadastralKey);
      result.when(
        success: (reading) => emit(ReadingScanLoaded(reading)),
        failure: (message, _) => emit(ReadingScanError(message ?? 'Error')),
        loading: () => emit(ReadingScanLoading()),
      );
    } catch (e) {
      emit(ReadingScanError(e.toString()));
    }
  }

  void _onResetReadingScan(
    ResetReadingScan event,
    Emitter<ReadingScanState> emit,
  ) {
    emit(ReadingScanInitial());
  }
}
