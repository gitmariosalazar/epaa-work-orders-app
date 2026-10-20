part of 'theme.dart';

/// Light Color Scheme
ColorScheme get colorScheme => ColorScheme.fromSeed(
  seedColor: AppColors.primary,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  error: AppColors.error,
);

/// Dark Color Scheme
ColorScheme get darkColorScheme {
  const bgDeep = Color(0xFF060D19);
  const onBg = Color(0xFFE8F0FA);
  const bgSurface = Color(0xFF112035);
  const border = Color(0xFF1E3350);

  return const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF00BFFF),
    onPrimary: Color(0xFF0A1628),
    primaryContainer: Color(0xFF003A5C),
    onPrimaryContainer: Color(0xFF00BFFF),
    secondary: Color(0xFF1EB980),
    onSecondary: Color(0xFF003824),
    secondaryContainer: Color(0xFF00522E),
    onSecondaryContainer: Color(0xFFACF2CA),
    tertiary: Color(0xFFFFC107),
    onTertiary: Color(0xFF3D2900),
    tertiaryContainer: Color(0xFF573D00),
    onTertiaryContainer: Color(0xFFFFE082),
    error: Color(0xFFFF8A80),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: bgDeep,
    onSurface: onBg,
    surfaceContainerHighest: bgSurface,
    onSurfaceVariant: Color(0xFF8BA4BE),
    outline: border,
    outlineVariant: Color(0xFF1A2F48),
    inverseSurface: onBg,
    onInverseSurface: bgDeep,
    inversePrimary: Color(0xFF1565C0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );
}

/// App Bar Theme (Light)
AppBarTheme get appBarTheme => const AppBarTheme(
  backgroundColor: AppColors.white,
  foregroundColor: AppColors.textPrimary,
  surfaceTintColor: Colors.transparent,
  iconTheme: IconThemeData(color: AppColors.textPrimary),
  actionsIconTheme: IconThemeData(color: AppColors.textPrimary),
  elevation: 0,
  titleTextStyle: TextStyle(
    fontFamily: "Poppins",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  ),
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: AppColors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ),
);

/// App Bar Theme (Dark)
AppBarTheme get darkAppBarTheme => const AppBarTheme(
  backgroundColor: Color(0xFF0D1B2E),
  foregroundColor: Color(0xFFE8F0FA),
  surfaceTintColor: Colors.transparent,
  iconTheme: IconThemeData(color: Color(0xFFE8F0FA)),
  actionsIconTheme: IconThemeData(color: Color(0xFFE8F0FA)),
  elevation: 0,
  titleTextStyle: TextStyle(
    fontFamily: "Poppins",
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFFE8F0FA),
  ),
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Color(0xFF0D1B2E),
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ),
);

/// InputDecoration Theme
OutlineInputBorder outlinedInputBorder(Color color) => OutlineInputBorder(
  borderRadius: UIHelpers.radiusC12,
  borderSide: BorderSide(color: color, width: 2),
);

InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
  hintStyle: const TextStyle(color: AppColors.fade, fontSize: 14),
  enabledBorder: outlinedInputBorder(AppColors.border),
  focusedBorder: outlinedInputBorder(AppColors.primary),
  errorBorder: outlinedInputBorder(AppColors.red600),
  focusedErrorBorder: outlinedInputBorder(AppColors.red600),
);

InputDecorationTheme get darkInputDecorationTheme => InputDecorationTheme(
  hintStyle: const TextStyle(color: Color(0xFF5A7FA0), fontSize: 14),
  enabledBorder: outlinedInputBorder(const Color(0xFF1E3350)),
  focusedBorder: outlinedInputBorder(const Color(0xFF00BFFF)),
  errorBorder: outlinedInputBorder(const Color(0xFFFF8A80)),
  focusedErrorBorder: outlinedInputBorder(const Color(0xFFFF8A80)),
);

/// CheckBox Theme
CheckboxThemeData get checkBoxThemeData => CheckboxThemeData(
  visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
  shape: RoundedRectangleBorder(borderRadius: UIHelpers.radiusC4),
);

/// ListTile Theme (Light)
ListTileThemeData get listTileThemeData => const ListTileThemeData(
  dense: true,
  contentPadding: EdgeInsets.zero,
  minVerticalPadding: 1,
  horizontalTitleGap: 0,
  minLeadingWidth: 0,
);

/// ListTile Theme (Dark)
ListTileThemeData get darkListTileThemeData => const ListTileThemeData(
  dense: true,
  contentPadding: EdgeInsets.zero,
  minVerticalPadding: 1,
  horizontalTitleGap: 0,
  minLeadingWidth: 0,
  tileColor: Colors.transparent,
);
