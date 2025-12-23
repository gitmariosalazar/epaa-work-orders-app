import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/features/auth/presentation/pages/login/widgets/login_button.dart';
import 'package:clean_architecture/features/auth/presentation/pages/login/widgets/login_form.dart';
import 'package:clean_architecture/features/auth/presentation/widgets/welcome_logo.dart';
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return BlocProvider(
      create: (context) => GetIt.I<LoginCubit>(),
      child: BlocBuilder<ScreenObserverCubit, ScreenObserverState>(
        builder: (context, state) {
          final double maxFormWidth = context.isMobile
              ? context.width * 0.9
              : context.isTablet
              ? 500
              : 600;

          return BaseScaffold(
            showAnnotatedRegion: true,
            body: SafeArea(
              child: Center(
                // Centro horizontal y ayuda al vertical
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.05,
                    vertical: context.height * 0.05,
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // ← Centrado vertical
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxFormWidth),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const WelcomeLogo(title: ""),
                            const SizedBox(height: 40),
                            Form(
                              key: formKey,
                              child: LoginForm(
                                usernameController: usernameController,
                                passwordController: passwordController,
                              ),
                            ),
                            const SizedBox(height: 24),
                            LoginButton(
                              formKey: formKey,
                              usernameController: usernameController,
                              passwordController: passwordController,
                            ),
                            // Espacio extra al final para que cuando abra el teclado no tape el botón
                            SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
