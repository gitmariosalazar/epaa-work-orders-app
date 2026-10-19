import 'package:flutter/material.dart';

/// Ajusta GLOBALMENTE los SnackBars de todo el contenido de un shell que
/// tiene una barra de navegación flotante superpuesta (Stack).
///
///  - SRP: sólo resuelve la posición de los SnackBars bajo el shell.
///  - OCP: cualquier shell lo reutiliza indicando sus medidas.
///  - Las pantallas no necesitan conocer la barra inferior (bajo acoplamiento).
///
/// Los SnackBars que ya definen `margin` propio respetan su valor.
class BottomNavSnackBarScope extends StatelessWidget {
  /// Altura de la barra flotante.
  final double navigationHeight;

  /// Espacio que el contenido ya reserva bajo él (padding inferior).
  final double reservedBottom;

  /// Separación visual extra entre el SnackBar y la barra.
  final double gap;

  final Widget child;

  const BottomNavSnackBarScope({
    super.key,
    required this.navigationHeight,
    required this.reservedBottom,
    required this.child,
    this.gap = 12,
  });

  /// Parte de la barra que se superpone al contenido.
  double get _overlap =>
      (navigationHeight - reservedBottom).clamp(0, double.infinity).toDouble();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        snackBarTheme: theme.snackBarTheme.copyWith(
          behavior: SnackBarBehavior.floating,
          insetPadding: EdgeInsets.fromLTRB(16, 0, 16, _overlap + gap),
        ),
      ),
      child: child,
    );
  }
}
