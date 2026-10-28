import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/executive_overview_entity.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/executive_overview_use_cases.dart';
import 'package:clean_architecture/features/dashboard/domain/usecases/work_order_statistics_use_cases.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/cubit/technician_initial_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/cubit/technician_initial_state.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllWorkOrdersUseCase extends Mock
    implements GetAllWorkOrdersUseCase {}

class MockGetHeaderKpisUseCase extends Mock implements GetHeaderKpisUseCase {}

class MockGetWorkOrderStatusStatisticsUseCase extends Mock
    implements GetWorkOrderStatusStatisticsUseCase {}

void main() {
  late MockGetAllWorkOrdersUseCase mockGetAllWorkOrdersUseCase;
  late TechnicianInitialCubit cubit;

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
      status: 'COMPLETADA',
      priorityId: 2,
      workTypeId: 2,
    ),
  ];

  setUp(() {
    mockGetAllWorkOrdersUseCase = MockGetAllWorkOrdersUseCase();
    cubit = TechnicianInitialCubit(
      getAllWorkOrdersUseCase: mockGetAllWorkOrdersUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state has isLoading = true', () {
    expect(cubit.state.isLoading, isTrue);
    expect(cubit.state.pendingCount, 0);
    expect(cubit.state.inProgressCount, 0);
    expect(cubit.state.completedCount, 0);
  });

  blocTest<TechnicianInitialCubit, TechnicianInitialState>(
    'loadInitialData processes orders and calculates correct KPIs',
    build: () {
      when(
        () => mockGetAllWorkOrdersUseCase.call(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => SuccessState(data: sampleOrders));
      return cubit;
    },
    act: (c) => c.loadInitialData(),
    expect: () => [
      predicate<TechnicianInitialState>((state) {
        return !state.isLoading &&
            state.pendingCount == 1 &&
            state.inProgressCount == 1 &&
            state.completedCount == 1 &&
            state.priorityOrder?.orderCode == 'OT-2026-90' &&
            state.todayOrders.length == 2;
      }),
    ],
    verify: (_) {
      verify(
        () => mockGetAllWorkOrdersUseCase.call(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).called(1);
    },
  );

  blocTest<TechnicianInitialCubit, TechnicianInitialState>(
    'loadInitialData emits empty state when useCase returns empty list',
    build: () {
      when(
        () => mockGetAllWorkOrdersUseCase.call(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => const SuccessState(data: []));
      return cubit;
    },
    act: (c) => c.loadInitialData(),
    expect: () => [
      predicate<TechnicianInitialState>((state) {
        return !state.isLoading &&
            state.pendingCount == 0 &&
            state.inProgressCount == 0 &&
            state.completedCount == 0 &&
            state.priorityOrder == null &&
            state.todayOrders.isEmpty;
      }),
    ],
  );

  blocTest<TechnicianInitialCubit, TechnicianInitialState>(
    'syncData updates state and triggers work orders fetch',
    build: () {
      when(
        () => mockGetAllWorkOrdersUseCase.call(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => SuccessState(data: sampleOrders));
      return cubit;
    },
    act: (c) => c.syncData(),
    expect: () => [
      predicate<TechnicianInitialState>((state) => state.isSyncing),
      predicate<TechnicianInitialState>(
        (state) => !state.isSyncing && state.allOrders.length == 3,
      ),
    ],
  );

  blocTest<TechnicianInitialCubit, TechnicianInitialState>(
    'loadInitialData uses GetHeaderKpisUseCase as primary source for KPI counts',
    build: () {
      final mockHeaderKpisUseCase = MockGetHeaderKpisUseCase();
      when(
        () => mockGetAllWorkOrdersUseCase.call(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => SuccessState(data: sampleOrders));

      when(() => mockHeaderKpisUseCase.call()).thenAnswer(
        (_) async => const SuccessState(
          data: HeaderKpisEntity(
            totalOrders: 20,
            pendingOrAssigned: 8,
            inProgress: 5,
            onHold: 0,
            criticalOrders: 0,
            emergency: 0,
            urgent: 0,
            high: 0,
            medium: 0,
            low: 0,
            createdToday: 0,
            createdLast7Days: 0,
            createdThisMonth: 0,
            completed: 7,
            closed: 0,
            totalMaterialCost: 0,
          ),
        ),
      );

      return TechnicianInitialCubit(
        getAllWorkOrdersUseCase: mockGetAllWorkOrdersUseCase,
        getHeaderKpisUseCase: mockHeaderKpisUseCase,
      );
    },
    act: (c) => c.loadInitialData(),
    expect: () => [
      predicate<TechnicianInitialState>((state) {
        return !state.isLoading &&
            state.pendingCount == 8 &&
            state.inProgressCount == 5 &&
            state.completedCount == 7;
      }),
    ],
  );

  blocTest<TechnicianInitialCubit, TechnicianInitialState>(
    'loadInitialData recovers inProgressCount when backend reports inProgress as 0',
    build: () {
      final mockHeaderKpisUseCase = MockGetHeaderKpisUseCase();
      when(
        () => mockGetAllWorkOrdersUseCase.call(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => SuccessState(data: sampleOrders));

      when(() => mockHeaderKpisUseCase.call()).thenAnswer(
        (_) async => const SuccessState(
          data: HeaderKpisEntity(
            totalOrders: 135,
            pendingOrAssigned: 85,
            inProgress: 0,
            onHold: 0,
            criticalOrders: 1,
            emergency: 0,
            urgent: 1,
            high: 0,
            medium: 0,
            low: 0,
            createdToday: 0,
            createdLast7Days: 90,
            createdThisMonth: 135,
            completed: 28,
            closed: 28,
            totalMaterialCost: 0,
          ),
        ),
      );

      return TechnicianInitialCubit(
        getAllWorkOrdersUseCase: mockGetAllWorkOrdersUseCase,
        getHeaderKpisUseCase: mockHeaderKpisUseCase,
      );
    },
    act: (c) => c.loadInitialData(),
    expect: () => [
      predicate<TechnicianInitialState>((state) {
        return !state.isLoading &&
            state.pendingCount == 85 &&
            state.inProgressCount == 22 &&
            state.completedCount == 28;
      }),
    ],
  );
}
