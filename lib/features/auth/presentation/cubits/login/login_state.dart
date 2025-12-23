part of 'login_cubit.dart';

// Estado base (si usas BaseCubit, manténlo)
abstract class BaseState extends Equatable {
  const BaseState();
}

// Estado del formulario (visibilidad y guardar credenciales)
class LoginFormState extends BaseState {
  final bool passwordVisibility;
  final bool saveUserCredential;

  const LoginFormState({
    this.passwordVisibility = false,
    this.saveUserCredential = false,
  });

  LoginFormState copyWith({
    bool? passwordVisibility,
    bool? saveUserCredential,
  }) {
    return LoginFormState(
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      saveUserCredential: saveUserCredential ?? this.saveUserCredential,
    );
  }

  @override
  List<Object> get props => [passwordVisibility, saveUserCredential];
}

// Estados del proceso de login
class LoginInitial extends BaseState {
  final LoginFormState form;

  const LoginInitial([this.form = const LoginFormState()]);

  @override
  List<Object> get props => [form];
}

class LoginLoading extends BaseState {
  final LoginFormState form;

  const LoginLoading(this.form);

  @override
  List<Object> get props => [form];
}

class LoginSuccess extends BaseState {
  final LoginFormState form;

  const LoginSuccess(this.form);

  @override
  List<Object> get props => [form];
}

class LoginFailure extends BaseState {
  final String error;
  final LoginFormState form;

  const LoginFailure(this.error, this.form);

  @override
  List<Object> get props => [error, form];
}
