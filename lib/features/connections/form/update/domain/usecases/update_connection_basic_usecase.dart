import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/update_connection_basic_request.dart';
import 'package:clean_architecture/features/connections/form/update/domain/repositories/connection_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateConnectionBasicUseCase {
  final UpdateConnectionRepository repository;

  UpdateConnectionBasicUseCase(this.repository);

  Future<void> call(UpdateConnectionBasicRequest request) async {
    return await repository.updateConnectionBasic(request);
  }
}
