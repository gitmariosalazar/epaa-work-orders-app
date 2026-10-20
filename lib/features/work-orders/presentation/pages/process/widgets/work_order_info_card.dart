import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkOrderInfoCard extends StatelessWidget {
  final WorkOrderDetailEntity order;

  const WorkOrderInfoCard({super.key, required this.order});

  Future<void> _openLocationInMap(BuildContext context) async {
    final lat = order.latitud;
    final lng = order.longitud;
    final address = order.direccion ?? '';

    Uri url;
    if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
      url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
    } else if (address.isNotEmpty) {
      url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay información de ubicación disponible'),
        ),
      );
      return;
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el mapa')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.contact_page_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Información del Predio y Solicitante',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => _openLocationInMap(context),
                  icon: const Icon(Icons.location_on_outlined, size: 16),
                  label: const Text('Mapa', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 16),
            _buildRow(
              context,
              'Cliente / Usuario',
              order.nombreCliente ?? 'No registrado',
              icon: Icons.person_outline,
            ),
            if (order.identificacionCliente != null &&
                order.identificacionCliente!.isNotEmpty)
              _buildRow(
                context,
                'Cédula / RUC',
                order.identificacionCliente!,
                icon: Icons.badge_outlined,
              ),
            if (order.telefonoCliente != null &&
                order.telefonoCliente!.isNotEmpty)
              _buildRow(
                context,
                'Teléfono',
                order.telefonoCliente!,
                icon: Icons.phone_outlined,
              ),
            _buildRow(
              context,
              'Clave Catastral',
              order.claveCatastral ?? 'S/N',
              icon: Icons.home_work_outlined,
            ),
            if (order.cuentaContrato != null &&
                order.cuentaContrato!.isNotEmpty)
              _buildRow(
                context,
                'Cuenta Contrato',
                order.cuentaContrato!,
                icon: Icons.numbers_outlined,
              ),
            _buildRow(
              context,
              'Dirección',
              order.direccion ?? 'Sin dirección registrada',
              icon: Icons.place_outlined,
            ),
            if (order.barrio != null && order.barrio!.isNotEmpty)
              _buildRow(
                context,
                'Barrio / Sector',
                order.barrio!,
                icon: Icons.location_city_outlined,
              ),
            if (order.numeroMedidor != null && order.numeroMedidor!.isNotEmpty)
              _buildRow(
                context,
                'Nº Medidor',
                order.numeroMedidor!,
                icon: Icons.speed_outlined,
              ),
            if (order.descripcion != null && order.descripcion!.isNotEmpty) ...[
              const Divider(height: 16),
              const Text(
                'Descripción del Trabajo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
              const SizedBox(height: 4),
              Text(
                order.descripcion!,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? cs.onSurface : Colors.grey.shade800,
                  height: 1.3,
                ),
              ),
            ],
            if (order.observaciones.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Observaciones Previas:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
              const SizedBox(height: 4),
              Text(
                order.observaciones.map((o) => o.texto).join('\n'),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? cs.onSurfaceVariant : Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {IconData? icon}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: isDark ? cs.onSurfaceVariant : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
          ],
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? cs.onSurfaceVariant : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
