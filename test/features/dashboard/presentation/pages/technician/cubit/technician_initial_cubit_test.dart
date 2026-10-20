import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/cubit/technician_initial_cubit.dart';
import 'package:clean_architecture/features/dashboard/presentation/pages/technician/cubit/technician_initial_state.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllWorkOrdersUseCase extends Mock
    implements GetAllWorkOrdersUseCase {}

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
    'loadInitialData emits fallback orders when useCase returns empty list',
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
            state.pendingCount == 3 &&
            state.inProgressCount == 1 &&
            state.completedCount == 5 &&
            state.priorityOrder?.orderCode == 'OT-2026-90' &&
            state.todayOrders.length == 3;
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
}
