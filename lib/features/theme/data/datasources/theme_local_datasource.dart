import 'package:clean_architecture/core/services/database/local_database_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Contract for local storage operations concerning theme preference.
///
/// Adheres to:
/// - ISP: Exposes only theme data storage capabilities.
/// - SRP: Handles reading and writing theme configuration to local storage.
abstract interface class ThemeLocalDataSource {
  Future<ThemeMode> getThemeMode();
  Future<void> saveThemeMode(ThemeMode mode);
}

@LazySingleton(as: ThemeLocalDataSource)
class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const String _themeKey = 'app_theme_mode';
  final LocalDatabaseService _localDatabaseService;

  const ThemeLocalDataSourceImpl({
    required LocalDatabaseService localDatabaseService,
  }) : _localDatabaseService = localDatabaseService;

  @override
  Future<ThemeMode> getThemeMode() async {
    final stored = _localDatabaseService.getString(_themeKey);
    return switch (stored) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.light, // Default theme mode
    };
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await _localDatabaseService.setString(_themeKey, value);
  }
}
