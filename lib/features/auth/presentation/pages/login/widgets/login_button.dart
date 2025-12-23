import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/widget_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginFormState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isLoading = cubit.isLoading;

        return SizedBox(
          width: double.infinity,
          child: ActionButton(
            icon: Icons.login_rounded,
            label: "INICIAR SESIÓN",
            tooltip: "Iniciar sesión en la aplicación",
            loading: isLoading,
            disabled: isLoading,
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              FocusManager.instance.primaryFocus?.unfocus();

              await cubit.fakeLogin(
                username: usernameController.text.trim(),
                password: passwordController.text,
              );
            },
            style: ActionButtonStyle.elevated,
            size: ActionButtonSize.large,
            circular: false,
          ),
        );
      },
    );
  }
}
