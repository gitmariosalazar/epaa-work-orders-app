import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

class RefreshTokenParams {
  final String refreshToken;
  const RefreshTokenParams({required this.refreshToken});
}

@LazySingleton()
class RefreshTokenUseCase implements UseCase<UserData, RefreshTokenParams> {
  final AuthRepository _repository;

  RefreshTokenUseCase({required AuthRepository repository})
    : _repository = repository;

  @override
  FutureData<UserData> call(RefreshTokenParams params) =>
      _repository.refreshToken(params.refreshToken);
}
