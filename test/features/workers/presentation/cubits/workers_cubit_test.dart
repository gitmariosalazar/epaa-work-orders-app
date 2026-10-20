import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:clean_architecture/features/workers/domain/usecases/get_all_workers_use_case.dart';
import 'package:clean_architecture/features/workers/presentation/cubits/workers/workers_cubit.dart';
import 'package:clean_architecture/features/workers/presentation/cubits/workers/workers_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllWorkersUseCase extends Mock implements GetAllWorkersUseCase {}

void main() {
  late MockGetAllWorkersUseCase mockUseCase;
  late WorkersCubit cubit;

  final List<WorkerEntity> testWorkers = [
    WorkerEntity(
      workerId: '1',
      identification: '1234567890',
      lastNames: 'Pérez',
      firstNames: 'Juan',
      phoneNumber: '0999999999',
      cellPhone: '0988888888',
      email: 'juan@epaa.com',
      address: 'Calle 1',
    ),
  ];

  setUp(() {
    mockUseCase = MockGetAllWorkersUseCase();
    cubit = WorkersCubit(getAllWorkersUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('WorkersCubit', () {
    test('initial state is WorkersInitial', () {
      expect(cubit.state, equals(WorkersInitial()));
    });

    blocTest<WorkersCubit, WorkersState>(
      'emits [WorkersLoading, WorkersLoaded] when usecase returns non-empty workers',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => SuccessState<List<WorkerEntity>>(data: testWorkers),
        );
        return cubit;
      },
      act: (c) => c.loadWorkers(),
      expect: () => [
        isA<WorkersLoading>(),
        isA<WorkersLoaded>().having((s) => s.workers.length, 'workers.length', 1),
      ],
    );

    blocTest<WorkersCubit, WorkersState>(
      'emits [WorkersLoading, WorkersEmpty] when usecase returns empty list',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const SuccessState<List<WorkerEntity>>(data: []),
        );
        return cubit;
      },
      act: (c) => c.loadWorkers(),
      expect: () => [
        isA<WorkersLoading>(),
        isA<WorkersEmpty>(),
      ],
    );

    blocTest<WorkersCubit, WorkersState>(
      'emits [WorkersLoading, WorkersError] with message on failure state',
      build: () {
        when(() => mockUseCase()).thenAnswer(
          (_) async => const FailureState<List<WorkerEntity>>(
            message: 'Error al obtener trabajadores',
          ),
        );
        return cubit;
      },
      act: (c) => c.loadWorkers(),
      expect: () => [
        isA<WorkersLoading>(),
        isA<WorkersError>().having(
          (s) => s.message,
          'message',
          'Error al obtener trabajadores',
        ),
      ],
    );

    blocTest<WorkersCubit, WorkersState>(
      'emits [WorkersLoading, WorkersError] when usecase throws unexpected exception',
      build: () {
        when(() => mockUseCase()).thenThrow(Exception('Unexpected crash'));
        return cubit;
      },
      act: (c) => c.loadWorkers(),
      expect: () => [
        isA<WorkersLoading>(),
        isA<WorkersError>().having(
          (s) => s.message,
          'message',
          'Error de conexión o inesperado. Intenta de nuevo.',
        ),
      ],
    );
  });
}
