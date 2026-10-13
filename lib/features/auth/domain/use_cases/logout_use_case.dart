import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LogoutUseCase implements UseCaseNoParameter<bool> {
  final AuthRepository _repository;

  LogoutUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  FutureBool call() => _repository.logout();
}
