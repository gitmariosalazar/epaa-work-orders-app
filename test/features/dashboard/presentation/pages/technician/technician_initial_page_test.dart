import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/technician_initial_page.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/priority_task_card.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/quick_actions_bar.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/technician_header_section.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/technician_kpi_card.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/widgets/today_orders_section.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllWorkOrdersUseCase extends Mock
    implements GetAllWorkOrdersUseCase {}

class MockSessionService extends Mock implements SessionService {}

void main() {
  late MockGetAllWorkOrdersUseCase mockGetAllWorkOrdersUseCase;
  late MockSessionService mockSessionService;

  final sampleOrders = [
    WorkOrderEntity(
      workOrderId: '1',
      orderCode: 'OT-2026-90',
      description: 'Instalación / Inspección de Medidor',
      location: 'Sector 5',
      cadastralKey: '5-102',
      clientId: 'Carlos Andrade',
      status: 'EN_PROCESO',
      priorityId: 4,
      workTypeId: 2,
    ),
    WorkOrderEntity(
      workOrderId: '2',
      orderCode: 'OT-2026-0091',
      description: 'Revisión de fuga',
      location: 'Sector 3',
      cadastralKey: '3-045',
      clientId: 'María López',
      status: 'PENDIENTE',
      priorityId: 3,
      workTypeId: 1,
    ),
    WorkOrderEntity(
      workOrderId: '3',
      orderCode: 'OT-2026-0092',
      description: 'Cambio de medidor dañado',
      location: 'Sector 1',
      cadastralKey: '1-112',
      clientId: 'Juan Pérez',
      status: 'PENDIENTE',
      priorityId: 2,
      workTypeId: 2,
    ),
    WorkOrderEntity(
      workOrderId: '4',
      orderCode: 'OT-2026-0093',
      description: 'Corte / Suspensión',
      location: 'Sector 4',
      cadastralKey: '4-089',
      clientId: 'Rosa Gómez',
      status: 'PENDIENTE',
      priorityId: 2,
      workTypeId: 3,
    ),
  ];

  setUp(() {
    mockGetAllWorkOrdersUseCase = MockGetAllWorkOrdersUseCase();
    mockSessionService = MockSessionService();

    when(() => mockSessionService.isLoggedIn).thenReturn(true);
    when(() => mockSessionService.fullName).thenReturn('Carlos Andrade');
    when(() => mockSessionService.userData).thenReturn(
      const UserData(
        user: User(
          userId: '1',
          firstName: 'Carlos',
          lastName: 'Andrade',
          username: 'candrade',
          email: 'candrade@epaa.gob.ec',
          roles: ['TECNICO'],
          permissions: [],
          isActive: true,
        ),
        accessToken: 'token',
        refreshToken: 'refresh',
      ),
    );

    if (GetIt.I.isRegistered<GetAllWorkOrdersUseCase>()) {
      GetIt.I.unregister<GetAllWorkOrdersUseCase>();
    }
    GetIt.I.registerSingleton<GetAllWorkOrdersUseCase>(
      mockGetAllWorkOrdersUseCase,
    );

    if (GetIt.I.isRegistered<SessionService>()) {
      GetIt.I.unregister<SessionService>();
    }
    GetIt.I.registerSingleton<SessionService>(mockSessionService);

    when(
      () => mockGetAllWorkOrdersUseCase.call(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => SuccessState(data: sampleOrders));
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget buildWidget({required ThemeData theme}) {
    return MaterialApp(
      theme: theme,
      home: const TechnicianInitialPage(),
    );
  }

  testWidgets('renders all main sections and widgets of initial technician page', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));
    await tester.pumpAndSettle();

    // 1. Header
    expect(find.byType(TechnicianHeaderSection), findsOneWidget);
    expect(find.text('Hola, Carlos Andrade'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

    // 2. KPI Card
    expect(find.byType(TechnicianKpiCard), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('En Curso'), findsOneWidget);
    expect(find.text('Completas'), findsOneWidget);

    // 3. Tarea Prioritaria
    expect(find.byType(PriorityTaskCard), findsOneWidget);
    expect(find.text('TAREA PRIORITARIA / EN CURSO'), findsOneWidget);
    expect(find.text('EN PROCESO'), findsOneWidget);
    expect(find.text('#OT-2026-90'), findsOneWidget);
    expect(find.text('Instalación / Inspección de Medidor'), findsOneWidget);
    expect(find.text('Continuar Orden'), findsOneWidget);
    expect(find.text('Ver Mapa'), findsOneWidget);

    // 4. Acciones Rápidas
    expect(find.byType(QuickActionsBar), findsOneWidget);
    expect(find.text('ACCIONES RÁPIDAS'), findsOneWidget);
    expect(find.text('Buscar OT'), findsOneWidget);
    expect(find.text('Nueva OT'), findsOneWidget);
    expect(find.text('Sincronizar'), findsOneWidget);

    // 5. Órdenes de Hoy
    expect(find.byType(TodayOrdersSection), findsOneWidget);
    expect(find.text('Ver todas'), findsOneWidget);
    expect(find.textContaining('OT-2026-0091'), findsOneWidget);
  });

  testWidgets('adapts smoothly in Light Theme and Dark Theme', (tester) async {
    // Light Theme
    await tester.pumpWidget(buildWidget(theme: lightTheme));
    await tester.pumpAndSettle();
    expect(find.text('Hola, Carlos Andrade'), findsOneWidget);

    // Dark Theme
    await tester.pumpWidget(buildWidget(theme: darkTheme));
    await tester.pumpAndSettle();
    expect(find.text('Hola, Carlos Andrade'), findsOneWidget);
    expect(find.text('Continuar Orden'), findsOneWidget);
  });
}
