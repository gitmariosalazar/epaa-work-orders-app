// features/dashboard/presentation/pages/work_orders_dashboard_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/shared_ui/ui/base/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

@RoutePage()
class WorkOrdersDashboardPage extends StatefulWidget {
  const WorkOrdersDashboardPage({super.key});

  @override
  State<WorkOrdersDashboardPage> createState() =>
      _WorkOrdersDashboardPageState();
}

class _WorkOrdersDashboardPageState extends State<WorkOrdersDashboardPage> {
  // === TUS DATOS REALES DEL ENDPOINT (solo algunos mostrados, agrega todos los 37) ===
  final List<WorkOrderStat> _rawStats = [
    WorkOrderStat.fromJson({
      "totalOrders": "26",
      "statusId": 5,
      "statusName": "En Espera",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "6",
      "urgent": "3",
      "high": "6",
      "medium": "4",
      "low": "7",
      "criticalOrders": "9",
      "createdToday": "0",
      "createdLast7Days": "11",
      "createdThisMonth": "26",
      "closed": "0",
      "completed": "0",
    }),
    WorkOrderStat.fromJson({
      "totalOrders": "24",
      "statusId": 6,
      "statusName": "Reanudada",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "3",
      "urgent": "4",
      "high": "4",
      "medium": "7",
      "low": "6",
      "criticalOrders": "7",
      "createdToday": "0",
      "createdLast7Days": "10",
      "createdThisMonth": "24",
      "closed": "0",
      "completed": "0",
    }),
    WorkOrderStat.fromJson({
      "totalOrders": "22",
      "statusId": 3,
      "statusName": "Reasignada",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "5",
      "urgent": "4",
      "high": "4",
      "medium": "7",
      "low": "2",
      "criticalOrders": "9",
      "createdToday": "0",
      "createdLast7Days": "8",
      "createdThisMonth": "22",
      "closed": "0",
      "completed": "0",
    }),
    WorkOrderStat.fromJson({
      "totalOrders": "22",
      "statusId": 8,
      "statusName": "Cancelada",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "6",
      "urgent": "7",
      "high": "3",
      "medium": "3",
      "low": "3",
      "criticalOrders": "13",
      "createdToday": "0",
      "createdLast7Days": "10",
      "createdThisMonth": "22",
      "closed": "22",
      "completed": "0",
    }),
    WorkOrderStat.fromJson({
      "totalOrders": "21",
      "statusId": 4,
      "statusName": "En Progreso",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "5",
      "urgent": "3",
      "high": "3",
      "medium": "6",
      "low": "4",
      "criticalOrders": "8",
      "createdToday": "0",
      "createdLast7Days": "10",
      "createdThisMonth": "21",
      "closed": "0",
      "completed": "0",
    }),
    WorkOrderStat.fromJson({
      "totalOrders": "21",
      "statusId": 7,
      "statusName": "Completada",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "2",
      "urgent": "2",
      "high": "5",
      "medium": "6",
      "low": "6",
      "criticalOrders": "4",
      "createdToday": "0",
      "createdLast7Days": "10",
      "createdThisMonth": "21",
      "closed": "21",
      "completed": "21",
    }),
    WorkOrderStat.fromJson({
      "totalOrders": "17",
      "statusId": 2,
      "statusName": "Asignada",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "4",
      "urgent": "6",
      "high": "0",
      "medium": "6",
      "low": "1",
      "criticalOrders": "10",
      "createdToday": "0",
      "createdLast7Days": "4",
      "createdThisMonth": "17",
      "closed": "0",
      "completed": "0",
    }),
    WorkOrderStat.fromJson({
      "totalOrders": "17",
      "statusId": 1,
      "statusName": "Pendiente",
      "workTypeId": 3,
      "workType": "COMERCIALIZACION",
      "departmentId": 2,
      "departmentName": "COMERCIALIZACION",
      "emergency": "2",
      "urgent": "6",
      "high": "6",
      "medium": "1",
      "low": "2",
      "criticalOrders": "8",
      "createdToday": "0",
      "createdLast7Days": "11",
      "createdThisMonth": "17",
      "closed": "0",
      "completed": "0",
    }),
    // ... (agrega los otros 29 registros exactamente igual)
  ];

  late List<WorkOrderStat> _filteredStats;
  String _searchQuery = '';

  Set<String> _selectedDepartments = {};
  Set<String> _selectedWorkTypes = {};

  @override
  void initState() {
    super.initState();
    _filteredStats = List.from(_rawStats);
    _selectedDepartments = {'DIRECCION TECNICA', 'COMERCIALIZACION'};
    _selectedWorkTypes = {
      'ALCANTARILLADO',
      'AGUA POTABLE',
      'COMERCIALIZACION',
      'MANTENIMIENTO',
      'LABORATORIO',
    };
    _updateFilteredData();
  }

  void _updateFilteredData() {
    _filteredStats = _rawStats.where((stat) {
      final matchesSearch =
          stat.workType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          stat.departmentName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesDept = _selectedDepartments.contains(stat.departmentName);
      final matchesType = _selectedWorkTypes.contains(stat.workType);
      return matchesSearch && matchesDept && matchesType;
    }).toList();
    setState(() {});
  }

  void _toggleDepartment(String dept) {
    setState(() {
      if (_selectedDepartments.contains(dept)) {
        _selectedDepartments.remove(dept);
      } else {
        _selectedDepartments.add(dept);
      }
      _updateFilteredData();
    });
  }

  void _toggleWorkType(String type) {
    setState(() {
      if (_selectedWorkTypes.contains(type)) {
        _selectedWorkTypes.remove(type);
      } else {
        _selectedWorkTypes.add(type);
      }
      _updateFilteredData();
    });
  }

  void _selectAll() {
    setState(() {
      _selectedDepartments = {'DIRECCION TECNICA', 'COMERCIALIZACION'};
      _selectedWorkTypes = {
        'ALCANTARILLADO',
        'AGUA POTABLE',
        'COMERCIALIZACION',
        'MANTENIMIENTO',
        'LABORATORIO',
      };
      _updateFilteredData();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedDepartments.clear();
      _selectedWorkTypes.clear();
      _updateFilteredData();
    });
  }

  int get totalDisplayedOrders =>
      _filteredStats.fold(0, (sum, s) => sum + s.totalOrders);
  int get totalCritical =>
      _filteredStats.fold(0, (sum, s) => sum + s.criticalOrders);
  int get totalCompleted =>
      _filteredStats.fold(0, (sum, s) => sum + s.completed);
  int get totalClosed => _filteredStats.fold(0, (sum, s) => sum + s.closed);
  int get createdLast7Days =>
      _filteredStats.fold(0, (sum, s) => sum + s.createdLast7Days);
  int get createdThisMonth =>
      _filteredStats.fold(0, (sum, s) => sum + s.createdThisMonth);

  Map<String, int> _groupByWorkType() {
    final map = <String, int>{};
    for (var s in _filteredStats) {
      map[s.workType] = (map[s.workType] ?? 0) + s.totalOrders;
    }
    return map;
  }

  Map<String, int> _groupByStatus() {
    final map = <String, int>{};
    for (var s in _filteredStats) {
      map[s.statusName] = (map[s.statusName] ?? 0) + s.totalOrders;
    }
    return map;
  }

  final Map<String, Color> workTypeColors = {
    'ALCANTARILLADO': Colors.brown[600]!,
    'AGUA POTABLE': Colors.blue[700]!,
    'COMERCIALIZACION': Colors.green[700]!,
    'MANTENIMIENTO': Colors.orange[700]!,
    'LABORATORIO': Colors.purple[700]!,
  };

  final Map<String, IconData> workTypeIcons = {
    'ALCANTARILLADO': Icons.plumbing,
    'AGUA POTABLE': Icons.water_drop,
    'COMERCIALIZACION': Icons.attach_money,
    'MANTENIMIENTO': Icons.build,
    'LABORATORIO': Icons.science,
  };

  final Map<String, Color> statusColors = {
    'Pendiente': Colors.grey,
    'Asignada': Colors.blue,
    'Reasignada': Colors.orange,
    'En Progreso': Colors.purple,
    'En Espera': Colors.amber,
    'Reanudada': Colors.teal,
    'Completada': Colors.green,
    'Cancelada': Colors.red,
  };

  final Map<String, IconData> statusIcons = {
    'Pendiente': Icons.schedule,
    'Asignada': Icons.assignment_ind,
    'Reasignada': Icons.swap_horiz,
    'En Progreso': Icons.handyman,
    'En Espera': Icons.pause_circle,
    'Reanudada': Icons.play_circle,
    'Completada': Icons.check_circle,
    'Cancelada': Icons.cancel,
  };

  @override
  Widget build(BuildContext context) {
    final workTypeData = _groupByWorkType();
    final statusData = _groupByStatus();

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Dashboard Órdenes de Trabajo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectAll();
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
            // === FILTROS (CORREGIDO: Row + Expanded en lugar de Flexible) ===
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
                        'Filtrar por:',
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
                      _searchQuery = v;
                      _updateFilteredData();
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Departamentos',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4.0,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 24,
                        ),
                    itemCount: ['DIRECCION TECNICA', 'COMERCIALIZACION'].length,
                    itemBuilder: (context, index) {
                      final dept = [
                        'DIRECCION TECNICA',
                        'COMERCIALIZACION',
                      ][index];
                      final isSelected = _selectedDepartments.contains(dept);
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dept,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        value: isSelected,
                        activeColor: Colors.blue,
                        onChanged: (_) => _toggleDepartment(dept),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tipos de Trabajo',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4.0,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 24,
                        ),
                    itemCount: workTypeColors.keys.length,
                    itemBuilder: (context, index) {
                      final type = workTypeColors.keys.toList()[index];
                      final isSelected = _selectedWorkTypes.contains(type);
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        secondary: Icon(
                          workTypeIcons[type],
                          color: workTypeColors[type],
                          size: 16,
                        ),
                        value: isSelected,
                        activeColor: workTypeColors[type],
                        onChanged: (_) => _toggleWorkType(type),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // === RESUMEN CON TODOS LOS KPIs ===
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isWide = constraints.maxWidth > 700;
                final int crossCount = isWide ? 7 : 3;
                final double aspectRatio = isWide ? 1.8 : 1.4;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossCount,
                  childAspectRatio: aspectRatio,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _SummaryCard(
                      title: 'Total Visible',
                      value: NumberFormat.compact().format(
                        totalDisplayedOrders,
                      ),
                      icon: Icons.assignment,
                      color: Colors.indigo,
                    ),
                    _SummaryCard(
                      title: 'Tipos Activos',
                      value: workTypeData.length.toString(),
                      icon: Icons.category,
                      color: Colors.teal,
                    ),
                    _SummaryCard(
                      title: 'Órdenes Críticas',
                      value: totalCritical.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                    ),
                    _SummaryCard(
                      title: 'Completadas',
                      value: NumberFormat.compact().format(totalCompleted),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                    _SummaryCard(
                      title: 'Cerradas',
                      value: totalClosed.toString(),
                      icon: Icons.folder_special,
                      color: Colors.grey[700]!,
                    ),
                    _SummaryCard(
                      title: 'Últ. 7 Días',
                      value: createdLast7Days.toString(),
                      icon: Icons.today,
                      color: Colors.orange,
                    ),
                    _SummaryCard(
                      title: 'Este Mes',
                      value: createdThisMonth.toString(),
                      icon: Icons.calendar_month,
                      color: Colors.purple,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            _PieWithLegendCard(
              title: 'Distribución por Tipo de Trabajo',
              data: workTypeData,
              colors: workTypeColors,
              icons: workTypeIcons,
              total: totalDisplayedOrders,
            ),

            const SizedBox(height: 16),

            _PieWithLegendCard(
              title: 'Distribución por Estado',
              data: statusData,
              colors: statusColors,
              icons: statusIcons,
              total: totalDisplayedOrders,
            ),

            const SizedBox(height: 16),

            const Text(
              'Detalle por Tipo de Trabajo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: workTypeData.entries.map((entry) {
                final color = workTypeColors[entry.key]!;
                final percentage = totalDisplayedOrders > 0
                    ? (entry.value / totalDisplayedOrders) * 100
                    : 0.0;
                return _DetailCard(
                  name: entry.key,
                  icon: workTypeIcons[entry.key]!,
                  color: color,
                  quantity: entry.value,
                  percentage: percentage.toDouble(),
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

// === MODEL ===
class WorkOrderStat {
  final int totalOrders;
  final String statusName;
  final String workType;
  final String departmentName;
  final int criticalOrders;
  final int completed;
  final int closed;
  final int createdLast7Days;
  final int createdThisMonth;

  WorkOrderStat({
    required this.totalOrders,
    required this.statusName,
    required this.workType,
    required this.departmentName,
    required this.criticalOrders,
    required this.completed,
    required this.closed,
    required this.createdLast7Days,
    required this.createdThisMonth,
  });

  factory WorkOrderStat.fromJson(Map<String, dynamic> json) {
    return WorkOrderStat(
      totalOrders: int.tryParse(json['totalOrders']?.toString() ?? '0') ?? 0,
      statusName: json['statusName']?.toString() ?? '',
      workType: json['workType']?.toString() ?? '',
      departmentName: json['departmentName']?.toString() ?? '',
      criticalOrders:
          int.tryParse(json['criticalOrders']?.toString() ?? '0') ?? 0,
      completed: int.tryParse(json['completed']?.toString() ?? '0') ?? 0,
      closed: int.tryParse(json['closed']?.toString() ?? '0') ?? 0,
      createdLast7Days:
          int.tryParse(json['createdLast7Days']?.toString() ?? '0') ?? 0,
      createdThisMonth:
          int.tryParse(json['createdThisMonth']?.toString() ?? '0') ?? 0,
    );
  }
}

// === _SummaryCard ===
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 0),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 0),
          Text(
            title,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// === _PieWithLegendCard ===
class _PieWithLegendCard extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final Map<String, Color> colors;
  final Map<String, IconData> icons;
  final int total;

  const _PieWithLegendCard({
    required this.title,
    required this.data,
    required this.colors,
    required this.icons,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Card(
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
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: entries.map((entry) {
                    final percentage = total > 0
                        ? (entry.value / total) * 100
                        : 0;
                    return PieChartSectionData(
                      color: colors[entry.key]!,
                      value: entry.value.toDouble(),
                      title:
                          '${percentage.toStringAsFixed(1)}%\n${NumberFormat.compact().format(entry.value)}',
                      radius: 70,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
              ),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final color = colors[entry.key]!;
                final percentage = total > 0 ? (entry.value / total) * 100 : 0;
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
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '${NumberFormat.compact().format(entry.value)} órdenes • ${percentage.toStringAsFixed(1)}%',
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
    );
  }
}

// === _DetailCard ===
class _DetailCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int quantity;
  final double percentage;

  const _DetailCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.quantity,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
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
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            NumberFormat.compact().format(quantity),
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
  }
}
