import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/features/auth/domain/models/requests/change_password_request.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:injectable/injectable.dart';
import 'change_password_state.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit({required this.changePasswordUseCase})
    : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    if (newPassword != confirmNewPassword) {
      emit(const ChangePasswordFailure("Las contraseñas nuevas no coinciden"));
      return;
    }

    emit(ChangePasswordLoading());

    final request = ChangePasswordRequest(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );

    final params = ChangePasswordParams(userId: userId, request: request);

    final result = await changePasswordUseCase(params);

    result.when(
      success: (_) => emit(ChangePasswordSuccess()),
      failure: (message, _) => emit(ChangePasswordFailure(message ?? "Ocurrió un error")),
      loading: () => emit(ChangePasswordLoading()),
    );
  }
}
