import 'package:clean_architecture/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:clean_architecture/features/theme/domain/repositories/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Implementation of [ThemeRepository] coordinating data sources.
///
/// Adheres to:
/// - SRP: Coordinates theme persistence between domain and data sources.
/// - DIP: Implements [ThemeRepository] defined in the domain layer.
/// - LSP: Can be substituted anywhere [ThemeRepository] is expected.
@LazySingleton(as: ThemeRepository)
class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource _localDataSource;

  const ThemeRepositoryImpl({required ThemeLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<ThemeMode> getThemeMode() => _localDataSource.getThemeMode();

  @override
  Future<void> saveThemeMode(ThemeMode mode) =>
      _localDataSource.saveThemeMode(mode);
}
