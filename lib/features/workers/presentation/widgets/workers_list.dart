// features/workers/presentation/widgets/workers_list.dart

import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:flutter/material.dart';

class WorkersList extends StatelessWidget {
  final List<WorkerEntity> workers;

  const WorkersList({super.key, required this.workers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 3,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${worker.firstNames} ${worker.lastNames}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      _InfoRow(
                        icon: Icons.badge,
                        label: 'Cédula',
                        value: worker.identification,
                      ),
                      if (worker.phoneNumber.isNotEmpty &&
                          worker.phoneNumber.length > 5)
                        _InfoRow(
                          icon: Icons.phone,
                          label: 'Tel',
                          value: worker.phoneNumber,
                        ),
                      if (worker.cellPhone.isNotEmpty &&
                          worker.cellPhone.length > 5)
                        _InfoRow(
                          icon: Icons.smartphone,
                          label: 'Cel',
                          value: worker.cellPhone,
                        ),
                      if (worker.email.isNotEmpty && worker.email.length > 5)
                        _InfoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: worker.email,
                        ),
                      if (worker.address.isNotEmpty)
                        _InfoRow(
                          icon: Icons.location_on,
                          label: 'Dirección',
                          value: worker.address,
                        ),
                    ],
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Funcionalidad en desarrollo'),
                        behavior:
                            SnackBarBehavior.floating, // ← ¡ESTO ES LA CLAVE!
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 24 + MediaQuery.of(context).padding.bottom,
                        ),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Iniciales en la esquina superior derecha (sin ocupar espacio)
              Positioned(
                top: 8 + MediaQuery.of(context).padding.top,
                right: 8 + MediaQuery.of(context).padding.right,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    '${worker.firstNames[0]}${worker.lastNames[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget auxiliar para filas de información
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double? size;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.size = 11,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: size, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: size,
              color: Colors.grey[700],
              fontWeight: FontWeight.w900,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: size ?? 13, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
