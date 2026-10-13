import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:clean_architecture/features/connections/search/domain/usecases/get_connection_with_properties.dart';
import 'search_connection_state.dart';

@injectable
class SearchConnectionCubit extends Cubit<SearchConnectionState> {
  final GetConnection getConnection;

  SearchConnectionCubit(this.getConnection) : super(SearchConnectionInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchConnectionInitial());
      return;
    }
    emit(SearchConnectionLoading());
    try {
      final results = await getConnection(query.trim());
      emit(SearchConnectionLoaded(results));
    } catch (e) {
      emit(SearchConnectionError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
