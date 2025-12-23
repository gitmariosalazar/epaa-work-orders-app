import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Datos reales de tus órdenes (solo los campos necesarios para mostrar)
  final List<_MiniOrder> _recentOrders = const [
    _MiniOrder(
      orderCode: "OT-2025-0000004",
      workTypeId: 1,
      priorityId: 1,
      status: 1,
      description: "nuevo ejemplo",
      cadastralKey: "43-32",
      creationDate: "19 Dic 2025",
    ),
    _MiniOrder(
      orderCode: "OT-2025-0000003",
      workTypeId: 2,
      priorityId: 3,
      status: 1,
      description: "Fix the leaking pipe in the basement.",
      cadastralKey: "ABC123XYZ",
      creationDate: "16 Dic 2025",
    ),
    _MiniOrder(
      orderCode: "OT-2025-0000001",
      workTypeId: 2,
      priorityId: 5,
      status: 1,
      description: "Fuga grave en calle principal",
      cadastralKey: "12-36",
      creationDate: "16 Dic 2025",
    ),
  ];

  // Métodos de ayuda (iguales que en WorkOrderCard)
  String _getPriorityText(int priorityId) {
    switch (priorityId) {
      case 1:
        return 'Baja';
      case 2:
        return 'Media';
      case 3:
        return 'Alta';
      case 4:
        return 'Urgente';
      case 5:
        return 'Emergencia';
      default:
        return 'Desconocida';
    }
  }

  Color _getPriorityColor(int priorityId) {
    switch (priorityId) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.red[900]!;
      default:
        return Colors.grey;
    }
  }

  bool _isUrgent(int priorityId) => priorityId >= 4;

  String _getStatusText(int status) {
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

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
      case 2:
      case 3:
        return Colors.orange;
      case 4:
      case 5:
      case 6:
        return Colors.blue;
      case 7:
        return Colors.green;
      case 8:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getWorkTypeText(int workTypeId) {
    switch (workTypeId) {
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

  IconData _getWorkTypeIcon(int workTypeId) {
    switch (workTypeId) {
      case 1:
        return Icons.plumbing;
      case 2:
        return Icons.water_drop;
      case 3:
        return Icons.store;
      case 4:
        return Icons.build;
      case 5:
        return Icons.science;
      default:
        return Icons.work;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil1'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: const Icon(Icons.logout), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _TopPortion(),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Mario Salazar",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize! +
                          4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Software Developer | Epaa Inc.",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        label: const Text("Editar Perfil"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_today),
                        label: const Text("Mi Horario"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _ProfileStatsRow(),
                  const SizedBox(height: 10),
                  const _AboutSection(),
                  const SizedBox(height: 10),
                  _RecentOrdersSection(orders: _recentOrders, helpers: this),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard más compacto
class _ProfileStatsRow extends StatelessWidget {
  const _ProfileStatsRow();

  final List<ProfileStatItem> _items = const [
    ProfileStatItem("Completados", 450, Icons.check_circle, Colors.green),
    ProfileStatItem("Pendientes", 15, Icons.hourglass_empty, Colors.orange),
    ProfileStatItem("Tiempo Prom.", "2.5 hrs", Icons.timer, Colors.blue),
    ProfileStatItem("Calificación", "4.8/5", Icons.star, Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _items
              .map(
                (item) => Expanded(
                  child: Column(
                    children: [
                      Icon(item.icon, color: item.color, size: 24),
                      const SizedBox(height: 6),
                      Text(
                        item.value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ProfileStatItem {
  final String title;
  final dynamic value;
  final IconData icon;
  final Color color;
  const ProfileStatItem(this.title, this.value, this.icon, this.color);
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Acerca de mí",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Desarrollador de software con más de 10 años de experiencia en mantenimiento y reparación de sistemas eléctricos. "
              "Especializado en órdenes de trabajo industriales, sistemas HVAC y respuestas de emergencia. "
              "Comprometido con la seguridad y la eficiencia.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Text(
                  "mariosalazar.ms.10@gmail.com",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Text(
                  "+539 999 453 2438",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Text(
                  "El Tejar, Ibarra - Ecuador",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  final List<String> _skills = const [
    "Cableado Eléctrico",
    "Mantenimiento HVAC",
    "Conceptos Básicos de Plomería",
    "Protocolos de Seguridad",
    "Competencia en Herramientas",
    "Respuesta a Emergencias",
    "Pruebas de Diagnóstico",
    "Gestión de Proyectos",
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Habilidades y Certificaciones",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills
                  .map(
                    (skill) => Chip(
                      label: Text(
                        skill,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      backgroundColor: Colors.blue[100],
                      avatar: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Órdenes recientes compactas y con el estilo exacto de WorkOrderCard
class _RecentOrdersSection extends StatelessWidget {
  final List<_MiniOrder> orders;
  final ProfilePage helpers;

  const _RecentOrdersSection({required this.orders, required this.helpers});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Órdenes Recientes",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Ver Todo",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...orders.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MiniOrderCard(order: order, helpers: helpers),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniOrder {
  final String orderCode;
  final int workTypeId;
  final int priorityId;
  final int status;
  final String description;
  final String cadastralKey;
  final String creationDate;

  const _MiniOrder({
    required this.orderCode,
    required this.workTypeId,
    required this.priorityId,
    required this.status,
    required this.description,
    required this.cadastralKey,
    required this.creationDate,
  });
}

class _MiniOrderCard extends StatelessWidget {
  final _MiniOrder order;
  final ProfilePage helpers;

  const _MiniOrderCard({required this.order, required this.helpers});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderCode,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            helpers._getWorkTypeIcon(order.workTypeId),
                            size: 15,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            helpers._getWorkTypeText(order.workTypeId),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusChip(
                      text: helpers._getStatusText(order.status),
                      color: helpers._getStatusColor(order.status),
                    ),
                    const SizedBox(height: 4),
                    _PriorityChip(
                      text: helpers._getPriorityText(order.priorityId),
                      color: helpers._getPriorityColor(order.priorityId),
                      isUrgent: helpers._isUrgent(order.priorityId),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              order.description,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.vpn_key, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Clave: ${order.cadastralKey}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  order.creationDate,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Chips idénticos a los de WorkOrderCard
class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool isUrgent;

  const _PriorityChip({
    required this.text,
    required this.color,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(isUrgent ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: isUrgent ? 2.0 : 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUrgent) ...[
            Icon(Icons.warning, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff006df1), Color(0xff0043ba)],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      child: Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
