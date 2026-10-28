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

  /// Retorna el nombre corto/estandarizado del departamento según su ID
  static String getDepartmentText(int id) {
    switch (id) {
      case 1:
        return 'AGUA POTABLE';
      case 2:
        return 'ALCANTARILLADO';
      case 3:
        return 'COMERCIALIZACIÓN';
      case 4:
        return 'PLANIFICACIÓN GIS';
      case 5:
        return 'ADMINISTRACIÓN';
      case 6:
        return 'DIRECCIÓN TÉCNICA';
      default:
        return 'DESCONOCIDO';
    }
  }

  /// Retorna la descripción oficial del área
  static String getDepartmentDescription(int id) {
    switch (id) {
      case 1:
        return 'Mantenimiento y operación de la red de agua potable';
      case 2:
        return 'Mantenimiento de la red de alcantarillado y plantas de tratamiento';
      case 3:
        return 'Atención al cliente, medidores y cortes de servicio';
      case 4:
        return 'Topografía, catastro y sistemas de información geográfica';
      case 5:
        return 'Gestión interna, activos y recursos humanos';
      case 6:
        return 'Supervisión de proyectos, fiscalización de obras y control de calidad técnica';
      default:
        return 'Sin descripción disponible';
    }
  }

  /// Retorna el ícono representativo según la función operativa del departamento
  static IconData getDepartmentIcon(int id) {
    switch (id) {
      case 1:
        // Agua potable: suministro y flujo de red
        return Icons.water_drop;
      case 2:
        // Alcantarillado: saneamiento, drenaje y tuberías
        return Icons.waves_outlined;
      case 3:
        // Comercialización: gestión de abonados, cortes y trámites
        return Icons.point_of_sale_outlined;
      case 4:
        // Planificación GIS: catastro, mapas y topografía
        return Icons.map_outlined;
      case 5:
        // Administración: gestión interna, corporativa y RRHH
        return Icons.business_outlined;
      case 6:
        // Dirección Técnica: ingeniería, fiscalización y supervisión técnica
        return Icons.engineering_outlined;
      default:
        return Icons.help_outline;
    }
  }

  static Color getDepartmentColor(int id) {
    switch (id) {
      case 1:
        // Agua potable: suministro y flujo de red
        return Colors.blue;
      case 2:
        // Alcantarillado: saneamiento, drenaje y tuberías
        return Colors.indigo;
      case 3:
        // Comercialización: gestión de abonados, cortes y trámites
        return Colors.green;
      case 4:
        // Planificación GIS: catastro, mapas y topografía
        return Colors.orange;
      case 5:
        // Administración: gestión interna, corporativa y RRHH
        return Colors.purple;
      case 6:
        // Dirección Técnica: ingeniería, fiscalización y supervisión técnica
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
