import 'package:clean_architecture/features/incidents/presentation/widgets/add_work_order_sheet.dart';
// lib/features/incidents/presentation/widgets/incident_card.dart
import 'package:clean_architecture/components/button/widget_button.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/incidents/data/models/models/incident_detail_row_response.dart';
import 'package:clean_architecture/features/connections/search/domain/services/map_navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:intl/intl.dart';

class IncidentCard extends StatelessWidget {
  final IncidentDetailRowResponse incident;
  final VoidCallback onTap;
  final Color statusColor;
  final String statusLabel;
  final Color priorityColor;

  /// Se invoca tras generar la OT (para refrescar el listado).
  final VoidCallback? onWorkOrderCreated;

  const IncidentCard({
    super.key,
    required this.incident,
    required this.onTap,
    required this.statusColor,
    required this.statusLabel,
    required this.priorityColor,
    this.onWorkOrderCreated,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Category & Priority
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconIncidentType(
                            categoryCode: incident.categoryCode,
                            incidentType: incident.incidentTypeId.toString(),
                            color: cs.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              incident.categoryName,
                              style: TextStyle(
                                color: cs.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Tooltip(
                            message: 'Prioridad del reporte',
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: priorityColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    incident.suggestedPriority.toUpperCase(),
                                    style: TextStyle(
                                      color: priorityColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        'Nº: ${incident.incidentCode}',
                        style: TextStyle(
                          color: cs.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Incident Title/Type
                Text(
                  incident.incidentTypeName,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Description snippet
                Text(
                  incident.reportDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                Divider(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                  height: 1,
                ),
                const SizedBox(height: 12),

                // Footer Info: connectionId, Date & Status badge
                Row(
                  children: [
                    Icon(
                      incident.connectionId != null
                          ? Icons.cable_outlined
                          : Icons.electrical_services,
                      size: 14,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      incident.connectionId != null
                          ? 'Acometida: ${incident.connectionId}'
                          : 'Matriz Principal',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Sector: ${incident.connectionId!.split('-')[0]}',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Date and Origin row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(incident.reportDate),
                      style: TextStyle(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Origen: ${incident.reportOrigin}',
                      style: TextStyle(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                // Status and Order Code row
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(incident.reportDate),
                      style: TextStyle(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                    if (incident.hasWorkOrder)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => context.router.push(
                          WorkOrderProcessRoute(
                            initialOrderCode: incident.orderCode,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: cs.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.assignment_rounded,
                                size: 13,
                                color: cs.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'OT ${incident.orderCode}'
                                '${incident.currentOrderState != null ? '  · ${incident.currentOrderState!.replaceAll('_', ' ')}' : ''}',
                                style: TextStyle(
                                  color: cs.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 14,
                                color: cs.primary,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Text(
                        'Orden: PENDIENTE',
                        style: TextStyle(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  spacing: 8,
                  children: [
                    if (incident.status != 'RESUELTO')
                      Expanded(
                        child: ActionButton(
                          onPressed: () async {
                            final result = await context.router.push(
                              SolveAndChangeMeterIncidentScreen(
                                incidentId: incident.incidentId,
                                incidentCode: incident.incidentCode,
                                connectionId: incident.connectionId,
                              ),
                            );
                            if (result == true && context.mounted) {
                              // Do nothing, list should probably refresh, but we shouldn't pop the whole page.
                            }
                          },
                          icon: Icons.water_damage_outlined,
                          label: 'Cambiar medidor',
                          color: AppColors.primary,
                          size: ActionButtonSize.small,
                          disabled: incident.status == 'RESUELTO',
                          hideElevation: incident.status == 'RESUELTO',
                        ),
                      ),
                    /*
                    if (incident.status != 'RESUELTO')
                      Expanded(
                        child: ActionButton(
                          onPressed: () async {
                            final result = await context.router.push(
                              SolveAndChangeMeterIncidentScreen(
                                incidentId: incident.incidentId,
                                incidentCode: incident.incidentCode,
                                connectionId: incident.connectionId,
                              ),
                            );
                            if (result == true && context.mounted) {
                              // Do nothing, list should probably refresh, but we shouldn't pop the whole page.
                            }
                          },
                          icon: Icons.assignment_outlined,
                          label: 'Gestionar',
                          color: AppColors.primary,
                          size: ActionButtonSize.small,
                          disabled: incident.status == 'RESUELTO',
                          hideElevation: incident.status == 'RESUELTO',
                        ),
                      ),
                      */
                    if (incident.latitude != null && incident.longitude != null)
                      Expanded(
                        child: ActionButton(
                          onPressed: () async {
                            try {
                              final mapService =
                                  GetIt.I<MapNavigationService>();
                              await mapService.navigateTo(
                                incident.latitude!,
                                incident.longitude!,
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString().replaceAll(
                                        'Exception: ',
                                        '',
                                      ),
                                    ),
                                    backgroundColor: cs.error,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Icons.location_on_rounded,
                          label: 'Cómo llegar',
                          color: AppColors.secondary,
                          size: ActionButtonSize.small,
                        ),
                      ),
                    if (!incident.hasWorkOrder)
                      IconButton(
                        onPressed: () async {
                          final created = await AddWorkOrderSheet.show(
                            context,
                            incident,
                          );
                          if (created) onWorkOrderCreated?.call();
                        },
                        icon: const Icon(
                          Icons.assignment_add,
                          size: 18,
                          color: Colors.green,
                        ),
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                          side: const BorderSide(color: Colors.green),
                        ),
                        tooltip: 'Agregar Orden de Trabajo',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconIncidentType extends StatelessWidget {
  final String categoryCode;
  final String incidentType;
  final Color? color;
  final double? size;

  const IconIncidentType({
    super.key,
    required this.categoryCode,
    required this.incidentType,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    IconData getIconData() {
      switch (categoryCode) {
        case 'AGUA_POTABLE':
          // Fugas, roturas y suministro de agua potable
          return Icons.water_drop_outlined;

        case 'ALCANTARILLADO':
          // Red de desagüe, sumideros y alcantarillas
          return Icons.waves_outlined;

        case 'INFRAESTRUCTURA':
          // Cajas portamedidores, llaves de paso, visores
          return Icons.build_circle_outlined;

        case 'DAÑO':
          // Destrucción, roturas físicas o robo de medidores
          return Icons.report_problem_outlined;

        case 'FRAUDE':
          // Manipulación deliberada, bypass o derivaciones clandestinas
          return Icons.gavel_outlined;

        case 'CONSUMO':
          // Discrepancias atípicas de consumo y lecturas
          return Icons.speed_outlined;

        case 'RED_MATRIZ':
          // Red de distribución pública y tuberías principales
          return Icons.alt_route_outlined;

        case 'RUTA_LECTURA':
          // Inspección en ruta reportada por lecturistas en campo
          return Icons.assignment_outlined;

        default:
          switch (incidentType) {
            case '1':
              return Icons.electrical_services_outlined;
            case '2':
              return Icons.water_outlined;
            case '3':
              return Icons.plumbing;
            default:
              return Icons.help_outline_rounded;
          }
      }
    }

    return Icon(getIconData(), color: color, size: size);
  }
}
