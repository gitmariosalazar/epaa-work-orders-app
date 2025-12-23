// import 'dart:io';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginFormState> {
  final SessionService _sessionService;
  final LoginCubitUseCases _useCases;

  // Loading como propiedad privada (simple y efectivo)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginCubit({
    required SessionService sessionService,
    required LoginCubitUseCases useCases,
  }) : _sessionService = sessionService,
       _useCases = useCases,
       super(const LoginFormState());

  void _refreshState() {
    emit(
      LoginFormState(
        passwordVisibility: state.passwordVisibility,
        saveUserCredential: state.saveUserCredential,
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(passwordVisibility: !state.passwordVisibility));
  }

  void toggleUserCredentialSaving() {
    emit(state.copyWith(saveUserCredential: !state.saveUserCredential));
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _refreshState(); // Actualiza UI para mostrar loading

    final authentication = Authentication(
      username: username,
      password: password,
    );
    final dataState = await _useCases.login(authentication);

    showDataStateToast(dataState);

    if (dataState.hasData) {
      final userData = dataState.data!;

      _sessionService.setUserData = userData;

      if (state.saveUserCredential) {
        await _useCases.saveUserData(userData);
      }

      replaceAllRoute(const HomeRoute());
    }

    _isLoading = false;
    _refreshState(); // Quita loading
  }

  Future<void> fakeLogin({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _refreshState();

    await Future.delayed(const Duration(seconds: 2));

    final fakeUserData = UserData(
      accessToken: "fake_access_token_123",
      refreshToken: "fake_refresh_token_456",
      user: User(
        id: 1,
        firstName: "Flutter",
        lastName: "Developer",
        username: username,
        email: "$username@example.com",
        isActive: true,
      ),
    );

    _sessionService.setUserData = fakeUserData;

    if (state.saveUserCredential) {
      await _useCases.saveUserData(fakeUserData);
    }

    replaceAllRoute(const HomeRoute());

    _isLoading = false;
    _refreshState();
  }
}
