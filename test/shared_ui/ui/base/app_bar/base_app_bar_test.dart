import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    final screenDetails = ScreenDetails(
      logicalSize: const Size(800, 600),
      physicalSize: const Size(800, 600),
      devicePixelRatio: 1,
    );
    ScreenUtil.I.configureScreen(screenDetails);
  });

  Widget buildWidget({required ThemeData theme, required PreferredSizeWidget appBar}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: appBar,
        body: const Center(child: Text('Content')),
      ),
    );
  }

  testWidgets('renders BaseAppBar with title and default back button', (tester) async {
    await tester.pumpWidget(buildWidget(
      theme: lightTheme,
      appBar: const BaseAppBar(title: 'Mi Pantalla'),
    ));

    expect(find.text('Mi Pantalla'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byTooltip('Atrás'), findsOneWidget);
  });

  testWidgets('adapts colors correctly in Light Theme', (tester) async {
    await tester.pumpWidget(buildWidget(
      theme: lightTheme,
      appBar: const BaseAppBar(title: 'Modo Claro'),
    ));

    final appBarFinder = find.byType(AppBar);
    final AppBar appBar = tester.widget(appBarFinder);

    expect(appBar.backgroundColor, AppColors.white);
    expect(appBar.foregroundColor, AppColors.textPrimary);

    // El título usa el color del foreground (textPrimary)
    final titleText = tester.widget<Text>(find.text('Modo Claro'));
    expect(titleText.style?.color, AppColors.textPrimary);
  });

  testWidgets('adapts colors correctly in Dark Theme', (tester) async {
    await tester.pumpWidget(buildWidget(
      theme: darkTheme,
      appBar: const BaseAppBar(title: 'Modo Oscuro'),
    ));

    final appBarFinder = find.byType(AppBar);
    final AppBar appBar = tester.widget(appBarFinder);

    expect(appBar.backgroundColor, const Color(0xFF0D1B2E));
    expect(appBar.foregroundColor, const Color(0xFFE8F0FA));

    // El título y el ícono de retroceso usan el color claro de dark theme
    final titleText = tester.widget<Text>(find.text('Modo Oscuro'));
    expect(titleText.style?.color, const Color(0xFFE8F0FA));
  });

  testWidgets('supports actions, custom leading, and onLeadingPressed callback', (tester) async {
    bool leadingPressed = false;
    bool actionPressed = false;

    await tester.pumpWidget(buildWidget(
      theme: lightTheme,
      appBar: BaseAppBar(
        title: 'Acciones',
        onLeadingPressed: () => leadingPressed = true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => actionPressed = true,
          ),
        ],
      ),
    ));

    expect(find.byIcon(Icons.refresh), findsOneWidget);

    // Tap en botón de retroceso personalizado
    await tester.tap(find.byTooltip('Atrás'));
    await tester.pumpAndSettle();
    expect(leadingPressed, isTrue);

    // Tap en acción
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
    expect(actionPressed, isTrue);
  });

  testWidgets('BaseAppBar.transparent factory creates transparent bar with 0 elevation', (tester) async {
    await tester.pumpWidget(buildWidget(
      theme: lightTheme,
      appBar: BaseAppBar.transparent(title: 'Transparente'),
    ));

    final appBarFinder = find.byType(AppBar);
    final AppBar appBar = tester.widget(appBarFinder);

    expect(appBar.backgroundColor, Colors.transparent);
    expect(appBar.elevation, 0);
  });

  testWidgets('BaseAppBar.withBorder factory renders bottom border and preferredSize reflects it', (tester) async {
    final borderAppBar = BaseAppBar.withBorder(title: 'Con Borde');
    expect(borderAppBar.preferredSize.height, kToolbarHeight + 1.0);

    await tester.pumpWidget(buildWidget(
      theme: darkTheme,
      appBar: borderAppBar,
    ));

    final appBarFinder = find.byType(AppBar);
    final AppBar appBar = tester.widget(appBarFinder);
    expect(appBar.bottom, isNotNull);
  });
}
