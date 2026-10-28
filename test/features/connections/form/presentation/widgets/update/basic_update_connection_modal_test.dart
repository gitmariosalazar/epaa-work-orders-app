import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/form/presentation/widgets/update/basic_update_connection_modal.dart';
import 'package:clean_architecture/features/connections/form/update/domain/repositories/connection_repository.dart';
import 'package:clean_architecture/features/connections/form/update/domain/usecases/update_connection_basic_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateConnectionRepository extends Mock
    implements UpdateConnectionRepository {}

void main() {
  late MockUpdateConnectionRepository mockRepository;
  late UpdateConnectionBasicUseCase mockUseCase;

  setUp(() {
    mockRepository = MockUpdateConnectionRepository();
    mockUseCase = UpdateConnectionBasicUseCase(mockRepository);
  });

  const dummyConnection = ConnectionWithPropertiesEntity(
    connectionId: 'conn-001',
    clientId: 'cli-001',
    connectionRateId: 1,
    connectionRateName: 'Tarifa Residencial',
    connectionSector: 1,
    connectionAccount: 100,
    connectionCadastralKey: '170101-01',
    connectionAddress: 'Av. Amazonas y Colón',
    connectionInstallationDate: '2023-01-01',
    connectionZone: 1,
    connectionCoordinates: '-0.19,-78.49',
    propertyCadastralKey: '170101-01',
  );

  testWidgets('renders BasicUpdateConnectionModal with all sections and controls',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BasicUpdateConnectionModal(
            connection: dummyConnection,
            useCase: mockUseCase,
          ),
        ),
      ),
    );

    expect(find.text('Actualizar Acometida'), findsOneWidget);
    expect(find.text('Todos los campos son obligatorios'), findsOneWidget);
    expect(find.text('Número de Medidor'), findsOneWidget);
    expect(find.text('Fotos de la Fachada'), findsOneWidget);
    expect(find.text('Fotos del Medidor'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
  });
}
