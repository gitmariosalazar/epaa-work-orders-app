import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class ChangePasswordParams {
  final String userId;
  final ChangePasswordRequest request;
  const ChangePasswordParams({required this.userId, required this.request});
}

@LazySingleton()
class ChangePasswordUseCase implements UseCase<bool, ChangePasswordParams> {
  final AuthRepository _repository;

  ChangePasswordUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  FutureBool call(ChangePasswordParams params) =>
      _repository.changePassword(params.userId, params.request);
}
