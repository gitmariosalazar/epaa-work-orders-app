import '../../domain/interfaces/map_adapter.dart';
import '../adapters/flutter_map_adapter.dart';

class MapFactory {
  static IMapAdapter getAdapter() {
    return FlutterMapAdapter();
  }
}
