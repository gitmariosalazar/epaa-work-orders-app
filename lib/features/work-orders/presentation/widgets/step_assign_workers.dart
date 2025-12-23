// features/work-orders/presentation/widgets/step_assign_workers.dart

import 'package:flutter/material.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';

class StepAssignWorkers extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) updateData;

  const StepAssignWorkers({
    super.key,
    required this.formData,
    required this.updateData,
  });

  @override
  State<StepAssignWorkers> createState() => _StepAssignWorkersState();
}

class _StepAssignWorkersState extends State<StepAssignWorkers> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _workers = [
    {
      "workerId": "3",
      "identification": "1001786498",
      "fullName": "JORGE EDUARDO AVILA RUIZ",
      "phone": "2530012",
    },
    {
      "workerId": "4",
      "identification": "1003151550",
      "fullName": "LUIS HUMBERTO CACEREZ RAMIREZ",
      "phone": "0990895926",
    },
    {
      "workerId": "6",
      "identification": "1003370929",
      "fullName": "CARLOS RAMIRO CARANQUI IMBAQUINGO",
      "phone": "",
    },
    {
      "workerId": "7",
      "identification": "1002422747",
      "fullName": "HECTOR ANIVAL CASTRO NARVAEZ",
      "phone": "",
    },
    {
      "workerId": "8",
      "identification": "1002026662",
      "fullName": "SEGUNDO MANUEL CEVALLOS ANRANGO",
      "phone": "",
    },
    {
      "workerId": "9",
      "identification": "1001949195",
      "fullName": "JOSE MARIA CHIRAN JACOME",
      "phone": "",
    },
    {
      "workerId": "10",
      "identification": "1001764420",
      "fullName": "EDGAR RICARDO CHIRIBOGA TERAN",
      "phone": "",
    },
    {
      "workerId": "11",
      "identification": "1001741931",
      "fullName": "CESAR AGUSTO CORDOVA",
      "phone": "",
    },
    {
      "workerId": "12",
      "identification": "1001608536",
      "fullName": "JOSE PEDRO DIAZ",
      "phone": "",
    },
    {
      "workerId": "13",
      "identification": "1002036299",
      "fullName": "HIPOLITO GOMEZ MORALES",
      "phone": "099397338",
    },
    {
      "workerId": "15",
      "identification": "1001486412",
      "fullName": "MAURO MALDONADO DE LA TORRE",
      "phone": "0999118516",
    },
    {
      "workerId": "16",
      "identification": "1003471560",
      "fullName": "JOSE LUIS MALDONADO GUACHALA",
      "phone": "",
    },
  ];

  void _openAddWorkerDialog() {
    _searchController.clear();

    Map<String, dynamic>? selectedWorker;
    bool isTechnician = false;
    bool isSupervisor = false;

    // Guardamos el context de la página (seguro para ScaffoldMessenger)
    final BuildContext pageContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final query = _searchController.text.trim().toLowerCase();
            final hasQuery = query.isNotEmpty;

            final filtered = hasQuery
                ? _workers.where((w) {
                    return w['fullName'].toLowerCase().contains(query) ||
                        w['identification'].contains(query);
                  }).toList()
                : [];

            // Verificar si ya hay supervisor
            final currentAssigned = List<Map<String, dynamic>>.from(
              widget.formData['assignedWorkers'] ?? [],
            );
            final hasSupervisor = currentAssigned.any(
              (w) => w['isSupervisor'] == true,
            );

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Agregar Trabajador",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: "Buscar por nombre o cédula",
                          hintStyle: const TextStyle(fontSize: 12),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        onChanged: (_) => setStateDialog(() {}),
                      ),

                      const SizedBox(height: 6),

                      if (selectedWorker != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blue.shade300,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      selectedWorker!['fullName'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Cédula: ${selectedWorker!['identification']} ${selectedWorker!['phone'].isNotEmpty ? '| ${selectedWorker!['phone']}' : ''}",
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Roles (solo si hay selección) - MUTUAMENTE EXCLUSIVOS
                      if (selectedWorker != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isTechnician,
                                  onChanged: (v) {
                                    setStateDialog(() {
                                      isTechnician = v ?? false;
                                      if (isTechnician) {
                                        isSupervisor = false;
                                      }
                                    });
                                  },
                                  activeColor: Colors.teal,
                                ),
                                const Text(
                                  "Asignar como Técnico",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            if (!hasSupervisor)
                              Row(
                                children: [
                                  Checkbox(
                                    value: isSupervisor,
                                    onChanged: (v) {
                                      setStateDialog(() {
                                        isSupervisor = v ?? false;
                                        if (isSupervisor) {
                                          isTechnician = false;
                                        }
                                      });
                                    },
                                    activeColor: Colors.orange,
                                  ),
                                  const Text(
                                    "Asignar como Supervisor",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "Ya hay un supervisor asignado",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                          ],
                        ),

                      const SizedBox(height: 6),

                      if (!hasQuery)
                        const Center(
                          child: Text(
                            "Escribe para buscar trabajadores",
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        )
                      else if (filtered.isEmpty)
                        const Center(
                          child: Text(
                            "No se encontraron resultados",
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        )
                      else if (selectedWorker == null)
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final w = filtered[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 16,
                                    child: Text(
                                      w['fullName'][0],
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  title: Text(
                                    w['fullName'],
                                    style: const TextStyle(fontSize: 11),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    "C.I.: ${w['identification']}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  onTap: () {
                                    selectedWorker = w;
                                    setStateDialog(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.only(bottom: 0, top: 8),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancelar", style: TextStyle(fontSize: 11)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: selectedWorker == null
                      ? null
                      : () {
                          final list = List<Map<String, dynamic>>.from(
                            widget.formData['assignedWorkers'] ?? [],
                          );

                          // Evitar duplicados
                          if (list.any(
                            (e) => e['workerId'] == selectedWorker!['workerId'],
                          )) {
                            ScaffoldMessenger.of(pageContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Este trabajador ya está asignado",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pop(dialogContext);
                            return;
                          }

                          // Solo un supervisor
                          if (isSupervisor &&
                              list.any((e) => e['isSupervisor'] == true)) {
                            ScaffoldMessenger.of(pageContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Ya existe un supervisor asignado",
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.pop(dialogContext);
                            return;
                          }

                          list.add({
                            ...selectedWorker!,
                            "isTechnician": isTechnician,
                            "isSupervisor": isSupervisor,
                          });

                          widget.updateData('assignedWorkers', list);
                          Navigator.pop(dialogContext);
                        },
                  child: const Text(
                    "Agregar",
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignedWorkers = List<Map<String, dynamic>>.from(
      widget.formData['assignedWorkers'] ?? [],
    );

    final supervisor = assignedWorkers.firstWhere(
      (w) => w['isSupervisor'] == true,
      orElse: () => {},
    );

    return SingleChildScrollView(
      padding: context.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título + Botón Agregar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trabajadores asignados",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _openAddWorkerDialog,
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text(
                    "Agregar",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Supervisor destacado
          if (supervisor.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Card(
                color: Colors.orange.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.orange),
                  title: Text(
                    supervisor['fullName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Supervisor asignado"),
                ),
              ),
            ),

          if (assignedWorkers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "No hay trabajadores asignados aún",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 32,
                      ),
                      child: DataTable(
                        headingRowColor: MaterialStatePropertyAll(
                          AppColors.primary.withOpacity(0.12),
                        ),
                        columnSpacing: 16,
                        dataRowHeight: 40,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Nombre',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Cédula',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Teléfono',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Rol',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Opción',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                        rows: assignedWorkers.map((w) {
                          final isSupervisor = w['isSupervisor'] == true;
                          final isTechnician = w['isTechnician'] == true;

                          Color badgeColor;
                          String roleText;
                          if (isSupervisor) {
                            badgeColor = Colors.orange;
                            roleText = "Supervisor";
                          } else if (isTechnician) {
                            badgeColor = Colors.teal;
                            roleText = "Técnico";
                          } else {
                            badgeColor = Colors.blue;
                            roleText = "Normal";
                          }

                          return DataRow(
                            color: MaterialStatePropertyAll(
                              isSupervisor
                                  ? Colors.orange.shade50
                                  : isTechnician
                                  ? Colors.teal.shade50
                                  : null,
                            ),
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: badgeColor.withOpacity(
                                        0.8,
                                      ),
                                      child: Text(
                                        w['fullName'][0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        w['fullName'],
                                        style: const TextStyle(fontSize: 10),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  w['identification'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  w['phone'].isEmpty ? "—" : w['phone'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    roleText,
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      assignedWorkers.remove(w);
                                      widget.updateData(
                                        'assignedWorkers',
                                        assignedWorkers,
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // VALIDACIÓN VISUAL: Mensaje si no hay trabajadores asignados
          if (assignedWorkers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Debe asignar al menos un trabajador",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
