import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/search/presentation/info/widgets/connection_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const dummyConnection = ConnectionEntity(
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

  testWidgets('Fachada button is visible and triggers callback when tapped',
      (tester) async {
    bool facadeTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConnectionResultCard(
            connection: dummyConnection,
            onTap: () {},
            onUpdateMeterTap: () {
              facadeTapped = true;
            },
          ),
        ),
      ),
    );

    final facadeButton = find.widgetWithText(FilledButton, 'Fachada');
    expect(facadeButton, findsOneWidget);

    await tester.tap(facadeButton);
    await tester.pump();

    expect(facadeTapped, isTrue);
  });
}
