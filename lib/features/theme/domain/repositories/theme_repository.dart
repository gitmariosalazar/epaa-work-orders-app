import 'package:flutter/material.dart';

/// Contract for accessing and updating the user's theme preference.
///
/// Adheres to:
/// - SRP: Only responsible for abstracting theme preference persistence.
/// - OCP: New theme modes can be supported without modifying consumers.
/// - DIP: High-level modules (use cases) depend on this abstraction.
abstract interface class ThemeRepository {
  /// Retrieves the persisted [ThemeMode].
  Future<ThemeMode> getThemeMode();

  /// Persists the selected [ThemeMode].
  Future<void> saveThemeMode(ThemeMode mode);
}
