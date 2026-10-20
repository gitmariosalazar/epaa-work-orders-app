import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/dashboard_drawer.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardCubit extends Mock implements DashboardCubit {}

void main() {
  late MockDashboardCubit mockDashboardCubit;

  setUp(() {
    mockDashboardCubit = MockDashboardCubit();
    when(() => mockDashboardCubit.state)
        .thenReturn(const DashboardState(activeIndex: 0));
    when(() => mockDashboardCubit.stream).thenAnswer((_) => const Stream.empty());

    final screenDetails = ScreenDetails(
      logicalSize: const Size(1200, 800),
      physicalSize: const Size(1200, 800),
      devicePixelRatio: 1,
    );
    ScreenUtil.I.configureScreen(screenDetails);
  });

  Widget buildWidget({
    required ThemeData theme,
    int activeIndex = 0,
    List<DrawerNavigationItem>? items,
    ValueChanged<int>? onItemSelected,
  }) {
    when(() => mockDashboardCubit.state)
        .thenReturn(DashboardState(activeIndex: activeIndex));

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: DashboardDrawer(
            items: items,
            onItemSelected: onItemSelected,
          ),
        ),
      ),
    );
  }

  testWidgets('renders Dashboard title and all 5 default items', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Órdenes de Trabajo'), findsOneWidget);
    expect(find.text('Trabajadores'), findsOneWidget);
    expect(find.text('Productos'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });

  testWidgets('adapts decoration and colors in Light Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme, activeIndex: 0));

    // Verificar el fondo del Material en Light Theme
    final materialFinder = find.descendant(
      of: find.byType(DashboardDrawer),
      matching: find.byType(Material),
    ).first;
    final Material material = tester.widget(materialFinder);
    expect(material.color, lightTheme.colorScheme.surface);

    // Ícono y texto activo (índice 0, Inicio) usan el color primario de Light Theme
    final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
    expect(homeIcon.color, lightTheme.colorScheme.primary);

    final homeText = tester.widget<BaseText>(find.widgetWithText(BaseText, 'Inicio'));
    expect(homeText.color, lightTheme.colorScheme.primary);

    // Ícono inactivo (índice 1, Órdenes de Trabajo) no usa el color primario
    final ordersIcon = tester.widget<Icon>(find.byIcon(Icons.assignment));
    expect(ordersIcon.color, isNot(lightTheme.colorScheme.primary));
  });

  testWidgets('adapts decoration and colors in Dark Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: darkTheme, activeIndex: 1));

    // Verificar el fondo del Material en Dark Theme (debe ser surfaceContainerHighest)
    final materialFinder = find.descendant(
      of: find.byType(DashboardDrawer),
      matching: find.byType(Material),
    ).first;
    final Material material = tester.widget(materialFinder);
    expect(material.color, darkTheme.colorScheme.surfaceContainerHighest);

    // Ítem activo (índice 1, Órdenes de Trabajo) usa colorScheme.primary del dark theme
    final ordersIcon = tester.widget<Icon>(find.byIcon(Icons.assignment));
    expect(ordersIcon.color, darkTheme.colorScheme.primary);

    final ordersText = tester.widget<BaseText>(find.widgetWithText(BaseText, 'Órdenes de Trabajo'));
    expect(ordersText.color, darkTheme.colorScheme.primary);

    // Ítem inactivo (índice 0, Inicio) usa colorScheme.onSurfaceVariant
    final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
    expect(homeIcon.color, darkTheme.colorScheme.onSurfaceVariant);

    final homeText = tester.widget<BaseText>(find.widgetWithText(BaseText, 'Inicio'));
    expect(homeText.color, darkTheme.colorScheme.onSurfaceVariant);
  });

  testWidgets('tapping an item invokes DashboardCubit.setIndex', (tester) async {
    when(() => mockDashboardCubit.setIndex(any())).thenReturn(null);

    await tester.pumpWidget(buildWidget(theme: lightTheme, activeIndex: 0));

    // Tap en 'Órdenes de Trabajo' (índice 1)
    await tester.tap(find.text('Órdenes de Trabajo'));
    await tester.pumpAndSettle();

    verify(() => mockDashboardCubit.setIndex(1)).called(1);
  });

  testWidgets('supports custom items and custom onItemSelected callback (OCP & ISP)', (tester) async {
    int? selectedIndex;
    final customItems = [
      const DrawerNavigationItem(icon: Icons.dashboard, title: 'Panel Principal', index: 0),
      const DrawerNavigationItem(icon: Icons.settings, title: 'Ajustes', index: 1),
    ];

    await tester.pumpWidget(buildWidget(
      theme: lightTheme,
      items: customItems,
      onItemSelected: (index) => selectedIndex = index,
    ));

    expect(find.text('Panel Principal'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Trabajadores'), findsNothing);

    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
  });
}
