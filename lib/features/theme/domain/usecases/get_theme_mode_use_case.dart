import 'package:clean_architecture/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Use case for retrieving the persisted theme mode.
///
/// Follows SRP: Has a single responsibility (fetching theme preference).
@lazySingleton
class GetThemeModeUseCase {
  final ThemeRepository _repository;

  const GetThemeModeUseCase({required ThemeRepository repository})
      : _repository = repository;

  Future<ThemeMode> call() => _repository.getThemeMode();
}
