import 'package:flutter/material.dart';

class WorkOrderStepItem {
  final int id;
  final String label;
  final IconData icon;

  const WorkOrderStepItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class WorkOrderOriginItem {
  final String value;
  final String label;
  final IconData icon;

  const WorkOrderOriginItem({
    required this.value,
    required this.label,
    required this.icon,
  });
}

class WorkOrderTypeItem {
  final int id;
  final String label;
  final IconData icon;

  const WorkOrderTypeItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class WorkOrderPriorityItem {
  final int id;
  final String label;
  final Color color;

  const WorkOrderPriorityItem({
    required this.id,
    required this.label,
    required this.color,
  });
}

/// Representa la configuración visual de un Departamento (iconos, colores light/dark)
class DepartmentVisualItem {
  final int id;
  final String name;
  final IconData icon;
  final Color color;
  final Color lightBgColor;
  final Color darkBgColor;

  const DepartmentVisualItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.lightBgColor,
    required this.darkBgColor,
  });

  Color resolveBackgroundColor(bool isDark) =>
      isDark ? darkBgColor : lightBgColor;
}

abstract class WorkOrderCreateConstants {
  static const List<WorkOrderStepItem> steps = [
    WorkOrderStepItem(id: 1, label: 'Cliente', icon: Icons.person_rounded),
    WorkOrderStepItem(id: 2, label: 'Detalle OT', icon: Icons.build_rounded),
    WorkOrderStepItem(
      id: 3,
      label: 'Confirmación',
      icon: Icons.task_alt_rounded,
    ),
  ];

  static const List<WorkOrderOriginItem> origins = [
    WorkOrderOriginItem(
      value: 'SOLICITUD',
      label: 'Solicitud ciudadana',
      icon: Icons.assignment_outlined,
    ),
    WorkOrderOriginItem(
      value: 'EMERGENCIA',
      label: 'Emergencia',
      icon: Icons.warning_amber_rounded,
    ),
    WorkOrderOriginItem(
      value: 'PLANIFICADA',
      label: 'Planificada',
      icon: Icons.event_note_rounded,
    ),
    WorkOrderOriginItem(
      value: 'INSPECCION',
      label: 'Inspección',
      icon: Icons.search_rounded,
    ),
  ];

  /// Work types estáticos de respaldo para offline o compatibilidad histórica
  static const List<WorkOrderTypeItem> workTypes = [
    WorkOrderTypeItem(
      id: 1,
      label: 'Inspección de acometida',
      icon: Icons.search_rounded,
    ),
    WorkOrderTypeItem(
      id: 2,
      label: 'Reparación de fuga',
      icon: Icons.plumbing_rounded,
    ),
    WorkOrderTypeItem(
      id: 3,
      label: 'Instalación de medidor',
      icon: Icons.speed_rounded,
    ),
    WorkOrderTypeItem(
      id: 4,
      label: 'Corte de servicio',
      icon: Icons.power_off_rounded,
    ),
    WorkOrderTypeItem(
      id: 5,
      label: 'Reconexión de servicio',
      icon: Icons.power_rounded,
    ),
    WorkOrderTypeItem(
      id: 6,
      label: 'Limpieza de red',
      icon: Icons.cleaning_services_rounded,
    ),
    WorkOrderTypeItem(
      id: 7,
      label: 'Mantenimiento preventivo',
      icon: Icons.build_circle_rounded,
    ),
  ];

  static const List<WorkOrderPriorityItem> priorities = [
    WorkOrderPriorityItem(id: 5, label: 'Baja', color: Color(0xFF3B82F6)),
    WorkOrderPriorityItem(id: 4, label: 'Media', color: Color(0xFFF59E0B)),
    WorkOrderPriorityItem(id: 3, label: 'Alta', color: Color(0xFFF97316)),
    WorkOrderPriorityItem(id: 2, label: 'Urgente', color: Color(0xFFEF4444)),
    WorkOrderPriorityItem(id: 1, label: 'Emergencia', color: Color(0xFF8B5CF6)),
  ];

  // ── VISUAL HELPERS & MAPPERS PARA DEPARTAMENTOS Y WORK TYPES DINÁMICOS ───

  /// Obtiene la identidad visual para un departamento según su nombre o id
  static DepartmentVisualItem getDepartmentVisual(String name, [int? id]) {
    final lower = name.toLowerCase();

    if (lower.contains('agua') || id == 2) {
      return DepartmentVisualItem(
        id: id ?? 2,
        name: name,
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF0284C7), // Blue Sky
        lightBgColor: const Color(0xFFE0F2FE),
        darkBgColor: const Color(0xFF082F49),
      );
    }

    if (lower.contains('alcantarilla') || id == 1) {
      return DepartmentVisualItem(
        id: id ?? 1,
        name: name,
        icon: Icons.plumbing_rounded,
        color: const Color(0xFF0D9488), // Deep Teal
        lightBgColor: const Color(0xFFCCFBF1),
        darkBgColor: const Color(0xFF134E4A),
      );
    }

    if (lower.contains('comercial') || id == 3) {
      return DepartmentVisualItem(
        id: id ?? 3,
        name: name,
        icon: Icons.storefront_rounded,
        color: const Color(0xFF10B981), // Emerald
        lightBgColor: const Color(0xFFD1FAE5),
        darkBgColor: const Color(0xFF064E3B),
      );
    }

    if (lower.contains('mantenim') || id == 4) {
      return DepartmentVisualItem(
        id: id ?? 4,
        name: name,
        icon: Icons.build_rounded,
        color: const Color(0xFFF59E0B), // Amber
        lightBgColor: const Color(0xFFFEF3C7),
        darkBgColor: const Color(0xFF78350F),
      );
    }

    if (lower.contains('laborat') || lower.contains('calidad') || id == 5) {
      return DepartmentVisualItem(
        id: id ?? 5,
        name: name,
        icon: Icons.science_rounded,
        color: const Color(0xFF8B5CF6), // Purple
        lightBgColor: const Color(0xFFEDE9FE),
        darkBgColor: const Color(0xFF4C1D95),
      );
    }

    // Default dinámico
    const fallbackColors = [
      Color(0xFF6366F1), // Indigo
      Color(0xFFEC4899), // Pink
      Color(0xFF14B8A6), // Teal
      Color(0xFFF97316), // Orange
      Color(0xFF64748B), // Slate
    ];
    final colorIdx = ((id ?? name.hashCode.abs()) % fallbackColors.length);
    final chosenColor = fallbackColors[colorIdx];

    return DepartmentVisualItem(
      id: id ?? 0,
      name: name,
      icon: Icons.business_center_rounded,
      color: chosenColor,
      lightBgColor: chosenColor.withValues(alpha: 0.12),
      darkBgColor: chosenColor.withValues(alpha: 0.25),
    );
  }

  /// Resuelve un icono contextual y preciso para un tipo de trabajo
  static IconData getWorkTypeIcon(
    String typeName, [
    String? typeCode,
    String? departmentName,
  ]) {
    final lower = '$typeName ${typeCode ?? ''}'.toLowerCase();

    if (lower.contains('fuga') ||
        lower.contains('derrame') ||
        lower.contains('rotura') ||
        lower.contains('filtrac')) {
      return Icons.water_damage_rounded;
    }
    if (lower.contains('medidor') ||
        lower.contains('lectura') ||
        lower.contains('reloj')) {
      return Icons.speed_rounded;
    }
    if (lower.contains('corte') ||
        lower.contains('suspens') ||
        lower.contains('clausura')) {
      return Icons.power_off_rounded;
    }
    if (lower.contains('reconex') ||
        lower.contains('reapert') ||
        lower.contains('activac')) {
      return Icons.power_rounded;
    }
    if (lower.contains('inspecc') ||
        lower.contains('revis') ||
        lower.contains('verific') ||
        lower.contains('evalua')) {
      return Icons.search_rounded;
    }
    if (lower.contains('limpieza') ||
        lower.contains('desazolve') ||
        lower.contains('lavado') ||
        lower.contains('purga')) {
      return Icons.cleaning_services_rounded;
    }
    if (lower.contains('acometida') ||
        lower.contains('instalac') ||
        lower.contains('conexion') ||
        lower.contains('conexión')) {
      return Icons.alt_route_rounded;
    }
    if (lower.contains('sumidero') ||
        lower.contains('pozo') ||
        lower.contains('rejilla') ||
        lower.contains('alcantarill')) {
      return Icons.waves_rounded;
    }
    if (lower.contains('valvula') ||
        lower.contains('válvula') ||
        lower.contains('hidrante')) {
      return Icons.tune_rounded;
    }
    if (lower.contains('bomba') ||
        lower.contains('tanque') ||
        lower.contains('presion') ||
        lower.contains('presión')) {
      return Icons.compress_rounded;
    }
    if (lower.contains('calidad') ||
        lower.contains('cloro') ||
        lower.contains('muestra') ||
        lower.contains('quimic') ||
        lower.contains('laborat')) {
      return Icons.science_rounded;
    }
    if (lower.contains('catastro') ||
        lower.contains('tarifa') ||
        lower.contains('cambio titular') ||
        lower.contains('factura')) {
      return Icons.receipt_long_rounded;
    }
    if (lower.contains('mantenim') ||
        lower.contains('reparac') ||
        lower.contains('prevent') ||
        lower.contains('correct')) {
      return Icons.build_circle_rounded;
    }

    // Si viene departamento, usar el icono del departamento
    if (departmentName != null && departmentName.isNotEmpty) {
      return getDepartmentVisual(departmentName).icon;
    }

    return Icons.assignment_outlined;
  }

  /// Mapea la prioridad sugerida (texto de la API) al ID numérico de prioridad (1..5)
  static int? mapSuggestedPriorityToId(String? suggested) {
    if (suggested == null || suggested.trim().isEmpty) return null;
    final s = suggested.toUpperCase().trim();
    if (s.contains('EMERGENCIA') ||
        s.contains('CRITICA') ||
        s.contains('CRÍTICA')) {
      return 1;
    }
    if (s.contains('URGENTE')) return 2;
    if (s.contains('ALTA')) return 3;
    if (s.contains('MEDIA')) return 4;
    if (s.contains('BAJA')) return 5;
    return null;
  }

  /// Color para una prioridad sugerida (texto)
  static Color getSuggestedPriorityColor(String? suggested) {
    if (suggested == null || suggested.trim().isEmpty) {
      return const Color(0xFF6B7280);
    }
    final s = suggested.toUpperCase().trim();
    if (s.contains('EMERGENCIA') ||
        s.contains('CRITICA') ||
        s.contains('CRÍTICA')) {
      return const Color(0xFF8B5CF6);
    }
    if (s.contains('URGENTE')) return const Color(0xFFEF4444);
    if (s.contains('ALTA')) return const Color(0xFFF97316);
    if (s.contains('MEDIA')) return const Color(0xFFF59E0B);
    if (s.contains('BAJA')) return const Color(0xFF3B82F6);
    return const Color(0xFF6B7280);
  }

  /// Obtiene el color de una prioridad por su ID
  static Color getPriorityColor(int priorityId) {
    for (final p in priorities) {
      if (p.id == priorityId) return p.color;
    }
    return const Color(0xFF3B82F6);
  }
}
