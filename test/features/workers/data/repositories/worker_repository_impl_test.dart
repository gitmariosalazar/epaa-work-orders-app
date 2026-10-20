import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/features/workers/data/datasource/worker_remote_datasource.dart';
import 'package:clean_architecture/features/workers/data/models/models/worker_model.dart';
import 'package:clean_architecture/features/workers/data/repositories/worker_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetService extends Mock implements InternetService {}

class MockWorkerRemoteDatasource extends Mock
    implements WorkerRemoteDatasource {}

void main() {
  late MockInternetService mockInternetService;
  late MockWorkerRemoteDatasource mockRemoteDatasource;
  late WorkerRepositoryImpl repository;

  setUp(() {
    mockInternetService = MockInternetService();
    mockRemoteDatasource = MockWorkerRemoteDatasource();
    repository = WorkerRepositoryImpl(
      internetService: mockInternetService,
      remoteDatasource: mockRemoteDatasource,
    );
  });

  group('WorkerRepositoryImpl.getAllWorkers', () {
    test('returns SuccessState with empty list when models is empty without crashing', () async {
      when(() => mockInternetService.isConnected).thenReturn(true);
      when(() => mockRemoteDatasource.getAllWorkers()).thenAnswer(
        (_) async => const SuccessState<List<WorkerModel>>(data: []),
      );

      final result = await repository.getAllWorkers();

      expect(result, isA<SuccessState>());
      expect(result.data, isEmpty);
    });

    test('returns SuccessState with mapped WorkerEntity list when models is not empty', () async {
      final models = [
        WorkerModel(
          workerId: '10',
          identification: '0987654321',
          lastNames: 'López',
          firstNames: 'Carlos',
          phoneNumber: '022345678',
          cellPhone: '0991234567',
          email: 'carlos@epaa.com',
          address: 'Av. Principal',
        ),
      ];

      when(() => mockInternetService.isConnected).thenReturn(true);
      when(() => mockRemoteDatasource.getAllWorkers()).thenAnswer(
        (_) async => SuccessState<List<WorkerModel>>(data: models),
      );

      final result = await repository.getAllWorkers();

      expect(result, isA<SuccessState>());
      expect(result.data?.length, 1);
      expect(result.data?.first.firstNames, 'Carlos');
      expect(result.data?.first.identification, '0987654321');
    });

    test('returns FailureState when remoteDatasource returns FailureState', () async {
      when(() => mockInternetService.isConnected).thenReturn(true);
      when(() => mockRemoteDatasource.getAllWorkers()).thenAnswer(
        (_) async => const FailureState<List<WorkerModel>>(
          message: 'Error al conectar',
        ),
      );

      final result = await repository.getAllWorkers();

      expect(result, isA<FailureState>());
      expect(result.message, 'Error al conectar');
    });
  });
}
