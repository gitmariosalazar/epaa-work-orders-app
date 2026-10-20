import 'package:clean_architecture/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:clean_architecture/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeLocalDataSource extends Mock implements ThemeLocalDataSource {}

void main() {
  late MockThemeLocalDataSource mockDataSource;
  late ThemeRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
  });

  setUp(() {
    mockDataSource = MockThemeLocalDataSource();
    repository = ThemeRepositoryImpl(localDataSource: mockDataSource);
  });

  group('ThemeRepositoryImpl', () {
    test('getThemeMode delegates call to localDataSource', () async {
      when(() => mockDataSource.getThemeMode()).thenAnswer((_) async => ThemeMode.dark);

      final result = await repository.getThemeMode();

      expect(result, ThemeMode.dark);
      verify(() => mockDataSource.getThemeMode()).called(1);
    });

    test('saveThemeMode delegates call to localDataSource', () async {
      when(() => mockDataSource.saveThemeMode(any())).thenAnswer((_) async {});

      await repository.saveThemeMode(ThemeMode.light);

      verify(() => mockDataSource.saveThemeMode(ThemeMode.light)).called(1);
    });
  });
}
