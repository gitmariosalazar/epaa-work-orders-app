import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clean_architecture/components/widgets/attachment_source_picker.dart';

import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/incidents/data/models/requests/resolve_incident_request.dart';
import 'package:clean_architecture/components/widgets/mic_suffix_button.dart';
import 'package:clean_architecture/features/incidents/presentation/cubit/incident_cubit.dart';
import 'package:clean_architecture/features/incidents/presentation/cubit/incident_state.dart';
import 'package:clean_architecture/features/connections/form/update/domain/usecases/change_meter_usecase.dart';
import 'package:clean_architecture/features/connections/form/update/data/models/dto/request/change_meter_request.dart'
    as cmr;
import 'package:clean_architecture/components/button/widget_button.dart';
import 'package:clean_architecture/features/connections/search/data/datasources/remote_connection_datasource.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/search/data/mappers/connection_mapper.dart';

@RoutePage()
class SolveAndChangeMeterIncidentScreen extends StatefulWidget
    implements AutoRouteWrapper {
  final String incidentId;
  final String incidentCode;
  final String? connectionId;

  const SolveAndChangeMeterIncidentScreen({
    super.key,
    required this.incidentId,
    required this.incidentCode,
    this.connectionId,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => GetIt.I<IncidentCubit>(), child: this);
  }

  @override
  State<SolveAndChangeMeterIncidentScreen> createState() =>
      _SolveAndChangeMeterIncidentScreenState();
}

class _SolveAndChangeMeterIncidentScreenState
    extends State<SolveAndChangeMeterIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _numeroMedidorController = TextEditingController();
  final _claveCatastralController = TextEditingController();
  final _oldMeterReadingController = TextEditingController();
  final _newMeterInitialReadingController = TextEditingController();
  final _newMeterCurrentReadingController = TextEditingController();

  final List<File> _images = [];

  bool _isLoadingConnection = false;
  bool _isUpdating = false;
  ConnectionEntity? _connection;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.connectionId != null && widget.connectionId!.isNotEmpty) {
      _claveCatastralController.text = widget.connectionId!;
      _fetchConnectionInfo();
    }
  }

  Future<void> _fetchConnectionInfo() async {
    setState(() {
      _isLoadingConnection = true;
    });
    try {
      final dataSource = GetIt.I<RemoteConnectionDataSource>();
      final responses = await dataSource
          .getConnectionByCadastralKeyOrClientIdOrCardId(widget.connectionId!);
      if (responses.isNotEmpty) {
        setState(() {
          _connection = responses.first.toEntity();
        });
      }
    } catch (_) {
      // Si falla, simplemente no mostramos el resumen
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingConnection = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _numeroMedidorController.dispose();
    _claveCatastralController.dispose();
    _oldMeterReadingController.dispose();
    _newMeterInitialReadingController.dispose();
    _newMeterCurrentReadingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() {
          _images.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al obtener imagen: $e')));
      }
    }
  }

  Future<void> _showImageSourcePicker() async {
    if (_images.length >= 3) return;
    final source = await AttachmentSourcePicker.show(
      context,
      allowFiles: false,
      title: 'Adjuntar Evidencia Fotográfica',
    );
    if (!mounted || source == null) return;
    await _pickImage(
      source == AttachmentSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final resolverUserId = SessionUtil.I.userData.user.userId;
    if (resolverUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se encontró sesión activa.')),
      );
      return;
    }

    final validImages = _images.where((file) => file.existsSync()).toList();
    final changeDetailsList = <IncidentChangeDetail>[];

    final numeroMedidor = _numeroMedidorController.text.trim();
    final claveCatastral = _claveCatastralController.text.trim();

    if (numeroMedidor.isNotEmpty || claveCatastral.isNotEmpty) {
      changeDetailsList.add(
        IncidentChangeDetail(
          numeroMedidor: numeroMedidor.isNotEmpty ? numeroMedidor : null,
          claveCatastral: claveCatastral.isNotEmpty ? claveCatastral : null,
          observaciones: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          medidorAnterior: OldMeterData(
            numeroMedidor: _connection?.connectionMeterNumber,
            ultimaLectura: double.tryParse(
              _oldMeterReadingController.text.trim(),
            ),
            fechaUltimaLectura: DateTime.now().toIso8601String(),
          ),
          medidorNuevo: NewMeterData(
            numeroMedidor: numeroMedidor.isNotEmpty ? numeroMedidor : null,
            lecturaAnterior: double.tryParse(
              _newMeterInitialReadingController.text.trim(),
            ),
            lecturaActual: double.tryParse(
              _newMeterCurrentReadingController.text.trim(),
            ),
            fechaUltimaLectura: DateTime.now().toIso8601String(),
          ),
        ),
      );
    }

    // ACTUALIZAR ACOMETIDA SI CORRESPONDE
    if (numeroMedidor.isNotEmpty) {
      if (_connection == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Espere, cargando información de la acometida...'),
          ),
        );
        return;
      }

      final currentConn = _connection!;
      if (currentConn.connectionMeterNumber != numeroMedidor) {
        setState(() => _isUpdating = true);
        try {
          final meterDetail = cmr.MeterChangeDetail(
            numeroMedidor: numeroMedidor.isNotEmpty ? numeroMedidor : null,
            claveCatastral: claveCatastral.isNotEmpty ? claveCatastral : null,
            observaciones: _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null,
            medidorAnterior: cmr.OldMeterData(
              numeroMedidor: currentConn.connectionMeterNumber,
              ultimaLectura: double.tryParse(
                _oldMeterReadingController.text.trim(),
              ),
              fechaUltimaLectura: DateTime.now().toIso8601String(),
            ),
            medidorNuevo: cmr.NewMeterData(
              numeroMedidor: numeroMedidor.isNotEmpty ? numeroMedidor : null,
              lecturaAnterior: double.tryParse(
                _newMeterInitialReadingController.text.trim(),
              ),
              lecturaActual: double.tryParse(
                _newMeterCurrentReadingController.text.trim(),
              ),
              fechaUltimaLectura: DateTime.now().toIso8601String(),
            ),
          );

          final changeMeterReq = cmr.ChangeMeterRequest(
            connectionId: currentConn.connectionId,
            changeDetail: meterDetail,
            images: validImages,
            imageDescriptions: [],
          );

          await GetIt.I<ChangeMeterUseCase>()(changeMeterReq);

          changeDetailsList.clear();
        } catch (e) {
          setState(() => _isUpdating = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al actualizar acometida: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        setState(() => _isUpdating = false);
      }
    }

    final request = ResolveIncidentRequest(
      description: _descriptionController.text.trim(),
      repairCost: 0.0,
      chargeToUser: false,
      images: validImages,
      changeDetails: changeDetailsList.isNotEmpty ? changeDetailsList : null,
    );

    if (mounted) {
      context.read<IncidentCubit>().resolveIncident(
        incidentId: widget.incidentId,
        resolverUserId: resolverUserId,
        request: request,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocConsumer<IncidentCubit, IncidentState>(
      listener: (context, state) {
        if (state is IncidentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade800,
            ),
          );
        } else if (state is IncidentOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade800,
            ),
          );
          context.router.maybePop(true);
        }
      },
      builder: (context, state) {
        final isLoading = state is IncidentLoading || _isUpdating;

        return Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            title: const Text('Resolver Incidencia'),
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.router.maybePop(),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: cs.outlineVariant, height: 1),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalles de la Solución',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete el formulario para marcar la incidencia Nº ${widget.incidentCode} como resuelta.',
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),

                  // Resumen de Acometida
                  if (_isLoadingConnection)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_connection != null) ...[
                    _buildConnectionSummary(context, cs),
                    const SizedBox(height: 24),
                  ],

                  // Description Field
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Descripción de la resolución',
                      hintText:
                          'Ej. Se reparó la fuga de agua en la tubería principal...',
                      alignLabelWithHint: true,
                      suffixIcon: MicSuffixButton(
                        controller: _descriptionController,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La descripción es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Datos de Actualización de Acometida
                  Text(
                    'Datos de Actualización de Acometida',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revise la clave catastral y complete el número de medidor si aplica.',
                    style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _claveCatastralController,
                    decoration: InputDecoration(
                      labelText: 'Clave Catastral (Acometida)',
                      hintText: 'Ej. 170101010101',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _numeroMedidorController,
                    decoration: InputDecoration(
                      labelText: 'Nuevo Número de Medidor',
                      hintText: 'Ej. 0987654321',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Lecturas de Medidores',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _oldMeterReadingController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Última Lectura Medidor Anterior (Opcional)',
                      hintText: 'Ej. 120.5',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _newMeterInitialReadingController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Lectura Inicial Medidor Nuevo (Opcional)',
                      hintText: 'Ej. 0.0',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _newMeterCurrentReadingController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Lectura Actual Medidor Nuevo (Opcional)',
                      hintText: 'Ej. 0.0',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Evidencia Fotográfica
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Evidencia Fotográfica',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      Text(
                        '${_images.length}/3',
                        style: TextStyle(
                          fontSize: 14,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_images.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: cs.outlineVariant,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 48,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Aún no hay fotos adjuntas',
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(_images[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ActionButton(
                      onPressed: _images.length >= 3 || isLoading
                          ? null
                          : _showImageSourcePicker,
                      icon: Icons.add_photo_alternate_outlined,
                      label: 'Agregar foto',
                      style: ActionButtonStyle.outlined,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ActionButton(
                      onPressed: isLoading ? null : _submit,
                      icon: Icons.check_circle_rounded,
                      label: 'Guardar y Resolver',
                      loading: isLoading,
                      size: ActionButtonSize.large,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionSummary(BuildContext context, ColorScheme cs) {
    final conn = _connection!;
    String ownerName = 'Sin Nombre';
    String ownerDoc = 'N/A';
    bool isNatural = conn.person != null;

    if (isNatural) {
      ownerName =
          '${conn.person!.firstName ?? ''} ${conn.person!.lastName ?? ''}'
              .trim();
      ownerDoc = conn.clientId;
    } else if (conn.company != null) {
      ownerName =
          conn.company!.businessName ??
          conn.company!.commercialName ??
          'Empresa Registrada';
      ownerDoc = conn.company!.ruc;
    }

    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Información Actual de la Acometida',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Divider(),
          _buildSummaryRow('Propietario', ownerName),
          _buildSummaryRow('Identificación', ownerDoc),
          _buildSummaryRow('Clave Catastral', conn.connectionCadastralKey),
          _buildSummaryRow(
            'Medidor Actual',
            conn.connectionMeterNumber ?? 'Sin Medidor',
          ),
          _buildSummaryRow(
            'Estado',
            conn.connectionStateId == 1 ? 'Activa' : 'Inactiva',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
