import 'package:clean_architecture/features/theme/domain/usecases/get_theme_mode_use_case.dart';
import 'package:clean_architecture/features/theme/domain/usecases/save_theme_mode_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Cubit managing application theme state.
///
/// Adheres to:
/// - SRP: Only responsible for theme state presentation logic.
/// - DIP: Depends on abstractions [GetThemeModeUseCase] and [SaveThemeModeUseCase].
@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SaveThemeModeUseCase _saveThemeModeUseCase;

  ThemeCubit({
    required GetThemeModeUseCase getThemeModeUseCase,
    required SaveThemeModeUseCase saveThemeModeUseCase,
  })  : _getThemeModeUseCase = getThemeModeUseCase,
        _saveThemeModeUseCase = saveThemeModeUseCase,
        super(ThemeMode.light);

  /// Initializes the cubit by retrieving the persisted theme mode.
  Future<void> init() async {
    final mode = await _getThemeModeUseCase();
    if (!isClosed) {
      emit(mode);
    }
  }

  /// Whether current theme is dark.
  bool get isDark => state == ThemeMode.dark;

  /// Toggles between light and dark themes.
  Future<void> toggleTheme() async {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    await _saveThemeModeUseCase(next);
    if (!isClosed) {
      emit(next);
    }
  }

  /// Sets a specific [ThemeMode].
  Future<void> setTheme(ThemeMode mode) async {
    await _saveThemeModeUseCase(mode);
    if (!isClosed) {
      emit(mode);
    }
  }
}
