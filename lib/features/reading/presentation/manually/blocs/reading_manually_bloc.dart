import 'package:injectable/injectable.dart';
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/features/reading/domain/usecases/get_reading_info.dart';

import 'reading_manually_event.dart';
import 'reading_manually_state.dart';

@injectable
class ReadingManuallyBloc
    extends Bloc<ReadingManuallyEvent, ReadingManuallyState> {
  final GetReadingInfo getReadingInfo;

  ReadingManuallyBloc(this.getReadingInfo) : super(ReadingManuallyInitial()) {
    on<LoadReadingManuallyInfo>(_onLoadReadingInfo);
  }

  Future<void> _onLoadReadingInfo(
    LoadReadingManuallyInfo event,
    Emitter<ReadingManuallyState> emit,
  ) async {
    emit(ReadingManuallyLoading());
    try {
      final result = await getReadingInfo(event.cadastralKey);
      result.when(
        success: (reading) => emit(ReadingManuallyLoaded(reading)),
        failure: (message, _) => emit(ReadingManuallyError(message ?? 'Error')),
        loading: () => emit(ReadingManuallyLoading()),
      );
    } catch (e) {
      emit(ReadingManuallyError(e.toString()));
    }
  }
}
