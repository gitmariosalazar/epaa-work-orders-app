// features/dashboard/presentation/pages/dashboard_work_types/dashboard_work_types_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

@RoutePage()
class DashboardWorkTypesPage extends StatefulWidget {
  const DashboardWorkTypesPage({super.key});

  @override
  State<DashboardWorkTypesPage> createState() => _DashboardWorkTypesPageState();
}

class _DashboardWorkTypesPageState extends State<DashboardWorkTypesPage> {
  // TUS DATOS REALES
  static final List<WorkTypeEntity> _allData = [
    const WorkTypeEntity(
      workType: "MANTENIMIENTO",
      workTypeId: 4,
      quantity: 515,
      completed: 63,
      completionRatePercentage: 12.23,
    ),
    const WorkTypeEntity(
      workType: "LABORATORIO",
      workTypeId: 5,
      quantity: 510,
      completed: 60,
      completionRatePercentage: 11.76,
    ),
    const WorkTypeEntity(
      workType: "AGUA POTABLE",
      workTypeId: 2,
      quantity: 496,
      completed: 64,
      completionRatePercentage: 12.90,
    ),
    const WorkTypeEntity(
      workType: "ALCANTARILLADO",
      workTypeId: 1,
      quantity: 493,
      completed: 68,
      completionRatePercentage: 13.79,
    ),
    const WorkTypeEntity(
      workType: "COMERCIALIZACION",
      workTypeId: 3,
      quantity: 484,
      completed: 66,
      completionRatePercentage: 13.64,
    ),
  ];

  // Colores personalizados por tipo (igual estilo que prioridades)
  final Map<int, Color> typeColors = {
    1: Colors.brown, // ALCANTARILLADO
    2: Colors.blue, // AGUA POTABLE
    3: Colors.green, // COMERCIALIZACION
    4: Colors.orange, // MANTENIMIENTO
    5: Colors.purple, // LABORATORIO
  };

  final Map<int, IconData> typeIcons = {
    1: Icons.plumbing,
    2: Icons.water_drop,
    3: Icons.store,
    4: Icons.build,
    5: Icons.science,
  };

  late Set<int> selectedTypeIds;
  late List<WorkTypeEntity> displayedData;
  int totalDisplayedQuantity = 0;
  int totalDisplayedCompleted = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedTypeIds = _allData.map((e) => e.workTypeId).toSet();
    _updateDisplayedData();
  }

  void _updateDisplayedData() {
    displayedData = _allData.where((p) {
      final matchesSearch = p.workType.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return selectedTypeIds.contains(p.workTypeId) && matchesSearch;
    }).toList();

    totalDisplayedQuantity = displayedData.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
    totalDisplayedCompleted = displayedData.fold(
      0,
      (sum, item) => sum + item.completed,
    );

    setState(() {});
  }

  void _toggleType(int typeId) {
    setState(() {
      if (selectedTypeIds.contains(typeId)) {
        selectedTypeIds.remove(typeId);
      } else {
        selectedTypeIds.add(typeId);
      }
      _updateDisplayedData();
    });
  }

  void _selectAll() {
    setState(() {
      selectedTypeIds = _allData.map((e) => e.workTypeId).toSet();
      _updateDisplayedData();
    });
  }

  void _clearSelection() {
    setState(() {
      selectedTypeIds.clear();
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
      final double percentage = totalDisplayedQuantity > 0
          ? (item.quantity / totalDisplayedQuantity) * 100
          : 0;
      return PieChartSectionData(
        color: typeColors[item.workTypeId]!,
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
        title: const Text('Tipos de Trabajo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedTypeIds = _allData.map((e) => e.workTypeId).toSet();
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
                        'Filtrar tipos',
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
                      final isSelected = selectedTypeIds.contains(
                        item.workTypeId,
                      );

                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        title: Text(
                          item.workType,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondary: Icon(
                          typeIcons[item.workTypeId],
                          color: typeColors[item.workTypeId],
                          size: 16,
                        ),
                        value: isSelected,
                        activeColor: typeColors[item.workTypeId],
                        onChanged: (_) => _toggleType(item.workTypeId),
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
                  child: _WorkTypeSummaryCard(
                    title: 'Total Visible',
                    value: NumberFormat.compact().format(
                      totalDisplayedQuantity,
                    ),
                    icon: Icons.work,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _WorkTypeSummaryCard(
                    title: 'Completadas',
                    value: NumberFormat.compact().format(
                      totalDisplayedCompleted,
                    ),
                    icon: Icons.check_circle,
                    color: Colors.green,
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
                      'Distribución por Tipo',
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
                        final color = typeColors[item.workTypeId]!;
                        final double percentage = totalDisplayedQuantity > 0
                            ? (item.quantity / totalDisplayedQuantity) * 100
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
                                    item.workType,
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
              'Detalle por Tipo',
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
                final color = typeColors[item.workTypeId]!;
                final double completionRate = item.completionRatePercentage;

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
                              typeIcons[item.workTypeId],
                              color: color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.workType,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
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
                        '${completionRate.toStringAsFixed(1)}% completadas',
                        style: TextStyle(
                          fontSize: 10,
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
class _WorkTypeSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _WorkTypeSummaryCard({
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
class WorkTypeEntity {
  final String workType;
  final int workTypeId;
  final int quantity;
  final int completed;
  final double completionRatePercentage;

  const WorkTypeEntity({
    required this.workType,
    required this.workTypeId,
    required this.quantity,
    required this.completed,
    required this.completionRatePercentage,
  });
}
