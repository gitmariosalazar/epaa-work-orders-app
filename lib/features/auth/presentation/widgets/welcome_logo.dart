import 'package:flutter/material.dart';
import 'package:clean_architecture/core/constants/app_colors.dart'; // Ajusta la ruta si es necesario
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart'; // Ruta a tu ResponsiveUtils + Extension
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart'; // Mantengo tu BaseText si lo usas

class WelcomeLogo extends StatelessWidget {
  final String title;

  const WelcomeLogo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Tamaño del logo adaptado al dispositivo
    final double logoSize = context.isMobileSmall
        ? 120
        : context.isMobileMedium
        ? 140
        : context.isTablet
        ? 180
        : 200;

    // Espaciado responsivo
    final double bottomMargin = context.mediumSpacing * 1.5;
    final double logoPadding = context.isTablet ? 24 : 16;

    return Column(
      children: [
        // Logo con sombra circular
        Container(
          height: logoSize + logoPadding * 2, // Contenedor incluye padding
          margin: EdgeInsets.only(bottom: bottomMargin),
          child: Material(
            elevation: context.cardElevation,
            shape: const CircleBorder(),
            color: Colors.white,
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: EdgeInsets.all(logoPadding),
              child: Image.asset(
                'assets/images/epaa.png',
                height: logoSize * 0.8,
                width: logoSize * 0.8,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.water_drop_rounded,
                    size: logoSize * 0.8,
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ),
          ),
        ),

        // Texto "Bienvenido de nuevo"
        Text(
          'Bienvenido de nuevo',
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        context.vSpace(0.015), // Espacio responsivo
        // Texto "Inicie sesión para continuar"
        Text(
          'Inicie sesión para continuar',
          style: context.bodyLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),

        // Título personalizado (usando tu BaseText)
        Align(
          alignment: Alignment.centerLeft,
          child: BaseText.titleMedium(title, color: AppColors.blackE1),
        ),
      ],
    );
  }
}
