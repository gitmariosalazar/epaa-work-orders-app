import 'package:clean_architecture/features/theme/domain/repositories/theme_repository.dart';
import 'package:clean_architecture/features/theme/domain/usecases/get_theme_mode_use_case.dart';
import 'package:clean_architecture/features/theme/domain/usecases/save_theme_mode_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeRepository extends Mock implements ThemeRepository {}

void main() {
  late MockThemeRepository mockRepo;
  late GetThemeModeUseCase getUseCase;
  late SaveThemeModeUseCase saveUseCase;

  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
  });

  setUp(() {
    mockRepo = MockThemeRepository();
    getUseCase = GetThemeModeUseCase(repository: mockRepo);
    saveUseCase = SaveThemeModeUseCase(repository: mockRepo);
  });

  group('ThemeUseCases', () {
    test('GetThemeModeUseCase calls repository.getThemeMode', () async {
      when(() => mockRepo.getThemeMode()).thenAnswer((_) async => ThemeMode.dark);

      final result = await getUseCase();

      expect(result, ThemeMode.dark);
      verify(() => mockRepo.getThemeMode()).called(1);
    });

    test('SaveThemeModeUseCase calls repository.saveThemeMode', () async {
      when(() => mockRepo.saveThemeMode(any())).thenAnswer((_) async {});

      await saveUseCase(ThemeMode.light);

      verify(() => mockRepo.saveThemeMode(ThemeMode.light)).called(1);
    });
  });
}
