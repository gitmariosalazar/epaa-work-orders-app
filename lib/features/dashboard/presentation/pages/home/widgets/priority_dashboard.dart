// features/dashboard/presentation/pages/dashboard_priorities/dashboard_priorities_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

@RoutePage()
class DashboardPrioritiesPage extends StatefulWidget {
  const DashboardPrioritiesPage({super.key});

  @override
  State<DashboardPrioritiesPage> createState() =>
      _DashboardPrioritiesPageState();
}

class _DashboardPrioritiesPageState extends State<DashboardPrioritiesPage> {
  static final List<PriorityDashboardEntity> _allData = [
    const PriorityDashboardEntity(
      priorityLevel: "Emergencia",
      priorityId: 5,
      quantity: 491,
      percentageOfTotal: 19.66,
    ),
    const PriorityDashboardEntity(
      priorityLevel: "Urgente",
      priorityId: 4,
      quantity: 544,
      percentageOfTotal: 21.78,
    ),
    const PriorityDashboardEntity(
      priorityLevel: "Alta",
      priorityId: 3,
      quantity: 479,
      percentageOfTotal: 19.18,
    ),
    const PriorityDashboardEntity(
      priorityLevel: "Media",
      priorityId: 2,
      quantity: 484,
      percentageOfTotal: 19.38,
    ),
    const PriorityDashboardEntity(
      priorityLevel: "Baja",
      priorityId: 1,
      quantity: 500,
      percentageOfTotal: 20.02,
    ),
  ];

  final Map<int, Color> priorityColors = {
    5: Colors.red,
    4: Colors.orange,
    3: Colors.amber,
    2: Colors.blue,
    1: Colors.green,
  };

  final Map<int, IconData> priorityIcons = {
    5: Icons.emergency,
    4: Icons.priority_high,
    3: Icons.warning_amber,
    2: Icons.schedule,
    1: Icons.low_priority,
  };

  late Set<int> selectedPriorityIds;
  late List<PriorityDashboardEntity> displayedData;
  int totalDisplayedOrders = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedPriorityIds = _allData.map((e) => e.priorityId).toSet();
    _updateDisplayedData();
  }

  void _updateDisplayedData() {
    displayedData = _allData.where((p) {
      final matchesSearch = p.priorityLevel.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return selectedPriorityIds.contains(p.priorityId) && matchesSearch;
    }).toList();

    totalDisplayedOrders = displayedData.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
    setState(() {});
  }

  void _togglePriority(int priorityId) {
    setState(() {
      if (selectedPriorityIds.contains(priorityId)) {
        selectedPriorityIds.remove(priorityId);
      } else {
        selectedPriorityIds.add(priorityId);
      }
      _updateDisplayedData();
    });
  }

  void _selectAll() {
    setState(() {
      selectedPriorityIds = _allData.map((e) => e.priorityId).toSet();
      _updateDisplayedData();
    });
  }

  void _clearSelection() {
    setState(() {
      selectedPriorityIds.clear();
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
        color: priorityColors[item.priorityId]!,
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
        title: const Text('Prioridades'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedPriorityIds = _allData.map((e) => e.priorityId).toSet();
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
                        'Filtrar prioridades',
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
                      final isSelected = selectedPriorityIds.contains(
                        item.priorityId,
                      );

                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          item.priorityLevel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondary: Icon(
                          priorityIcons[item.priorityId],
                          color: priorityColors[item.priorityId],
                          size: 16,
                        ),
                        value: isSelected,
                        activeColor: priorityColors[item.priorityId],
                        onChanged: (_) => _togglePriority(item.priorityId),
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
                  child: _PrioritySummaryCard(
                    title: 'Total Visible',
                    value: NumberFormat.compact().format(totalDisplayedOrders),
                    icon: Icons.assignment,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PrioritySummaryCard(
                    title: 'Prioridades',
                    value: displayedData.length.toString(),
                    icon: Icons.category,
                    color: Colors.purple,
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
                      'Distribución por Prioridad',
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
                    // === LEYENDA EN 2 COLUMNAS ===
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Siempre 2 columnas
                            childAspectRatio:
                                4.5, // Ajusta para que quepa bien el texto
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 16,
                          ),
                      itemCount: displayedData.length,
                      itemBuilder: (context, index) {
                        final item = displayedData[index];
                        final color = priorityColors[item.priorityId]!;
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
                                    item.priorityLevel,
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
              'Detalle por Prioridad',
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
                final color = priorityColors[item.priorityId]!;
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
                      // Icono con fondo blanco (mejor contraste y profesional)
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
                              priorityIcons[item.priorityId],
                              color: color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Nombre de prioridad
                          Text(
                            item.priorityLevel,
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
                      // Cantidad grande
                      Text(
                        NumberFormat.compact().format(item.quantity),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Porcentaje
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

// Tarjeta de resumen estilo HomePage
class _PrioritySummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _PrioritySummaryCard({
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

// ENTIDAD (sin description)
class PriorityDashboardEntity {
  final String priorityLevel;
  final int priorityId;
  final int quantity;
  final double percentageOfTotal;

  const PriorityDashboardEntity({
    required this.priorityLevel,
    required this.priorityId,
    required this.quantity,
    required this.percentageOfTotal,
  });
}
