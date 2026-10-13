// lib/core/utils/map_utils.dart

import 'package:clean_architecture/core/constants/work_order_status.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utilidades de presentación para mapas/estados de OT.
/// Los estados provienen de [WorkOrderStatus] (códigos string del backend).
class MapUtils {
  MapUtils._();

  /// Color de UI de cada estado.
  static Color getStatusColor(String status) {
    switch (WorkOrderStatus.normalize(status)) {
      case WorkOrderStatus.notificada:
      case WorkOrderStatus.notificadaInspeccion:
      case WorkOrderStatus.notificadaInstalacion:
        return const Color(0xFF607D8B); // Gris azulado
      case WorkOrderStatus.pendiente:
      case WorkOrderStatus.pendienteInspeccion:
      case WorkOrderStatus.pendienteInstalacion:
        return const Color(0xFFFF9800); // Naranja
      case WorkOrderStatus.asignada:
        return const Color(0xFF2196F3); // Azul
      case WorkOrderStatus.preparacion:
        return const Color(0xFF00BCD4); // Cian
      case WorkOrderStatus.enProceso:
      case WorkOrderStatus.enProcesoInspeccion:
      case WorkOrderStatus.enProcesoInstalacion:
        return const Color(0xFF9C27B0); // Púrpura
      case WorkOrderStatus.ejecutada:
      case WorkOrderStatus.inspeccionEjecutada:
      case WorkOrderStatus.instalacionEjecutada:
        return const Color(0xFFFFC107); // Ámbar
      case WorkOrderStatus.revisionRechazada:
      case WorkOrderStatus.rechazadaTecnica:
        return const Color(0xFFFF5722); // Naranja rojizo
      case WorkOrderStatus.completada:
      case WorkOrderStatus.inspeccionCompletada:
      case WorkOrderStatus.instalacionCompletada:
        return const Color(0xFF2E7D32); // Verde
      case WorkOrderStatus.cancelada:
        return const Color(0xFFE53935); // Rojo
      default:
        return Colors.grey;
    }
  }

  /// Hue del marcador (defaultMarkerWithHue), coherente con [getStatusColor].
  static double getStatusHue(String status) {
    switch (WorkOrderStatus.normalize(status)) {
      case WorkOrderStatus.notificada:
      case WorkOrderStatus.notificadaInspeccion:
      case WorkOrderStatus.notificadaInstalacion:
        return BitmapDescriptor.hueRose;
      case WorkOrderStatus.pendiente:
      case WorkOrderStatus.pendienteInspeccion:
      case WorkOrderStatus.pendienteInstalacion:
        return BitmapDescriptor.hueOrange;
      case WorkOrderStatus.asignada:
        return BitmapDescriptor.hueAzure;
      case WorkOrderStatus.preparacion:
        return BitmapDescriptor.hueCyan;
      case WorkOrderStatus.enProceso:
      case WorkOrderStatus.enProcesoInspeccion:
      case WorkOrderStatus.enProcesoInstalacion:
        return BitmapDescriptor.hueViolet;
      case WorkOrderStatus.ejecutada:
      case WorkOrderStatus.inspeccionEjecutada:
      case WorkOrderStatus.instalacionEjecutada:
        return BitmapDescriptor.hueYellow;
      case WorkOrderStatus.revisionRechazada:
      case WorkOrderStatus.rechazadaTecnica:
        return BitmapDescriptor.hueMagenta;
      case WorkOrderStatus.completada:
      case WorkOrderStatus.inspeccionCompletada:
      case WorkOrderStatus.instalacionCompletada:
        return BitmapDescriptor.hueGreen;
      case WorkOrderStatus.cancelada:
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }

  /// Texto legible del estado.
  static String getStatusText(String status) => WorkOrderStatus.labelOf(status);

  /// Descripción del estado.
  static String getStatusDescription(String status) =>
      WorkOrderStatus.descriptionOf(status);

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
