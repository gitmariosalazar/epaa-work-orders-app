import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/home/home_page.dart';
import 'package:clean_architecture/shared_ui/themes/theme.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:clean_architecture/shared_ui/ui/base_title.dart';
import 'package:clean_architecture/shared_ui/utils/screen_util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/work_order_statistics_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';

class MockSessionService extends Mock implements SessionService {}

class MockGetWorkOrdersKeyStatisticsUseCase extends Mock
    implements GetWorkOrdersKeyStatisticsUseCase {}

// total 156, pendientes round(156*14.75%)=23, en progreso 156-23-88=45,
// urgentes 5+3=8
const _keyRow = WorkOrdersKeyStatisticEntity(
  totalOrders: 156,
  statusId: 1,
  statusName: 'Pendiente',
  workTypeId: 1,
  workType: 'ALCANTARILLADO',
  departmentId: 1,
  departmentName: 'Operaciones',
  emergency: 5,
  urgent: 3,
  high: 0,
  medium: 0,
  low: 0,
  criticalOrders: 8,
  createdToday: 0,
  createdLast7Days: 0,
  createdThisMonth: 0,
  closed: 0,
  completed: 88,
  avgHoursToComplete: null,
  avgHoursToAssignment: null,
  avgHoursToExecution: null,
  pctCompletedInGroup: 0,
  pctPendingOrAssigned: 14.75,
  totalMaterialCost: 0,
  avgWorkersPerOrder: null,
  totalWorkerAssignments: null,
);

void main() {
  late MockSessionService mockSessionService;

  setUp(() {
    mockSessionService = MockSessionService();
    when(() => mockSessionService.fullName).thenReturn('Mario Salazar');

    if (GetIt.I.isRegistered<SessionService>()) {
      GetIt.I.unregister<SessionService>();
    }
    GetIt.I.registerSingleton<SessionService>(mockSessionService);

    final mockKeyStats = MockGetWorkOrdersKeyStatisticsUseCase();
    when(() => mockKeyStats()).thenAnswer(
      (_) async => const SuccessState<List<WorkOrdersKeyStatisticEntity>>(
        data: [_keyRow],
      ),
    );
    GetIt.I.registerSingleton<GetWorkOrdersKeyStatisticsUseCase>(mockKeyStats);

    final screenDetails = ScreenDetails(
      logicalSize: const Size(1200, 800),
      physicalSize: const Size(1200, 800),
      devicePixelRatio: 1,
    );
    ScreenUtil.I.configureScreen(screenDetails);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget buildWidget({required ThemeData theme}) {
    return MaterialApp(
      theme: theme,
      home: const HomePage(),
    );
  }

  testWidgets('renders all main sections and metrics on HomePage', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));
    await tester.pump();

    expect(find.text('Mario Salazar'), findsOneWidget);
    expect(find.text('Dashboard de Órdenes de Trabajo'), findsOneWidget);

    // Métricas
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('156'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('23'), findsOneWidget);
    expect(find.text('En Progreso'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text('Urgentes'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);

    // Secciones
    expect(find.text('Órdenes de Trabajo'), findsOneWidget);
    expect(find.text('Incidencias'), findsOneWidget);
    expect(find.text('Acometidas'), findsNWidgets(2));
    expect(find.text('Recursos'), findsOneWidget);
  });

  testWidgets('adapts decoration and elements in Light Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: lightTheme));
    await tester.pump();

    // BaseTitle en Light Theme usa null/AppColors.blackE1
    final titleWidget = tester.widget<BaseTitle>(find.byType(BaseTitle));
    expect(titleWidget.color, isNull);

    // Icono del usuario en AppBar usa AppColors.base en Light Theme
    final userIcon = tester.widget<Icon>(find.descendant(
      of: find.byType(BaseAppBar),
      matching: find.byIcon(Icons.person),
    ));
    expect(userIcon.color, AppColors.base);
  });

  testWidgets('adapts decoration and elements in Dark Theme', (tester) async {
    await tester.pumpWidget(buildWidget(theme: darkTheme));
    await tester.pump();

    // BaseTitle en Dark Theme usa darkTheme.colorScheme.onSurface
    final titleWidget = tester.widget<BaseTitle>(find.byType(BaseTitle));
    expect(titleWidget.color, darkTheme.colorScheme.onSurface);

    // Icono del usuario en AppBar usa onSurface en Dark Theme (no AppColors.base negro)
    final userIcon = tester.widget<Icon>(find.descendant(
      of: find.byType(BaseAppBar),
      matching: find.byIcon(Icons.person),
    ));
    expect(userIcon.color, darkTheme.colorScheme.onSurface);
    expect(userIcon.color, isNot(AppColors.base));
  });
}
