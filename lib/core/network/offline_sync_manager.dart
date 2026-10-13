import 'package:injectable/injectable.dart';

@injectable
class OfflineSyncManager {
  Future<void> enqueueTask({
    required String type,
    required String entityId,
    required Map<String, dynamic> payload,
  }) async {
    // Stub
  }
}
