// shared_ui/ui/base/app_bar/base_app_bar.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AppBar global y reutilizable adaptable a Light y Dark Theme.
/// Implementa [PreferredSizeWidget] para ser usado tanto en [BaseScaffold]
/// como directamente en cualquier [Scaffold] estándar de Flutter.
///
/// Cumple con los principios SOLID:
/// - SRP: Responsabilidad única de construir y estilizar la barra de navegación superior.
/// - OCP: Abierto a extensión mediante parámetros opcionales y constructores factory (transparent, withBorder).
/// - LSP: Sustituible por cualquier PreferredSizeWidget o AppBar en la UI.
/// - ISP: Interfaces limpias y argumentos opcionales con defaults semánticos.
/// - DIP: Depende de abstracciones de Theme y ColorScheme en lugar de colores fijos.
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;
  final String? title;
  final String? subtitle;
  final Widget? titleWidget;
  final FontWeight? titleFontWeight;
  final TextStyle? titleStyle;
  final bool? centerTitle;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool showBottomBorder;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? height;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? leadingWidth;
  final double? titleSpacing;

  const BaseAppBar({
    super.key,
    this.showLeading = true,
    this.leading,
    this.onLeadingPressed,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.titleFontWeight,
    this.titleStyle,
    this.centerTitle = false,
    this.actions,
    this.bottom,
    this.showBottomBorder = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.height,
    this.systemOverlayStyle,
    this.leadingWidth,
    this.titleSpacing,
  });

  /// Factory para AppBars transparentes (por ej. en Dashboards, mapas o pantallas hero)
  factory BaseAppBar.transparent({
    Key? key,
    bool showLeading = true,
    Widget? leading,
    VoidCallback? onLeadingPressed,
    String? title,
    String? subtitle,
    Widget? titleWidget,
    FontWeight? titleFontWeight,
    TextStyle? titleStyle,
    bool? centerTitle = false,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
    bool showBottomBorder = false,
    Color? foregroundColor,
  }) => BaseAppBar(
    key: key,
    showLeading: showLeading,
    leading: leading,
    onLeadingPressed: onLeadingPressed,
    title: title,
    subtitle: subtitle,
    titleWidget: titleWidget,
    titleFontWeight: titleFontWeight,
    titleStyle: titleStyle,
    centerTitle: centerTitle,
    actions: actions,
    bottom: bottom,
    showBottomBorder: showBottomBorder,
    backgroundColor: Colors.transparent,
    foregroundColor: foregroundColor,
    elevation: 0,
  );

  /// Factory para AppBars con línea divisoria inferior (por ej. Ajustes, detalles)
  factory BaseAppBar.withBorder({
    Key? key,
    bool showLeading = true,
    Widget? leading,
    VoidCallback? onLeadingPressed,
    String? title,
    String? subtitle,
    Widget? titleWidget,
    FontWeight? titleFontWeight,
    TextStyle? titleStyle,
    bool? centerTitle = false,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => BaseAppBar(
    key: key,
    showLeading: showLeading,
    leading: leading,
    onLeadingPressed: onLeadingPressed,
    title: title,
    subtitle: subtitle,
    titleWidget: titleWidget,
    titleFontWeight: titleFontWeight,
    titleStyle: titleStyle,
    centerTitle: centerTitle,
    actions: actions,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    showBottomBorder: true,
  );

  @override
  Size get preferredSize {
    final baseHeight = height ?? kToolbarHeight;
    final bottomHeight =
        bottom?.preferredSize.height ?? (showBottomBorder ? 1.0 : 0.0);
    return Size.fromHeight(baseHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final appBarTheme = theme.appBarTheme;

    // Colores semánticos adaptados según el tema
    final effectiveBackgroundColor =
        backgroundColor ??
        appBarTheme.backgroundColor ??
        (isDark ? const Color(0xFF0D1B2E) : AppColors.white);

    final effectiveForegroundColor =
        foregroundColor ??
        appBarTheme.foregroundColor ??
        (isDark ? const Color(0xFFE8F0FA) : AppColors.textPrimary);

    // Padding y dimensiones responsivas
    final double horizontalPadding = ScreenUtil.I.horizontalSpace;
    const double leadingIconSize = 25;
    final double calculatedLeadingWidth = showLeading
        ? horizontalPadding + leadingIconSize
        : 0;
    final double calculatedTitleSpacing = showLeading ? 8 : horizontalPadding;

    Widget? leadingWidget;
    if (showLeading) {
      if (leading != null) {
        leadingWidget = Padding(padding: UIHelpers.paddingLS, child: leading);
      } else {
        leadingWidget = Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            onPressed:
                onLeadingPressed ??
                () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).maybePop();
                  } else {
                    NavigationUtil.I.maybePopTop();
                  }
                },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 25,
              color: effectiveForegroundColor,
            ),
            style: IconButton.styleFrom(
              backgroundColor: effectiveForegroundColor.withValues(alpha: 0.08),
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              fixedSize: const Size(40, 40),
              splashFactory: InkRipple.splashFactory,
            ),
            tooltip: 'Atrás',
          ),
        );
      }
    }

    Widget? effectiveTitleWidget;
    if (titleWidget != null) {
      effectiveTitleWidget = titleWidget;
    } else if (title != null && title!.isNotEmpty) {
      final defaultTitleStyle = TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: titleFontWeight ?? FontWeight.w600,
        color: effectiveForegroundColor,
      );

      if (subtitle != null && subtitle!.isNotEmpty) {
        effectiveTitleWidget = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: centerTitle == true
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              style: titleStyle ?? defaultTitleStyle,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDark
                    ? colorScheme.onSurfaceVariant
                    : AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      } else {
        effectiveTitleWidget = Text(
          title!,
          style: titleStyle ?? defaultTitleStyle,
          overflow: TextOverflow.ellipsis,
        );
      }
    }

    // Resolver línea divisoria inferior si se solicita
    PreferredSizeWidget? effectiveBottom = bottom;
    if (effectiveBottom == null && showBottomBorder) {
      effectiveBottom = PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: isDark
              ? colorScheme.outlineVariant
              : AppColors.border.withValues(alpha: 0.6),
          height: 1,
        ),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      leadingWidth: leadingWidth ?? calculatedLeadingWidth,
      titleSpacing: titleSpacing ?? calculatedTitleSpacing,
      title: effectiveTitleWidget,
      centerTitle: centerTitle ?? false,
      actions: actions,
      bottom: effectiveBottom,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle:
          systemOverlayStyle ??
          (isDark
              ? const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                )
              : const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                )),
      iconTheme: IconThemeData(color: effectiveForegroundColor),
      actionsIconTheme: IconThemeData(color: effectiveForegroundColor),
    );
  }
}
