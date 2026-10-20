import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/work_order_card.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
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

  final testOrder = WorkOrderEntity(
    orderCode: 'OT-1001',
    workTypeId: 1,
    priorityId: 4, // Urgente
    clientId: 'CLI-01',
    location: 'Av. Principal 123',
    description: 'Fuga de agua en calzada',
    cadastralKey: '170101-9988',
    creationDate: DateTime(2026, 10, 15, 8, 30),
    status: 'PENDIENTE',
  );

  Widget buildWidget({required ThemeData theme, VoidCallback? onEdit}) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: WorkOrderCard(
            order: testOrder,
            onEdit: onEdit,
          ),
        ),
      ),
    );
  }

  testWidgets('renders all critical WorkOrderCard information', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));

    expect(find.text('OT Nº: OT-1001'), findsOneWidget);
    expect(find.text('ALCANTARILLADO'), findsOneWidget);
    expect(find.text('Fuga de agua en calzada'), findsOneWidget);
    expect(find.text('170101-9988'), findsOneWidget);
    expect(find.text('C.C:'), findsOneWidget);
    expect(find.text('F. de creación: 2026-10-15'), findsOneWidget);
    expect(find.text('Urgente'), findsOneWidget);
  });

  testWidgets('adapts decoration and typography in Light Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));

    // Card background en Light Theme
    final cardFinder = find.byType(Card);
    final Card card = tester.widget(cardFinder);
    expect(card.color, lightTheme.colorScheme.surface);

    // Color del código de orden
    final otText = tester.widget<Text>(find.text('OT Nº: OT-1001'));
    expect(otText.style?.color, lightTheme.colorScheme.primary);

    // Clave catastral y C.C: no deben ser Colors.black hardcodeado, deben tener contraste
    final ccText = tester.widget<Text>(find.text('C.C:'));
    expect(ccText.style?.color, isNotNull);
  });

  testWidgets('adapts decoration and typography in Dark Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: darkTheme));

    // Card background en Dark Theme debe ser surfaceContainerHighest
    final cardFinder = find.byType(Card);
    final Card card = tester.widget(cardFinder);
    expect(card.color, darkTheme.colorScheme.surfaceContainerHighest);

    // Color del código de orden en Dark Theme debe usar colorScheme.primary del dark theme (cian 0xFF00BFFF)
    final otText = tester.widget<Text>(find.text('OT Nº: OT-1001'));
    expect(otText.style?.color, darkTheme.colorScheme.primary);

    // C.C: y clave catastral NO deben ser Colors.black (deben ser legibles en dark mode)
    final ccText = tester.widget<Text>(find.text('C.C:'));
    expect(ccText.style?.color, isNot(Colors.black));
    expect(ccText.style?.color, darkTheme.colorScheme.onSurfaceVariant);

    final keyText = tester.widget<Text>(find.text('170101-9988'));
    expect(keyText.style?.color, isNot(Colors.black));
    expect(keyText.style?.color, darkTheme.colorScheme.onSurface);
  });

  testWidgets('pressing print button invokes onEdit callback', (tester) async {
    bool onEditCalled = false;

    await tester.pumpWidget(buildWidget(
      theme: lightTheme,
      onEdit: () => onEditCalled = true,
    ));

    final printButton = find.byTooltip('Imprimir orden');
    expect(printButton, findsOneWidget);

    await tester.tap(printButton);
    await tester.pumpAndSettle();

    expect(onEditCalled, isTrue);
  });
}
