// features/dashboard/presentation/pages/dashboard_status/dashboard_status_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

@RoutePage()
class DashboardWorkStatusPage extends StatefulWidget {
  const DashboardWorkStatusPage({super.key});

  @override
  State<DashboardWorkStatusPage> createState() =>
      _DashboardWorkStatusPageState();
}

class _DashboardWorkStatusPageState extends State<DashboardWorkStatusPage> {
  // TUS DATOS REALES DE ESTADOS
  static final List<OrderStatusEntity> _allData = [
    const OrderStatusEntity(
      statusName: "Completada",
      statusId: 7,
      statusDescription: "Orden de trabajo finalizada exitosamente",
      quantity: 321,
      percentageOfTotal: 12.85,
    ),
    const OrderStatusEntity(
      statusName: "Reanudada",
      statusId: 6,
      statusDescription: "Orden de trabajo reanudada después de una pausa",
      quantity: 319,
      percentageOfTotal: 12.77,
    ),
    const OrderStatusEntity(
      statusName: "Pendiente",
      statusId: 1,
      statusDescription: "Orden de trabajo pendiente de asignación",
      quantity: 318,
      percentageOfTotal: 12.73,
    ),
    const OrderStatusEntity(
      statusName: "En Progreso",
      statusId: 4,
      statusDescription: "Orden de trabajo en proceso de ejecución",
      quantity: 316,
      percentageOfTotal: 12.65,
    ),
    const OrderStatusEntity(
      statusName: "En Espera",
      statusId: 5,
      statusDescription: "Orden de trabajo en espera por alguna razón",
      quantity: 314,
      percentageOfTotal: 12.57,
    ),
    const OrderStatusEntity(
      statusName: "Cancelada",
      statusId: 8,
      statusDescription: "Orden de trabajo cancelada",
      quantity: 314,
      percentageOfTotal: 12.57,
    ),
    const OrderStatusEntity(
      statusName: "Reasignada",
      statusId: 3,
      statusDescription: "Orden de trabajo reasignada a otro trabajador",
      quantity: 309,
      percentageOfTotal: 12.37,
    ),
    const OrderStatusEntity(
      statusName: "Asignada",
      statusId: 2,
      statusDescription: "Orden de trabajo asignada a un trabajador",
      quantity: 287,
      percentageOfTotal: 11.49,
    ),
  ];

  final Map<int, Color> statusColors = {
    1: Colors.grey, // Pendiente
    2: Colors.blue, // Asignada
    3: Colors.orange, // Reasignada
    4: Colors.purple, // En Progreso
    5: Colors.amber, // En Espera
    6: Colors.teal, // Reanudada
    7: Colors.green, // Completada
    8: Colors.red, // Cancelada
  };

  final Map<int, IconData> statusIcons = {
    1: Icons.schedule,
    2: Icons.assignment_ind,
    3: Icons.swap_horiz,
    4: Icons.handyman,
    5: Icons.pause_circle,
    6: Icons.play_circle,
    7: Icons.check_circle,
    8: Icons.cancel,
  };

  late Set<int> selectedStatusIds;
  late List<OrderStatusEntity> displayedData;
  int totalDisplayedOrders = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedStatusIds = _allData.map((e) => e.statusId).toSet();
    _updateDisplayedData();
  }

  void _updateDisplayedData() {
    displayedData = _allData.where((p) {
      final matchesSearch = p.statusName.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return selectedStatusIds.contains(p.statusId) && matchesSearch;
    }).toList();

    totalDisplayedOrders = displayedData.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
    setState(() {});
  }

  void _toggleStatus(int statusId) {
    setState(() {
      if (selectedStatusIds.contains(statusId)) {
        selectedStatusIds.remove(statusId);
      } else {
        selectedStatusIds.add(statusId);
      }
      _updateDisplayedData();
    });
  }

  void _selectAll() {
    setState(() {
      selectedStatusIds = _allData.map((e) => e.statusId).toSet();
      _updateDisplayedData();
    });
  }

  void _clearSelection() {
    setState(() {
      selectedStatusIds.clear();
      _updateDisplayedData();
    });
  }

  List<PieChartSectionData> getSections() {
    if (displayedData.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey[300]!,
          value: 1,
          title: 'Sin datos',
          radius: 70,
          titleStyle: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ];
    }

    return displayedData.map((item) {
      final double percentage = totalDisplayedOrders > 0
          ? (item.quantity / totalDisplayedOrders) * 100
          : 0;
      return PieChartSectionData(
        color: statusColors[item.statusId]!,
        value: item.quantity.toDouble(),
        title:
            '${percentage.toStringAsFixed(1)}%\n${NumberFormat.compact().format(item.quantity)}',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Estados de Órdenes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedStatusIds = _allData.map((e) => e.statusId).toSet();
                _updateDisplayedData();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtrar estados',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _selectAll,
                            child: const Text(
                              'Todas',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          TextButton(
                            onPressed: _clearSelection,
                            child: const Text(
                              'Ninguna',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (v) {
                      searchQuery = v;
                      _updateDisplayedData();
                    },
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4.0,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 34,
                        ),
                    itemCount: _allData.length,
                    itemBuilder: (context, index) {
                      final item = _allData[index];
                      final isSelected = selectedStatusIds.contains(
                        item.statusId,
                      );

                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          item.statusName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondary: Icon(
                          statusIcons[item.statusId],
                          color: statusColors[item.statusId],
                          size: 16,
                        ),
                        value: isSelected,
                        activeColor: statusColors[item.statusId],
                        onChanged: (_) => _toggleStatus(item.statusId),
                        visualDensity: VisualDensity.standard,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatusSummaryCard(
                    title: 'Total Visible',
                    value: NumberFormat.compact().format(totalDisplayedOrders),
                    icon: Icons.assignment,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatusSummaryCard(
                    title: 'Estados Activos',
                    value: displayedData.length.toString(),
                    icon: Icons.category,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gráfico + Leyenda en 2 columnas
            Card(
              elevation: 0,
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Distribución por Estado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: getSections(),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 6,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4.5,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 16,
                          ),
                      itemCount: displayedData.length,
                      itemBuilder: (context, index) {
                        final item = displayedData[index];
                        final color = statusColors[item.statusId]!;
                        final double percentage = totalDisplayedOrders > 0
                            ? (item.quantity / totalDisplayedOrders) * 100
                            : 0;

                        return Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.statusName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat.compact().format(item.quantity)} órdenes • ${percentage.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Detalle por Estado',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: displayedData.map((item) {
                final color = statusColors[item.statusId]!;
                final double percentage = totalDisplayedOrders > 0
                    ? (item.quantity / totalDisplayedOrders) * 100
                    : 0;

                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              statusIcons[item.statusId],
                              color: color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.statusName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        NumberFormat.compact().format(item.quantity),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${percentage.toStringAsFixed(1)} %',
                        style: TextStyle(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Tarjeta de resumen
class _StatusSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}

// Entidad
class OrderStatusEntity {
  final String statusName;
  final int statusId;
  final String statusDescription;
  final int quantity;
  final double percentageOfTotal;

  const OrderStatusEntity({
    required this.statusName,
    required this.statusId,
    required this.statusDescription,
    required this.quantity,
    required this.percentageOfTotal,
  });
}
