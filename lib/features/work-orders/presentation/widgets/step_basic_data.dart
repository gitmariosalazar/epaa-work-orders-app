// features/work-orders/presentation/widgets/step_basic_data.dart

import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/shared_ui/components/common/custom_text_field.dart';
import 'package:clean_architecture/shared_ui/components/common/form_card.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';

class StepBasicData extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) updateData;

  const StepBasicData({
    super.key,
    required this.formData,
    required this.updateData,
  });

  @override
  State<StepBasicData> createState() => _StepBasicDataState();
}

class _StepBasicDataState extends State<StepBasicData> {
  final _formKey = GlobalKey<FormState>(); // ← Para validación

  final _descriptionController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _cadastralKeyController = TextEditingController();
  final _locationController = TextEditingController();
  final _searchController = TextEditingController();

  Map<String, dynamic>? _selectedConnection;

  final List<Map<String, dynamic>> _connections = const [
    {
      "connectionId": "1-1",
      "clientId": "1000387843",
      "connectionMeterNumber": "2204007519",
      "connectionCadastralKey": "1-1",
      "connectionAddress": "ALEJANDRO ANDRADE-ATUNTAQUI Y PICHINCHA",
    },
    {
      "connectionId": "1-10",
      "clientId": "1001390085",
      "connectionMeterNumber": "2204007703",
      "connectionCadastralKey": "1-10",
      "connectionAddress": "ALEJANDRO ANDRADE-ATUNTAQUI Y SN",
    },
    {
      "connectionId": "1-100",
      "clientId": "1004086680",
      "connectionMeterNumber": "2109021069",
      "connectionCadastralKey": "1-100",
      "connectionAddress": "AVD.JULIO M.AGUINAGA Y ABDON CALDERON",
    },
    {
      "connectionId": "1-101",
      "clientId": "1000472694",
      "connectionMeterNumber": "83001256",
      "connectionCadastralKey": "1-101",
      "connectionAddress": "AVD.JULIO M.AGUINAGA-ATUNTAQUI",
    },
    {
      "connectionId": "1-102",
      "clientId": "1000211126",
      "connectionMeterNumber": "A19G308860",
      "connectionCadastralKey": "1-102",
      "connectionAddress": "AVD.JULIO M.AGUINAGA-ATUNTAQUI Y SN",
    },
    {
      "connectionId": "1-103",
      "clientId": "1704593787",
      "connectionMeterNumber": "2204008167",
      "connectionCadastralKey": "1-103",
      "connectionAddress": "AVD.JULIO M.AGUINAGA-ATUNTAQUI Y ABDON CALDERÓN",
    },
    {
      "connectionId": "1-104",
      "clientId": "1091719548001",
      "connectionMeterNumber": "2215057440",
      "connectionCadastralKey": "1-104",
      "connectionAddress": "AVD.JULIO M.AGUINAGA-ATUNTAQUI Y SN",
    },
    {
      "connectionId": "1-105",
      "clientId": "1001810843",
      "connectionMeterNumber": "2204008037",
      "connectionCadastralKey": "1-105",
      "connectionAddress": "AVD.JULIO M.AGUINAGA-ATUNTAQUI Y SN",
    },
    {
      "connectionId": "1-106",
      "clientId": "1000221281",
      "connectionMeterNumber": "701005899",
      "connectionCadastralKey": "1-106",
      "connectionAddress": "AVD.JULIO M.AGUINAGA-ATUNTAQUI",
    },
    {
      "connectionId": "1-107",
      "clientId": "1000228427",
      "connectionMeterNumber": "2115018587",
      "connectionCadastralKey": "1-107",
      "connectionAddress": "AVD.JULIO M.AGUINAGA-ATUNTAQUI Y SN",
    },
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.formData['description'] ?? '';
    _loadFields();
  }

  void _loadFields() {
    final conn = widget.formData['selectedConnection'] as Map<String, dynamic>?;
    if (conn != null) {
      _selectedConnection = conn;
      _clientIdController.text = conn['clientId'];
      _cadastralKeyController.text = conn['connectionCadastralKey'];
      _locationController.text = conn['connectionAddress'];
    } else {
      _clientIdController.text = widget.formData['clientId'] ?? '';
      _cadastralKeyController.text = widget.formData['cadastralKey'] ?? '';
      _locationController.text = widget.formData['location'] ?? '';
    }
  }

  void _selectConnection(Map<String, dynamic> connection) {
    setState(() {
      _selectedConnection = connection;
    });
    widget.updateData('selectedConnection', connection);
    widget.updateData('clientId', connection['clientId']);
    widget.updateData('cadastralKey', connection['connectionCadastralKey']);
    widget.updateData('location', connection['connectionAddress']);

    _clientIdController.text = connection['clientId'];
    _cadastralKeyController.text = connection['connectionCadastralKey'];
    _locationController.text = connection['connectionAddress'];
  }

  void _clearSelection() {
    setState(() {
      _selectedConnection = null;
    });
    widget.updateData('selectedConnection', null);
    _clientIdController.clear();
    _cadastralKeyController.clear();
    _locationController.clear();
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.textOnPrimary,
          contentPadding: dialogContext.screenPadding,
          title: const Text(
            "Buscar Conexión o Cliente",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 450,
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                final query = _searchController.text.toLowerCase();

                final filtered = _connections.where((c) {
                  return c['connectionCadastralKey'].toLowerCase().contains(
                        query,
                      ) ||
                      c['connectionMeterNumber'].toLowerCase().contains(
                        query,
                      ) ||
                      c['connectionAddress'].toLowerCase().contains(query) ||
                      c['clientId'].toLowerCase().contains(query);
                }).toList();

                return Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Clave, medidor, dirección o cliente",
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setStateDialog(() {});
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onChanged: (_) => setStateDialog(() {}),
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text("No se encontraron resultados"),
                            )
                          : ListView.builder(
                              itemCount: filtered.length,
                              padding: EdgeInsets.only(
                                top: 0,
                                bottom: context.largeSpacing,
                              ),
                              itemBuilder: (_, i) {
                                final conn = filtered[i];
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      "Clave: ${conn['connectionCadastralKey']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${conn['clientId']} - ${conn['connectionAddress']}",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    onTap: () {
                                      _selectConnection(conn);
                                      Navigator.of(dialogContext).pop();
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 0, top: 8),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = _selectedConnection != null;

    return SingleChildScrollView(
      padding: context.screenPadding,
      child: Form(
        // ← Envuelve todo en Form
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openSearchDialog,
                    icon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Buscar conexión o cliente",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                if (hasConnection) ...[
                  context.hSpace(0.03),
                  OutlinedButton.icon(
                    onPressed: _clearSelection,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      "Cambiar",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            context.vSpace(0.02),

            if (hasConnection)
              FormCard(
                title: 'Conexión seleccionada',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.green.shade400,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Datos encontrados",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _summaryRow(
                              "Clave",
                              _selectedConnection!['connectionCadastralKey'],
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: _summaryRow(
                              "Cliente",
                              _selectedConnection!['clientId'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        "Dirección",
                        _selectedConnection!['connectionAddress'],
                      ),
                      const SizedBox(height: 8),
                      _summaryRow(
                        "Medidor",
                        _selectedConnection!['connectionMeterNumber'],
                      ),
                    ],
                  ),
                ),
              ),

            context.vSpace(0.02),

            FormCard(
              title: 'Datos de la Orden',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _cadastralKeyController,
                          label: 'Clave Catastral *',
                          icon: Icons.vpn_key,
                          onChanged: (v) =>
                              widget.updateData('cadastralKey', v),
                          validator: (value) {
                            if (_selectedConnection == null &&
                                (value?.trim().isEmpty ?? true)) {
                              return 'Requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                      context.hSpace(0.025),
                      Expanded(
                        child: CustomTextField(
                          controller: _clientIdController,
                          label: 'Cliente ID *',
                          icon: Icons.person,
                          onChanged: (v) => widget.updateData('clientId', v),
                          validator: (value) {
                            if (_selectedConnection == null &&
                                (value?.trim().isEmpty ?? true)) {
                              return 'Requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _locationController,
                    label: 'Dirección completa *',
                    icon: Icons.location_on,
                    maxLines: 2,
                    onChanged: (v) => widget.updateData('location', v),
                    validator: (value) {
                      if (_selectedConnection == null &&
                          (value?.trim().isEmpty ?? true)) {
                        return 'Requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      DropdownButtonFormField<int>(
                        value: widget.formData['workTypeId'],
                        decoration: InputDecoration(
                          labelText: 'Tipo de trabajo *',
                          labelStyle: context.titleSmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(Icons.work),
                          filled: true,
                          fillColor: AppColors.surface.withOpacity(0.4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          isDense: true,
                        ),
                        isExpanded: true,
                        validator: (value) {
                          if (value == null) return 'Seleccione un tipo';
                          return null;
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('ALCANTARILLADO'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('AGUA POTABLE'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('COMERCIALIZACION'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('MANTENIMIENTO'),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text('LABORATORIO'),
                          ),
                        ],
                        onChanged: (v) => widget.updateData('workTypeId', v),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textPrimary,
                        ),
                        dropdownColor: AppColors.surface,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: context.iconSmall,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        value: widget.formData['priorityId'],
                        decoration: InputDecoration(
                          labelText: 'Prioridad *',
                          labelStyle: context.titleSmall.copyWith(fontSize: 11),
                          prefixIcon: const Icon(Icons.flag),
                          filled: true,
                          fillColor: AppColors.surface.withOpacity(0.4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          isDense: true,
                        ),
                        isExpanded: true,
                        validator: (value) {
                          if (value == null) return 'Seleccione una prioridad';
                          return null;
                        },
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Baja')),
                          DropdownMenuItem(value: 2, child: Text('Media')),
                          DropdownMenuItem(value: 3, child: Text('Alta')),
                          DropdownMenuItem(value: 4, child: Text('Urgente')),
                          DropdownMenuItem(value: 5, child: Text('Emergencia')),
                        ],
                        onChanged: (v) => widget.updateData('priorityId', v),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textPrimary,
                        ),
                        dropdownColor: AppColors.surface,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: context.iconSmall,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Descripción del problema *',
                    icon: Icons.description,
                    maxLines: 5,
                    minLines: 3,
                    onChanged: (v) => widget.updateData('description', v),
                    isTextArea: true,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'La descripción es obligatoria';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: Colors.green.shade900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
            height: 1,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _clientIdController.dispose();
    _cadastralKeyController.dispose();
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
