import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_checkbox.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/base_text_button.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginOptional extends StatelessWidget {
  final bool saveUserCredential;

  const LoginOptional({super.key, required this.saveUserCredential});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Row(
        children: [
          // Checkbox con texto que se envuelve automáticamente
          Expanded(
            child: Row(
              children: [
                BaseCheckbox(
                  value: saveUserCredential,
                  onChanged: (value) =>
                      context.read<LoginCubit>().toggleUserCredentialSaving(),
                ),
                context.hSpace(0.02),
                Expanded(
                  child: BaseText(
                    "Mantener sesión iniciada",
                    textType: TextType.bodySmall,
                    fontWeight: FontWeight.w500,
                    overflow:
                        TextOverflow.ellipsis, // Evita overflow si es muy largo
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),

          // Botón "Olvidaste tu contraseña?"
          BaseTextButton(
            onPressed: () {
              // TODO: Navegar a recuperación de contraseña
            },
            text: "¿Olvidaste tu contraseña?",
            fontWeight: FontWeight.w500,
            textColor: Theme.of(context).colorScheme.primary,
            textType: TextType.bodySmall,
          ),
        ],
      ),
    );
  }
}
