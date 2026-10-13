import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockScreenObserverCubit extends MockCubit<ScreenObserverState>
    implements ScreenObserverCubit {}
