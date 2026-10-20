import 'package:clean_architecture/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Use case for persisting the user's selected theme mode.
///
/// Follows SRP: Has a single responsibility (saving theme preference).
@lazySingleton
class SaveThemeModeUseCase {
  final ThemeRepository _repository;

  const SaveThemeModeUseCase({required ThemeRepository repository})
      : _repository = repository;

  Future<void> call(ThemeMode mode) => _repository.saveThemeMode(mode);
}
