import 'package:clean_architecture/core/services/database/local_database_service.dart';
import 'package:clean_architecture/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDatabaseService extends Mock implements LocalDatabaseService {}

void main() {
  late MockLocalDatabaseService mockDb;
  late ThemeLocalDataSourceImpl dataSource;

  setUp(() {
    mockDb = MockLocalDatabaseService();
    dataSource = ThemeLocalDataSourceImpl(localDatabaseService: mockDb);
  });

  group('ThemeLocalDataSourceImpl', () {
    test('getThemeMode returns ThemeMode.light by default when null stored', () async {
      when(() => mockDb.getString(any())).thenReturn(null);

      final result = await dataSource.getThemeMode();

      expect(result, ThemeMode.light);
      verify(() => mockDb.getString('app_theme_mode')).called(1);
    });

    test('getThemeMode returns ThemeMode.dark when "dark" is stored', () async {
      when(() => mockDb.getString(any())).thenReturn('dark');

      final result = await dataSource.getThemeMode();

      expect(result, ThemeMode.dark);
    });

    test('getThemeMode returns ThemeMode.system when "system" is stored', () async {
      when(() => mockDb.getString(any())).thenReturn('system');

      final result = await dataSource.getThemeMode();

      expect(result, ThemeMode.system);
    });

    test('saveThemeMode stores "dark" for ThemeMode.dark', () async {
      when(() => mockDb.setString(any(), any())).thenAnswer((_) async {});

      await dataSource.saveThemeMode(ThemeMode.dark);

      verify(() => mockDb.setString('app_theme_mode', 'dark')).called(1);
    });

    test('saveThemeMode stores "light" for ThemeMode.light', () async {
      when(() => mockDb.setString(any(), any())).thenAnswer((_) async {});

      await dataSource.saveThemeMode(ThemeMode.light);

      verify(() => mockDb.setString('app_theme_mode', 'light')).called(1);
    });

    test('saveThemeMode stores "system" for ThemeMode.system', () async {
      when(() => mockDb.setString(any(), any())).thenAnswer((_) async {});

      await dataSource.saveThemeMode(ThemeMode.system);

      verify(() => mockDb.setString('app_theme_mode', 'system')).called(1);
    });
  });
}
