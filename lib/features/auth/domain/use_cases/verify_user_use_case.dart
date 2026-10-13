import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/verify_user_result.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class VerifyUserParams {
  final String usernameOrEmail;
  const VerifyUserParams({required this.usernameOrEmail});
}

@LazySingleton()
class VerifyUserUseCase implements UseCase<VerifyUserResult, VerifyUserParams> {
  final AuthRepository _repository;

  VerifyUserUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  FutureData<VerifyUserResult> call(VerifyUserParams params) =>
      _repository.verifyUser(params.usernameOrEmail);
}
