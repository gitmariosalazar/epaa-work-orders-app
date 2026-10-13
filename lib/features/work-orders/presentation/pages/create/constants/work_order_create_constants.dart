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

abstract class WorkOrderCreateConstants {
  static const List<WorkOrderStepItem> steps = [
    WorkOrderStepItem(id: 1, label: 'Cliente', icon: Icons.person_rounded),
    WorkOrderStepItem(id: 2, label: 'Detalle OT', icon: Icons.build_rounded),
    WorkOrderStepItem(id: 3, label: 'Confirmación', icon: Icons.task_alt_rounded),
  ];

  static const List<WorkOrderOriginItem> origins = [
    WorkOrderOriginItem(
      value: 'SOLICITUD',
      label: '📋 Solicitud ciudadana',
      icon: Icons.assignment_outlined,
    ),
    WorkOrderOriginItem(
      value: 'EMERGENCIA',
      label: '🚨 Emergencia',
      icon: Icons.warning_amber_rounded,
    ),
    WorkOrderOriginItem(
      value: 'PLANIFICADA',
      label: '📅 Planificada',
      icon: Icons.event_note_rounded,
    ),
    WorkOrderOriginItem(
      value: 'INSPECCION',
      label: '🔍 Inspección',
      icon: Icons.search_rounded,
    ),
  ];

  static const List<WorkOrderTypeItem> workTypes = [
    WorkOrderTypeItem(id: 1, label: 'Inspección de acometida', icon: Icons.search_rounded),
    WorkOrderTypeItem(id: 2, label: 'Reparación de fuga', icon: Icons.plumbing_rounded),
    WorkOrderTypeItem(id: 3, label: 'Instalación de medidor', icon: Icons.speed_rounded),
    WorkOrderTypeItem(id: 4, label: 'Corte de servicio', icon: Icons.power_off_rounded),
    WorkOrderTypeItem(id: 5, label: 'Reconexión de servicio', icon: Icons.power_rounded),
    WorkOrderTypeItem(id: 6, label: 'Limpieza de red', icon: Icons.cleaning_services_rounded),
    WorkOrderTypeItem(id: 7, label: 'Mantenimiento preventivo', icon: Icons.build_circle_rounded),
  ];

  static const List<WorkOrderPriorityItem> priorities = [
    WorkOrderPriorityItem(id: 1, label: '🔵 Baja', color: Color(0xFF3B82F6)),
    WorkOrderPriorityItem(id: 2, label: '🟡 Media', color: Color(0xFFF59E0B)),
    WorkOrderPriorityItem(id: 3, label: '🟠 Alta', color: Color(0xFFF97316)),
    WorkOrderPriorityItem(id: 4, label: '🔴 Urgente', color: Color(0xFFEF4444)),
    WorkOrderPriorityItem(id: 5, label: '⚡ Emergencia', color: Color(0xFF8B5CF6)),
  ];
}
