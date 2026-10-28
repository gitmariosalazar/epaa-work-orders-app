import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/update_connection_basic_request.dart';
import 'package:clean_architecture/features/connections/form/update/domain/repositories/connection_repository.dart';
import 'package:clean_architecture/features/connections/form/update/domain/usecases/update_connection_basic_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateConnectionRepository extends Mock
    implements UpdateConnectionRepository {}

void main() {
  late MockUpdateConnectionRepository mockRepository;
  late UpdateConnectionBasicUseCase useCase;

  setUp(() {
    mockRepository = MockUpdateConnectionRepository();
    useCase = UpdateConnectionBasicUseCase(mockRepository);
  });

  test('should call repository.updateConnectionBasic with the provided request', () async {
    const request = UpdateConnectionBasicRequest(
      connectionId: 'conn-123',
      meterNumber: 'M-998877',
      photosFacade: [],
      photosMeter: [],
    );

    when(() => mockRepository.updateConnectionBasic(request))
        .thenAnswer((_) async {});

    await useCase(request);

    verify(() => mockRepository.updateConnectionBasic(request)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
