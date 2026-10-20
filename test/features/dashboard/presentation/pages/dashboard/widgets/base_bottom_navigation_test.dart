import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/dashboard/widgets/base_bottom_navigation.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardCubit extends Mock implements DashboardCubit {}

void main() {
  late MockDashboardCubit mockDashboardCubit;

  setUp(() {
    mockDashboardCubit = MockDashboardCubit();
    when(() => mockDashboardCubit.state).thenReturn(const DashboardState(activeIndex: 0));
    when(() => mockDashboardCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildWidget({required ThemeData theme, int activeIndex = 0}) {
    when(() => mockDashboardCubit.state).thenReturn(DashboardState(activeIndex: activeIndex));

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: const BaseBottomNavigation(),
        ),
      ),
    );
  }

  testWidgets('renders all 5 navigation tabs and labels', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Órdenes'), findsOneWidget);
    expect(find.text('Trabaj...'), findsOneWidget);
    expect(find.text('Productos'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });

  testWidgets('adapts decoration and colors in Light Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme, activeIndex: 0));

    // Verificar color de fondo del Container en Light Theme
    final containerFinder = find.byType(Container).first;
    final Container container = tester.widget(containerFinder);
    final BoxDecoration decoration = container.decoration as BoxDecoration;

    expect(decoration.color, lightTheme.colorScheme.surface);

    // Verificar que el ícono activo (índice 0) tiene el color primario del light theme
    final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
    expect(homeIcon.color, lightTheme.colorScheme.primary);

    // Verificar que el ícono inactivo (índice 1) tiene el color inactivo
    final ordersIcon = tester.widget<Icon>(find.byIcon(Icons.construction));
    expect(ordersIcon.color, isNot(lightTheme.colorScheme.primary));
  });

  testWidgets('adapts decoration and colors in Dark Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: darkTheme, activeIndex: 1));

    // Verificar color de fondo del Container en Dark Theme
    final containerFinder = find.byType(Container).first;
    final Container container = tester.widget(containerFinder);
    final BoxDecoration decoration = container.decoration as BoxDecoration;

    // En Dark Theme debe usar surfaceContainerHighest
    expect(decoration.color, darkTheme.colorScheme.surfaceContainerHighest);

    // Verificar que el ítem activo (índice 1, Órdenes) usa darkTheme.colorScheme.primary
    final ordersIcon = tester.widget<Icon>(find.byIcon(Icons.construction));
    expect(ordersIcon.color, darkTheme.colorScheme.primary);

    // Verificar que el ícono inactivo (índice 0, Inicio) usa el color inactivo dark (onSurfaceVariant)
    final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
    expect(homeIcon.color, darkTheme.colorScheme.onSurfaceVariant);
  });

  testWidgets('tapping a navigation item invokes DashboardCubit.setIndex', (tester) async {
    when(() => mockDashboardCubit.setIndex(any())).thenReturn(null);

    await tester.pumpWidget(buildWidget(theme: lightTheme, activeIndex: 0));

    // Tap en Órdenes (índice 1)
    await tester.tap(find.text('Órdenes'));
    await tester.pumpAndSettle();

    verify(() => mockDashboardCubit.setIndex(1)).called(1);

    // Tap en Perfil (índice 4)
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    verify(() => mockDashboardCubit.setIndex(4)).called(1);
  });
}
