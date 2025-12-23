import 'dart:math';

import 'package:flutter/material.dart';

enum DeviceType { mobileSmall, mobileMedium, mobileLarge, tablet, desktop }

class ResponsiveUtils {
  // === BREAKPOINTS (igual que el avanzado) ===
  static const double mobileSmallBreakpoint = 360;
  static const double mobileMediumBreakpoint = 540;
  static const double mobileLargeBreakpoint = 720;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // === DETECCIÓN DE DISPOSITIVO (compatible con tu código actual + desktop) ===
  static DeviceType deviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint) return DeviceType.desktop;
    if (width >= tabletBreakpoint) return DeviceType.tablet;
    if (width >= mobileLargeBreakpoint) return DeviceType.mobileLarge;
    if (width >= mobileMediumBreakpoint) return DeviceType.mobileMedium;
    return DeviceType.mobileSmall;
  }

  static bool isDesktop(BuildContext context) =>
      deviceType(context) == DeviceType.desktop;
  static bool isTablet(BuildContext context) =>
      deviceType(context) == DeviceType.tablet;
  static bool isMobileLarge(BuildContext context) =>
      deviceType(context) == DeviceType.mobileLarge;
  static bool isMobileMedium(BuildContext context) =>
      deviceType(context) == DeviceType.mobileMedium;
  static bool isMobileSmall(BuildContext context) =>
      deviceType(context) == DeviceType.mobileSmall;
  static bool isMobile(BuildContext context) =>
      !isTablet(context) && !isDesktop(context);
  static bool isSmallDevice(BuildContext context) =>
      isMobileSmall(context) || isMobileMedium(context);
  static bool isLargeDevice(BuildContext context) =>
      isTablet(context) || isDesktop(context);

  static Orientation getOrientation(BuildContext context) =>
      MediaQuery.of(context).orientation;
  static bool isLandscape(BuildContext context) =>
      getOrientation(context) == Orientation.landscape;
  static bool isPortrait(BuildContext context) =>
      getOrientation(context) == Orientation.portrait;

  // === TAMAÑOS DE PANTALLA ===
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double getSafeWidth(BuildContext context) =>
      width(context) - MediaQuery.of(context).padding.horizontal;
  static double getSafeHeight(BuildContext context) =>
      height(context) - MediaQuery.of(context).padding.vertical;

  // === ESCALADO DINÁMICO ===
  static double scaleWidth(
    BuildContext context,
    double factor, {
    double? min,
    double? max,
  }) {
    final width = ResponsiveUtils.width(context);
    final dpr = MediaQuery.of(context).devicePixelRatio.clamp(1.0, 3.0);
    var scaled = (width * factor) / dpr;
    if (min != null) scaled = scaled.clamp(min, double.infinity);
    if (max != null) scaled = scaled.clamp(double.negativeInfinity, max);
    return scaled;
  }

  static double scaleHeight(
    BuildContext context,
    double factor, {
    double? min,
    double? max,
  }) {
    final height = ResponsiveUtils.height(context);
    final dpr = MediaQuery.of(context).devicePixelRatio.clamp(1.0, 3.0);
    var scaled = (height * factor) / dpr;
    if (min != null) scaled = scaled.clamp(min, double.infinity);
    if (max != null) scaled = scaled.clamp(double.negativeInfinity, max);
    return scaled;
  }

  static double scalePercentWidth(BuildContext context, double percent) =>
      getSafeWidth(context) * (percent / 100);

  static double scalePercentHeight(BuildContext context, double percent) =>
      getSafeHeight(context) * (percent / 100);

  static double scaleDiagonal(BuildContext context, double factor) {
    final size = screenSize(context);
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    return diagonal * factor;
  }

  // === ESPACIADORES (como Widget) ===
  static Widget hSpace(BuildContext context, double factor) =>
      SizedBox(width: scaleWidth(context, factor));
  static Widget vSpace(BuildContext context, double factor) =>
      SizedBox(height: scaleHeight(context, factor));

  // === PADDING ===
  static EdgeInsets screenPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: scaleWidth(context, 0.04),
    vertical: scaleHeight(context, 0.02),
  );

  static EdgeInsets cardPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: scaleWidth(context, 0.03),
    vertical: scaleHeight(context, 0.015),
  );

  static EdgeInsets buttonPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: scaleWidth(context, 0.05),
    vertical: scaleHeight(context, 0.02),
  );

  static EdgeInsets dialogPadding(BuildContext context) =>
      EdgeInsets.all(scaleWidth(context, 0.05));

  // === TIPOGRAFÍA ===
  static TextStyle _getTextStyle(
    BuildContext context, {
    required double baseSize,
    FontWeight? weight,
    double letterSpacing = 0.0,
    double height = 1.2,
    Color? color,
  }) {
    final scale = _getFontScale(context, baseSize);
    final textScaleFactor = MediaQuery.of(
      context,
    ).textScaler.scale(1.0).clamp(0.8, 1.5);
    return TextStyle(
      fontSize: scale * textScaleFactor,
      fontWeight: weight ?? FontWeight.normal,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static double _getFontScale(BuildContext context, double baseSize) {
    final width = ResponsiveUtils.width(context);
    const minWidth = 320.0;
    const maxWidth = 1200.0;
    const minScale = 0.8;
    const maxScale = 1.1;

    final ratio = ((width - minWidth) / (maxWidth - minWidth)).clamp(0.0, 1.0);
    var scale = minScale + (maxScale - minScale) * ratio;

    if (isTablet(context)) scale = scale.clamp(0.95, 1.05);
    if (isDesktop(context)) scale *= 1.1;

    return (baseSize * scale).roundToDouble();
  }

  // === ESTILOS DE TEXTO (todos los que ya usas) ===
  static TextStyle titleLarge(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 22 : 26,
    weight: FontWeight.w700,
  );

  static TextStyle titleMedium(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 18 : 20,
    weight: FontWeight.w600,
  );

  static TextStyle titleSmall(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 16 : 18,
    weight: FontWeight.w600,
  );

  static TextStyle titleExtraSmall(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 12 : 14,
    weight: FontWeight.w600,
  );

  static TextStyle bodyLarge(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 14 : 16,
    weight: FontWeight.w500,
  );

  static TextStyle bodyMedium(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 12 : 14,
    weight: FontWeight.w400,
  );

  static TextStyle bodySmall(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 10 : 12,
    weight: FontWeight.w400,
  );

  static TextStyle buttonText(BuildContext context) => _getTextStyle(
    context,
    baseSize: isSmallDevice(context) ? 14 : 16,
    weight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // === ELEVACIONES ===
  static double cardElevation(BuildContext context) =>
      isSmallDevice(context) ? 2.0 : 4.0;

  // === ALTURAS DE BOTONES ===
  static double buttonHeight(BuildContext context) =>
      scaleHeight(context, 0.07).clamp(44.0, 56.0);

  static double buttonExtraSmall(BuildContext context) =>
      scaleHeight(context, 0.03).clamp(32.0, 40.0);
  static double buttonSmallMedium(BuildContext context) =>
      scaleHeight(context, 0.04).clamp(36.0, 44.0);
  static double buttonSmall(BuildContext context) =>
      scaleHeight(context, 0.05).clamp(40.0, 48.0);
  static double buttonLarge(BuildContext context) =>
      scaleHeight(context, 0.09).clamp(48.0, 56.0);
  static double buttonExtraLarge(BuildContext context) =>
      scaleHeight(context, 0.11).clamp(56.0, 64.0);

  // === TAMAÑOS DE ÍCONOS ===
  static double iconExtraSmall(BuildContext context) =>
      scaleWidth(context, 0.07);
  static double iconSmall(BuildContext context) => scaleWidth(context, 0.09);
  static double iconMedium(BuildContext context) => scaleWidth(context, 0.12);
  static double iconLarge(BuildContext context) => scaleWidth(context, 0.15);

  // === BORDER RADIUS ===
  static double cardBorderRadius(BuildContext context) =>
      scaleWidth(context, 0.03);
  static double buttonBorderRadius(BuildContext context) =>
      scaleWidth(context, 0.04);

  static double extraSmallBorderRadiusValue(BuildContext context) =>
      scaleWidth(context, 0.015);
  static double smallBorderRadiusValue(BuildContext context) =>
      scaleWidth(context, 0.025);
  static double mediumBorderRadiusValue(BuildContext context) =>
      scaleWidth(context, 0.03);
  static double largeBorderRadiusValue(BuildContext context) =>
      scaleWidth(context, 0.04);

  static double cardBorderRadiusValue(BuildContext context) =>
      cardBorderRadius(context);
  static double buttonBorderRadiusValue(BuildContext context) =>
      buttonBorderRadius(context);

  // === ESPACIADO ===
  static double extraSmallSpacing(BuildContext context) =>
      scaleWidth(context, 0.008);
  static double smallSpacing(BuildContext context) =>
      scaleWidth(context, 0.015);
  static double mediumSpacing(BuildContext context) =>
      scaleWidth(context, 0.03);
  static double largeSpacing(BuildContext context) => scaleWidth(context, 0.05);

  // === SECTION ===
  static double sectionDividerHeight(BuildContext context) =>
      scaleHeight(context, 0.025);
  static double sectionTitleSpacing(BuildContext context) =>
      scaleHeight(context, 0.05);

  // === SAFE AREA ===
  static EdgeInsets getSafeAreaInsets(BuildContext context) =>
      MediaQuery.of(context).padding;
  static double getBottomSafeArea(BuildContext context) =>
      getSafeAreaInsets(context).bottom;
  static double getTopSafeArea(BuildContext context) =>
      getSafeAreaInsets(context).top;
}

// === EXTENSIÓN EN BuildContext (con TODOS los nombres que ya usas) ===
extension ResponsiveExtension on BuildContext {
  DeviceType get deviceType => ResponsiveUtils.deviceType(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isSmallDevice => ResponsiveUtils.isSmallDevice(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get isMobileLarge => ResponsiveUtils.isMobileLarge(this);
  bool get isMobileMedium => ResponsiveUtils.isMobileMedium(this);
  bool get isMobileSmall => ResponsiveUtils.isMobileSmall(this);
  bool get isLargeDevice => ResponsiveUtils.isLargeDevice(this);
  bool get isLandscape => ResponsiveUtils.isLandscape(this);
  bool get isPortrait => ResponsiveUtils.isPortrait(this);

  Size get screenSize => ResponsiveUtils.screenSize(this);
  double get width => ResponsiveUtils.width(this);
  double get height => ResponsiveUtils.height(this);

  Widget hSpace(double f) => ResponsiveUtils.hSpace(this, f);
  Widget vSpace(double f) => ResponsiveUtils.vSpace(this, f);

  EdgeInsets get screenPadding => ResponsiveUtils.screenPadding(this);
  EdgeInsets get cardPadding => ResponsiveUtils.cardPadding(this);

  TextStyle get titleLarge => ResponsiveUtils.titleLarge(this);
  TextStyle get titleMedium => ResponsiveUtils.titleMedium(this);
  TextStyle get titleSmall => ResponsiveUtils.titleSmall(this);
  TextStyle get titleExtraSmall => ResponsiveUtils.titleExtraSmall(this);
  TextStyle get bodyLarge => ResponsiveUtils.bodyLarge(this);
  TextStyle get bodyMedium => ResponsiveUtils.bodyMedium(this);
  TextStyle get bodySmall => ResponsiveUtils.bodySmall(this);
  TextStyle get buttonText => ResponsiveUtils.buttonText(this);

  double get iconExtraSmall => ResponsiveUtils.iconExtraSmall(this);
  double get iconSmall => ResponsiveUtils.iconSmall(this);
  double get iconMedium => ResponsiveUtils.iconMedium(this);
  double get iconLarge => ResponsiveUtils.iconLarge(this);

  double get extraSmallSpacing => ResponsiveUtils.extraSmallSpacing(this);
  double get smallSpacing => ResponsiveUtils.smallSpacing(this);
  double get mediumSpacing => ResponsiveUtils.mediumSpacing(this);
  double get largeSpacing => ResponsiveUtils.largeSpacing(this);

  double get cardBorderRadiusValue =>
      ResponsiveUtils.cardBorderRadiusValue(this);
  double get buttonBorderRadiusValue =>
      ResponsiveUtils.buttonBorderRadiusValue(this);
  double get extraSmallBorderRadiusValue =>
      ResponsiveUtils.extraSmallBorderRadiusValue(this);
  double get smallBorderRadiusValue =>
      ResponsiveUtils.smallBorderRadiusValue(this);
  double get mediumBorderRadiusValue =>
      ResponsiveUtils.mediumBorderRadiusValue(this);
  double get largeBorderRadiusValue =>
      ResponsiveUtils.largeBorderRadiusValue(this);

  double get cardElevation => ResponsiveUtils.cardElevation(this);
  double get buttonHeight => ResponsiveUtils.buttonHeight(this);
  double get sectionDividerHeight => ResponsiveUtils.sectionDividerHeight(this);
  double get sectionTitleSpacing => ResponsiveUtils.sectionTitleSpacing(this);

  double get bottomSafeArea => ResponsiveUtils.getBottomSafeArea(this);
  double get topSafeArea => ResponsiveUtils.getTopSafeArea(this);

  TextStyle get headlineLarge => titleLarge;
  TextStyle get headlineMedium => titleMedium;
  TextStyle get headlineSmall => titleSmall;
}
