// lib/core/utils/map_utils.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  /// Colores profesionales únicos para cada estado (para UI, custom info window, etc.)
  static Color getStatusColor(int status) {
    switch (status) {
      case 1: // Pendiente
        return const Color(0xFFFF9800); // Naranja vibrante
      case 2: // Asignada
        return const Color(0xFF2196F3); // Azul primario
      case 3: // Reasignada
        return const Color(0xFF9C27B0); // Púrpura
      case 4: // En Progreso
        return const Color(0xFFFF00FF); // Magenta
      case 5: // En Espera
        return const Color(0xFFFFC107); // Amarillo ámbar
      case 6: // Reanudada
        return const Color(0xFF00BCD4); // Cian
      case 7: // Completada
        return const Color(0xFF2E7D32); // Verde oscuro
      case 8: // Cancelada
        return const Color(0xFFE53935); // Rojo intenso
      default:
        return Colors.grey;
    }
  }

  /// Hue más cercano posible al color personalizado (para usar con defaultMarkerWithHue)
  static double getStatusHue(int status) {
    switch (status) {
      case 1: // Pendiente (naranja)
        return BitmapDescriptor.hueOrange;
      case 2: // Asignada (azul)
        return BitmapDescriptor.hueAzure;
      case 3: // Reasignada (púrpura)
        return BitmapDescriptor.hueViolet;
      case 4: // En Progreso (verde)
        return BitmapDescriptor.hueMagenta;
      case 5: // En Espera (amarillo)
        return BitmapDescriptor.hueYellow;
      case 6: // Reanudada (cian)
        return BitmapDescriptor.hueCyan;
      case 7: // Completada (verde oscuro)
        return BitmapDescriptor.hueGreen;
      case 8: // Cancelada (rojo)
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueYellow;
    }
  }

  /// Texto legible del estado
  static String getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Pendiente';
      case 2:
        return 'Asignada';
      case 3:
        return 'Reasignada';
      case 4:
        return 'En Progreso';
      case 5:
        return 'En Espera';
      case 6:
        return 'Reanudada';
      case 7:
        return 'Completada';
      case 8:
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }

  /// Texto del tipo de trabajo
  static String getWorkTypeText(int id) {
    switch (id) {
      case 1:
        return 'ALCANTARILLADO';
      case 2:
        return 'AGUA POTABLE';
      case 3:
        return 'COMERCIALIZACION';
      case 4:
        return 'MANTENIMIENTO';
      case 5:
        return 'LABORATORIO';
      default:
        return 'DESCONOCIDO';
    }
  }

  // Íconos personalizados para cada tipo de trabajo (si se desea usar)
  static IconData getWorkTypeIcon(int id) {
    switch (id) {
      case 1:
        return Icons.water_damage; // ALCANTARILLADO
      case 2:
        return Icons.opacity; // AGUA POTABLE
      case 3:
        return Icons.store; // COMERCIALIZACION
      case 4:
        return Icons.build; // MANTENIMIENTO
      case 5:
        return Icons.science; // LABORATORIO
      default:
        return Icons.help; // DESCONOCIDO
    }
  }
}
