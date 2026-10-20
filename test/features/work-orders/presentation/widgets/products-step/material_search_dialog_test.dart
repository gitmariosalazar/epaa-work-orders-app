import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/products/domain/entities/product_material_entity.dart';
import 'package:clean_architecture/features/products/domain/usecases/product_material_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/material_search_dialog.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/step_select_materials.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllProductMaterialsPaginatedUseCase extends Mock
    implements GetAllProductMaterialsPaginatedUseCase {}

void main() {
  late MockGetAllProductMaterialsPaginatedUseCase mockUseCase;

  final sampleMaterials = [
    ProductMaterialEntity(
      inventoryId: 1,
      companyCode: '1.0',
      accountCode: '1.0',
      itemCode: 'MAT-001',
      itemName: 'Tubo PVC 1/2 pulgada',
      itemStatus: 'A',
      minStock: 10,
      currentStock: 150,
      itemLevel: 1,
      avgCostValue: 4.50,
      itemType: 'M',
      unitOfMeasure: 'METROS',
      vatApplicable: 'N',
    ),
    ProductMaterialEntity(
      inventoryId: 2,
      companyCode: '1.0',
      accountCode: '1.0',
      itemCode: 'MAT-002',
      itemName: 'Abrazadera de 3/8',
      itemStatus: 'A',
      minStock: 20,
      currentStock: 50,
      itemLevel: 1,
      avgCostValue: 1.25,
      itemType: 'M',
      unitOfMeasure: 'UNIDAD',
      vatApplicable: 'N',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(
      ProductMaterialPaginatedParams(limit: 50, offset: 0),
    );
  });

  setUp(() {
    mockUseCase = MockGetAllProductMaterialsPaginatedUseCase();
    if (GetIt.I.isRegistered<GetAllProductMaterialsPaginatedUseCase>()) {
      GetIt.I.unregister<GetAllProductMaterialsPaginatedUseCase>();
    }
    GetIt.I.registerSingleton<GetAllProductMaterialsPaginatedUseCase>(
      mockUseCase,
    );

    when(
      () => mockUseCase.call(any()),
    ).thenAnswer((_) async => SuccessState(data: sampleMaterials));
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget buildWidget({required ThemeData theme}) {
    return MaterialApp(
      theme: theme,
      home: const Scaffold(
        body: MaterialSearchDialog(),
      ),
    );
  }

  testWidgets('renders all main elements of MaterialSearchDialog', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text('Agregar Material'), findsOneWidget);
    expect(
      find.text('Selecciona un ítem del inventario y define la cantidad'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.inventory_2_rounded), findsOneWidget);

    // 2. Buscador
    expect(find.text('Buscar por nombre o código SKU...'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // 3. Cantidad y stepper
    expect(find.text('Cantidad a utilizar'), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsNWidgets(2)); // Stepper '+' y botón 'Agregar a la Orden'

    // 4. Lista de materiales cargados
    expect(find.text('MAT-001'), findsOneWidget);
    expect(find.text('Tubo PVC 1/2 pulgada'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
    expect(find.text('MAT-002'), findsOneWidget);
    expect(find.text('Abrazadera de 3/8'), findsOneWidget);

    // 5. Botones de pie
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Agregar a la Orden'), findsOneWidget);
  });

  testWidgets('selecting a material updates selection and stepper works', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));
    await tester.pumpAndSettle();

    // Seleccionar el primer material
    await tester.tap(find.text('Tubo PVC 1/2 pulgada'));
    await tester.pumpAndSettle();

    // Unidad de medida visible
    expect(find.text('METROS'), findsNWidgets(2)); // en el selector y en el banner de item

    // Incrementar cantidad usando el stepper '+'
    final addIconInStepper = find.descendant(
      of: find.byType(Row),
      matching: find.byIcon(Icons.add_rounded),
    ).first;

    await tester.tap(addIconInStepper);
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);

    // Decrementar cantidad usando el stepper '-'
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('adapts cleanly in Dark Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: darkTheme));
    await tester.pumpAndSettle();

    expect(find.text('Agregar Material'), findsOneWidget);
    expect(find.text('MAT-001'), findsOneWidget);
  });
}
