import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/features/theme/domain/usecases/get_theme_mode_use_case.dart';
import 'package:clean_architecture/features/theme/domain/usecases/save_theme_mode_use_case.dart';
import 'package:clean_architecture/features/theme/presentation/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}

class MockSaveThemeModeUseCase extends Mock implements SaveThemeModeUseCase {}

void main() {
  late MockGetThemeModeUseCase mockGet;
  late MockSaveThemeModeUseCase mockSave;
  late ThemeCubit cubit;

  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
  });

  setUp(() {
    mockGet = MockGetThemeModeUseCase();
    mockSave = MockSaveThemeModeUseCase();
    cubit = ThemeCubit(
      getThemeModeUseCase: mockGet,
      saveThemeModeUseCase: mockSave,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('ThemeCubit', () {
    test('initial state is ThemeMode.light', () {
      expect(cubit.state, ThemeMode.light);
      expect(cubit.isDark, isFalse);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'init emits theme mode returned by getThemeModeUseCase',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => ThemeMode.dark);
        return cubit;
      },
      act: (c) => c.init(),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(() => mockGet()).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      'toggleTheme switches from light to dark and saves it',
      build: () {
        when(() => mockSave(any())).thenAnswer((_) async {});
        return cubit;
      },
      act: (c) => c.toggleTheme(),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(() => mockSave(ThemeMode.dark)).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      'toggleTheme switches from dark to light when current is dark',
      seed: () => ThemeMode.dark,
      build: () {
        when(() => mockSave(any())).thenAnswer((_) async {});
        return cubit;
      },
      act: (c) => c.toggleTheme(),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(() => mockSave(ThemeMode.light)).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      'setTheme saves and emits the given mode',
      build: () {
        when(() => mockSave(any())).thenAnswer((_) async {});
        return cubit;
      },
      act: (c) => c.setTheme(ThemeMode.system),
      expect: () => [ThemeMode.system],
      verify: (_) {
        verify(() => mockSave(ThemeMode.system)).called(1);
      },
    );
  });
}
