import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/features/auth/presentation/pages/login/widgets/login_optional.dart';
import 'package:clean_architecture/shared_ui/ui/base/form/base_text_field.dart';
import 'package:clean_architecture/shared_ui/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginFormState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BaseTextField(
              controller: usernameController,
              hintText: "Enter your username",
              validator: Validators.username,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              prefixIcon: Icon(
                Icons.person_outline,
                size: context.iconLarge,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            context.vSpace(0.03),

            BaseTextField(
              hintText: "Enter your password",
              controller: passwordController,
              validator: Validators.password,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: !state.passwordVisibility,
              prefixIcon: Icon(
                Icons.lock_outline,
                size: context.iconLarge,
                color: Theme.of(context).colorScheme.primary,
              ),
              suffixIcon: InkWell(
                borderRadius: BorderRadius.circular(
                  context.smallBorderRadiusValue,
                ),
                onTap: cubit.togglePasswordVisibility,
                child: Icon(
                  state.passwordVisibility
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: context.iconLarge,
                  color: AppColors.black60,
                ),
              ),
            ),

            context.vSpace(0.04),

            LoginOptional(saveUserCredential: state.saveUserCredential),
          ],
        );
      },
    );
  }
}
