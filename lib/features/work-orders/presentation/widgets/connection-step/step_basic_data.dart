// features/work-orders/presentation/widgets/step_basic_data.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/domain/usecases/connection_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/connection-step/connection_search_dialog.dart';
import 'package:clean_architecture/shared_ui/components/common/custom_text_field.dart';
import 'package:clean_architecture/shared_ui/components/common/form_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

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
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _cadastralKeyController = TextEditingController();
  final _locationController = TextEditingController();

  Map<String, dynamic>? _selectedConnection;

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
      _clientIdController.text = conn['clientId'] ?? '';
      _cadastralKeyController.text = conn['connectionCadastralKey'] ?? '';
      _locationController.text = conn['connectionAddress'] ?? '';
    } else {
      _clientIdController.text = widget.formData['clientId'] ?? '';
      _cadastralKeyController.text = widget.formData['cadastralKey'] ?? '';
      _locationController.text = widget.formData['location'] ?? '';
    }
  }

  void _selectConnection(ConnectionEntity connection) {
    final connMap = {
      "connectionId": connection.connectionId,
      "clientId": connection.clientId,
      "connectionMeterNumber": connection.connectionMeterNumber,
      "connectionCadastralKey": connection.connectionCadastralKey,
      "connectionAddress": connection.connectionAddress,
    };

    if (!mounted) return;

    setState(() {
      _selectedConnection = connMap;
    });

    widget.updateData('selectedConnection', connMap);
    widget.updateData('clientId', connection.clientId);
    widget.updateData('cadastralKey', connection.connectionCadastralKey);
    widget.updateData('location', connection.connectionAddress);

    _clientIdController.text = connection.clientId ?? '';
    _cadastralKeyController.text = connection.connectionCadastralKey ?? '';
    _locationController.text = connection.connectionAddress ?? '';
  }

  void _clearSelection() {
    if (!mounted) return;

    setState(() {
      _selectedConnection = null;
    });
    widget.updateData('selectedConnection', null);
    _clientIdController.clear();
    _cadastralKeyController.clear();
    _locationController.clear();
  }

  void _openSearchDialog() async {
    final selected = await showDialog<ConnectionEntity>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ConnectionSearchDialog(),
    );

    if (selected != null && mounted) {
      _selectConnection(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = _selectedConnection != null;

    return SingleChildScrollView(
      padding: context.screenPadding,
      child: Form(
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
                              _selectedConnection!['connectionCadastralKey'] ??
                                  '',
                            ),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: _summaryRow(
                              "Cliente",
                              _selectedConnection!['clientId'] ?? '',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        "Dirección",
                        _selectedConnection!['connectionAddress'] ?? '',
                      ),
                      const SizedBox(height: 8),
                      _summaryRow(
                        "Medidor",
                        _selectedConnection!['connectionMeterNumber'] ?? '',
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
    super.dispose();
  }
}
