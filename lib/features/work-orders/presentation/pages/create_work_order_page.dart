// features/work-orders/presentation/pages/create_work_order_page.dart

import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_material_work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/add_work_order_assignment.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/add_material_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/add_work_order_assignment_use_case.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/add_work_order_attachment_use_case.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/create_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/workers-step/step_assign_workers.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/attachments-step/step_attachments.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/connection-step/step_basic_data.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/products-step/step_select_materials.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

@RoutePage()
class CreateWorkOrderPage extends StatefulWidget {
  const CreateWorkOrderPage({super.key});

  @override
  State<CreateWorkOrderPage> createState() => _CreateWorkOrderPageState();
}

class _CreateWorkOrderPageState extends State<CreateWorkOrderPage> {
  int _currentStep = 0;
  final int _stepsCount = 4;

  final Map<String, dynamic> _formData = {
    'workTypeId': 2,
    'priorityId': 3,
    'selectedClient': null,
    'description': '',
    'location': '',
    'cadastralKey': '',
    'assignedWorkers': <Map<String, dynamic>>[],
    'selectedMaterials': <Map<String, dynamic>>[],
    'attachedFiles': <PlatformFile>[],
    'attachmentDescription': '',
  };

  void _updateData(String key, dynamic value) {
    if (!mounted) return;
    setState(() => _formData[key] = value);
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        final description = (_formData['description'] as String?)?.trim() ?? '';
        final hasDescription = description.isNotEmpty;
        final hasConnection = _formData['selectedConnection'] != null;
        final clientId = (_formData['clientId'] as String?)?.trim() ?? '';
        final cadastralKey =
            (_formData['cadastralKey'] as String?)?.trim() ?? '';
        final location = (_formData['location'] as String?)?.trim() ?? '';
        final hasManualData =
            clientId.isNotEmpty &&
            cadastralKey.isNotEmpty &&
            location.isNotEmpty;
        return hasDescription && (hasConnection || hasManualData);
      case 1:
        return (_formData['assignedWorkers'] as List).isNotEmpty;
      case 2:
        return (_formData['selectedMaterials'] as List).isNotEmpty;
      case 3:
        return true; // Adjuntos es opcional
      default:
        return true;
    }
  }

  void _continue() {
    if (_currentStep < _stepsCount - 1 && _isStepValid(_currentStep)) {
      setState(() => _currentStep += 1);
    }
  }

  void _cancel() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  void _finalizeOrder() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (confirmContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "¿Crear orden de trabajo?",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          "¿Está seguro de que desea crear la orden de trabajo con la información ingresada?",
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.of(confirmContext).pop(),
                child: const Text("Cancelar"),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.of(confirmContext).pop();

                  // === Mostrar loading ===
                  final loadingContext = context;
                  showDialog(
                    context: loadingContext,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  bool success = false;
                  String? errorMessage;

                  try {
                    // Obtener los UseCases
                    final createWorkOrderUseCase =
                        getIt<CreateWorkOrderUseCase>();
                    final addWorkOrderAssignmentUseCase =
                        getIt<AddWorkOrderAssignmentUseCase>();

                    // 1. Crear la orden
                    final orderEntity = WorkOrderEntity(
                      description: _formData['description'] as String? ?? '',
                      workTypeId:
                          int.tryParse(_formData['workTypeId'].toString()) ?? 2,
                      priorityId:
                          int.tryParse(_formData['priorityId'].toString()) ?? 3,
                      location: _formData['location'] as String? ?? '',
                      cadastralKey: _formData['cadastralKey'] as String? ?? '',
                      clientId: _formData['clientId'] as String? ?? '',
                      createdUserId: 1,
                      status: 1,
                      // Otros campos
                    );

                    final createResult = await createWorkOrderUseCase(
                      orderEntity,
                    );

                    if (createResult is FailureState) {
                      throw Exception(
                        createResult.message ?? "Error al crear la orden",
                      );
                    }

                    if (createResult is! SuccessState ||
                        createResult.data == null) {
                      throw Exception(
                        "No se recibió respuesta válida al crear la orden",
                      );
                    }

                    final workOrderId = createResult.data!.workOrderId ?? '';

                    if (workOrderId.isEmpty) {
                      throw Exception("No se recibió el ID de la orden creada");
                    }

                    // 2. Asignar trabajadores
                    final assignedWorkers = List<Map<String, dynamic>>.from(
                      _formData['assignedWorkers'] ?? [],
                    );

                    if (assignedWorkers.isNotEmpty) {
                      final assignmentEntities = assignedWorkers.map((w) {
                        return AddWorkOrderAssignmentEntity(
                          workOrderId: workOrderId,
                          workerId: int.tryParse(w['workerId'].toString()) ?? 0,
                          rolId: w['isSupervisor'] == true
                              ? 3
                              : w['isTechnician'] == true
                              ? 2
                              : 1,
                        );
                      }).toList();

                      debugPrint('Payload de asignación enviado:');
                      debugPrint(
                        const JsonEncoder.withIndent(
                          '  ',
                        ).convert(assignmentEntities),
                      );

                      final assignResult = await addWorkOrderAssignmentUseCase(
                        AddWorkOrderAssignmentParams(
                          assignments: assignmentEntities,
                        ),
                      );

                      if (assignResult is FailureState) {
                        throw Exception(
                          assignResult.message ??
                              "Error al asignar trabajadores",
                        );
                      }
                    }

                    // Asignar materiales y adjuntos aquí si es necesario
                    final assignedMaterials = List<Map<String, dynamic>>.from(
                      _formData['selectedMaterials'] ?? [],
                    );

                    debugPrint('Materiales asignados:');

                    if (assignedMaterials.isNotEmpty) {
                      final assignedMaterialEntities = assignedMaterials.map((
                        m,
                      ) {
                        return AddMaterialWorkOrderEntity(
                          workOrderId: workOrderId,
                          materialId:
                              int.tryParse(m['materialId'].toString()) ?? 0,
                          quantity:
                              double.tryParse(m['quantity'].toString()) ?? 0,
                          unitCost:
                              double.tryParse(m['unitCost'].toString()) ?? 0,
                        );
                      }).toList();

                      debugPrint('Payload de materiales enviado:');
                      debugPrint(
                        const JsonEncoder.withIndent(
                          '  ',
                        ).convert(assignedMaterialEntities),
                      );

                      final addMaterialWorkOrderUseCase =
                          getIt<AddMaterialWorkOrderUseCase>();

                      final addMaterialsResult =
                          await addMaterialWorkOrderUseCase(
                            AddMaterialWorkOrderParams(
                              materials: assignedMaterialEntities,
                            ),
                          );

                      if (addMaterialsResult is FailureState) {
                        throw Exception(
                          addMaterialsResult.message ??
                              "Error al asignar materiales",
                        );
                      }
                    }

                    // 4. Subir adjuntos (imágenes y PDFs)
                    final attachedFiles = List<PlatformFile>.from(
                      _formData['attachedFiles'] ?? [],
                    );
                    final attachmentDescription =
                        _formData['attachmentDescription'] as String? ?? '';

                    if (attachedFiles.isNotEmpty) {
                      final addAttachmentUseCase =
                          getIt<AddWorkOrderAttachmentUseCase>();

                      final attachResult = await addAttachmentUseCase(
                        AddWorkOrderAttachmentParams(
                          workOrderId: workOrderId,
                          files: attachedFiles,
                          description: attachmentDescription,
                        ),
                      );

                      if (attachResult is FailureState) {
                        throw Exception(
                          "Error al subir adjuntos: ${attachResult.message}",
                        );
                      }
                    }

                    success = true;
                  } catch (e) {
                    success = false;
                    errorMessage = e.toString();
                  } finally {
                    // === SIEMPRE quitar loading de forma segura ===
                    if (mounted && Navigator.canPop(loadingContext)) {
                      Navigator.pop(loadingContext);
                    }

                    if (!mounted) return;

                    if (success) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (successContext) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: const Icon(
                            Icons.task_alt,
                            color: Colors.green,
                            size: 48,
                          ),
                          title: const Text(
                            "¡Orden Creada!",
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            "La orden de trabajo se registró exitosamente.",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(
                                    successContext,
                                  ).pop(); // Cierra dialog éxito
                                  Navigator.of(
                                    successContext,
                                  ).pop(true); // Cierra página y envía true
                                },
                                icon: const Icon(Icons.check),
                                label: const Text("Aceptar"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // === ERROR ===
                      // Calculamos el bottom inset una sola vez aquí (seguro)
                      final double bottomInset =
                          MediaQuery.of(context).padding.bottom + 24;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Error al crear la orden: ${errorMessage ?? 'Error desconocido'}",
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            46,
                            43,
                            43,
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: bottomInset,
                          ),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.check_circle),
                label: const Text("Crear"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomStepper() {
    return Container(
      color: AppColors.secondary.withOpacity(0.3),
      padding: EdgeInsets.symmetric(vertical: context.smallSpacing * 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 35),
          _buildStepIcon(0, Icons.description),
          _buildStepConnector(1),
          _buildStepIcon(1, Icons.engineering),
          _buildStepConnector(2),
          _buildStepIcon(2, Icons.build),
          _buildStepConnector(3),
          _buildStepIcon(3, Icons.attach_file),
          const SizedBox(width: 35),
        ],
      ),
    );
  }

  Widget _buildStepIcon(int index, IconData baseIcon) {
    final isActive = _currentStep == index;
    final isCompleted = _currentStep > index;

    IconData icon;
    Color bg;
    Color iconColor = Colors.white;

    if (isCompleted) {
      icon = Icons.check;
      bg = Colors.green;
    } else if (isActive) {
      icon = baseIcon;
      bg = AppColors.primary;
    } else {
      icon = baseIcon;
      bg = AppColors.primary.withOpacity(0.4);
      iconColor = Colors.white70;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: bg.withOpacity(0.5),
                  blurRadius: 16,
                  spreadRadius: 3,
                ),
              ]
            : [],
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildStepConnector(int nextIndex) {
    final isCompleted = _currentStep >= nextIndex;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 4,
        margin: EdgeInsets.symmetric(horizontal: context.smallSpacing),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nueva Orden de Trabajo',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildCustomStepper(),
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                StepBasicData(formData: _formData, updateData: _updateData),
                StepAssignWorkers(formData: _formData, updateData: _updateData),
                StepSelectMaterials(
                  formData: _formData,
                  updateData: _updateData,
                ),
                StepAttachments(formData: _formData, updateData: _updateData),
              ],
            ),
          ),
          Container(
            padding:
                context.screenPadding +
                EdgeInsets.only(
                  bottom: context.largeSpacing + 5,
                  top: context.largeSpacing,
                ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _cancel,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Atrás'),
                    ),
                  ),
                if (_currentStep > 0) context.hSpace(0.02),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentStep == _stepsCount - 1
                        ? _finalizeOrder
                        : _continue,
                    icon: Icon(
                      _currentStep == _stepsCount - 1
                          ? Icons.check_circle
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      _currentStep == _stepsCount - 1
                          ? 'Finalizar'
                          : 'Siguiente',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
