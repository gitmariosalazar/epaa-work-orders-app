// features/dashboard/presentation/utils/statistics_appearance.dart
//
// Resuelve color e ícono para cada dimensión estadística. Los IDs conocidos
// conservan los colores originales del diseño; IDs nuevos que lleguen del API
// reciben un color de una paleta de respaldo en lugar de romper la UI.

import 'package:flutter/material.dart';

const List<Color> _fallbackPalette = [
  Colors.indigo,
  Colors.cyan,
  Colors.pink,
  Colors.lime,
  Colors.deepOrange,
  Colors.blueGrey,
  Colors.deepPurple,
  Colors.lightGreen,
];

Color _fallbackColor(Object key) =>
    _fallbackPalette[key.hashCode.abs() % _fallbackPalette.length];

abstract final class PriorityAppearance {
  static const Map<int, Color> _colors = {
    5: Colors.red,
    4: Colors.orange,
    3: Colors.amber,
    2: Colors.blue,
    1: Colors.green,
  };

  static const Map<int, IconData> _icons = {
    5: Icons.emergency,
    4: Icons.priority_high,
    3: Icons.warning_amber,
    2: Icons.schedule,
    1: Icons.low_priority,
  };

  static Color color(int id) => _colors[id] ?? _fallbackColor(id);
  static IconData icon(int id) => _icons[id] ?? Icons.flag_outlined;
}

abstract final class WorkTypeAppearance {
  static const Map<int, Color> _colors = {
    1: Colors.brown, // ALCANTARILLADO
    2: Colors.blue, // AGUA POTABLE
    3: Colors.green, // COMERCIALIZACION
    4: Colors.orange, // MANTENIMIENTO
    5: Colors.purple, // LABORATORIO
  };

  static const Map<int, IconData> _icons = {
    1: Icons.plumbing,
    2: Icons.water_drop,
    3: Icons.store,
    4: Icons.build,
    5: Icons.science,
  };

  static Color color(int id) => _colors[id] ?? _fallbackColor(id);
  static IconData icon(int id) => _icons[id] ?? Icons.work_outline;
}

/// Los estados llegan con código (`String`), así que se resuelven por
/// palabra clave del nombre/código.
abstract final class WorkStatusAppearance {
  static const List<(String, Color, IconData)> _rules = [
    ('pend', Colors.grey, Icons.schedule),
    ('reasign', Colors.orange, Icons.swap_horiz),
    ('asign', Colors.blue, Icons.assignment_ind),
    ('recib', Colors.lightBlue, Icons.inbox),
    ('prepar', Colors.indigo, Icons.construction),
    ('progres', Colors.purple, Icons.handyman),
    ('ejecu', Colors.purple, Icons.handyman),
    ('espera', Colors.amber, Icons.pause_circle),
    ('pausa', Colors.amber, Icons.pause_circle),
    ('reanud', Colors.teal, Icons.play_circle),
    ('calidad', Colors.cyan, Icons.fact_check),
    ('complet', Colors.green, Icons.check_circle),
    ('finaliz', Colors.green, Icons.check_circle),
    ('cerr', Colors.blueGrey, Icons.lock),
    ('cancel', Colors.red, Icons.cancel),
    ('rechaz', Colors.red, Icons.block),
  ];

  static (String, Color, IconData)? _match(String id, String name) {
    final key = '${name.toLowerCase()} ${id.toLowerCase()}';
    for (final rule in _rules) {
      if (key.contains(rule.$1)) return rule;
    }
    return null;
  }

  static Color color(String id, String name) =>
      _match(id, name)?.$2 ?? _fallbackColor(id);

  static IconData icon(String id, String name) =>
      _match(id, name)?.$3 ?? Icons.label_outline;
}
