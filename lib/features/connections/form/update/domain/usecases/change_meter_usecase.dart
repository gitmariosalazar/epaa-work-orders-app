import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/change_meter_request.dart';
import 'package:clean_architecture/features/connections/form/update/domain/repositories/connection_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeMeterUseCase {
  final UpdateConnectionRepository repository;

  ChangeMeterUseCase(this.repository);

  Future<void> call(ChangeMeterRequest request) async {
    return await repository.changeMeter(request);
  }
}
