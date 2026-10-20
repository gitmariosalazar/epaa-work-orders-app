import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/create_work_order/create_work_order_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'create/constants/work_order_create_constants.dart';
import 'create/models/work_order_form_state.dart';
import 'create/widgets/step_client_selection.dart';
import 'create/widgets/step_order_confirmation.dart';
import 'create/widgets/step_order_details.dart';
import 'create/widgets/work_order_step_indicator.dart';
import 'create/widgets/work_order_success_view.dart';

@RoutePage()
class CreateWorkOrderPage extends StatelessWidget {
  const CreateWorkOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateWorkOrderCubit>(
      create: (_) => GetIt.I<CreateWorkOrderCubit>(),
      child: const _CreateWorkOrderView(),
    );
  }
}

class _CreateWorkOrderView extends StatefulWidget {
  const _CreateWorkOrderView();

  @override
  State<_CreateWorkOrderView> createState() => _CreateWorkOrderViewState();
}

class _CreateWorkOrderViewState extends State<_CreateWorkOrderView> {
  int _currentStep = 1;
  WorkOrderFormState _form = const WorkOrderFormState();
  Map<String, String> _errors = {};

  void _updateForm(WorkOrderFormState updatedForm) {
    setState(() {
      _form = updatedForm;
      _errors = {};
    });
  }

  void _handlePrevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        _errors = {};
      });
    }
  }

  void _handleNextStep() {
    final validation = WorkOrderValidationHelper.validateStep(
      _currentStep,
      _form,
    );
    if (!validation.isValid) {
      setState(() {
        _errors = validation.errors;
      });
      _showValidationErrorsModal(validation.errors);
      return;
    }

    setState(() {
      _errors = {};
      if (_currentStep < WorkOrderCreateConstants.steps.length) {
        _currentStep++;
      }
    });
  }

  void _handleStepTapped(int step) {
    if (step == _currentStep) return;

    if (step < _currentStep) {
      // Permitir retroceder libremente
      setState(() {
        _currentStep = step;
        _errors = {};
      });
      return;
    }

    // Para avanzar a un paso superior, validar el paso actual primero
    final validation = WorkOrderValidationHelper.validateStep(
      _currentStep,
      _form,
    );
    if (!validation.isValid) {
      setState(() {
        _errors = validation.errors;
      });
      _showValidationErrorsModal(validation.errors);
      return;
    }

    setState(() {
      _currentStep = step;
      _errors = {};
    });
  }

  Future<void> _handleSubmit() async {
    final validation = WorkOrderValidationHelper.validateStep(
      _currentStep,
      _form,
    );
    if (!validation.isValid) {
      setState(() {
        _errors = validation.errors;
      });
      _showValidationErrorsModal(validation.errors);
      return;
    }

    String currentUserId = '';
    try {
      currentUserId = SessionUtil.I.userData.user.userId;
    } catch (_) {
      currentUserId = '';
    }

    final entity = _form.toEntity(createdByUserId: currentUserId);
    context.read<CreateWorkOrderCubit>().createWorkOrder(entity);
  }

  void _handleResetForm() {
    setState(() {
      _currentStep = 1;
      _form = const WorkOrderFormState();
      _errors = {};
    });
  }

  void _showValidationErrorsModal(Map<String, String> errors) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Datos Requeridos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Por favor complete o verifique los siguientes campos antes de continuar:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...errors.values.map((msg) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          msg,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? Colors.red.shade200
                                : Colors.red.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<CreateWorkOrderCubit, CreateWorkOrderState>(
      listener: (context, state) {
        if (state is CreateWorkOrderSuccess && state.evidenceWarning != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Orden creada, pero las evidencias no se subieron: ${state.evidenceWarning}',
              ),
              backgroundColor: Colors.orange.shade800,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (state is CreateWorkOrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Cerrar',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        // Pantalla de éxito
        if (state is CreateWorkOrderSuccess) {
          return Scaffold(
            appBar: const BaseAppBar(
              title: 'Nueva Orden de Trabajo',
              centerTitle: true,
            ),
            body: WorkOrderSuccessView(
              codigoOrden: state.createdOrder.orderCode,
              onCreateAnother: _handleResetForm,
              onGoToOrders: () {
                context.router.maybePop(true);
              },
            ),
          );
        }

        final isSubmitting = state is CreateWorkOrderLoading;

        return Scaffold(
          appBar: BaseAppBar(
            title: 'Nueva Orden de Trabajo',
            centerTitle: true,
            onLeadingPressed: () {
              if (_currentStep > 1) {
                _handlePrevStep();
              } else {
                context.router.maybePop();
              }
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                // ── INDICADOR DE PASOS ─────────────────────────────────
                WorkOrderStepIndicator(
                  currentStep: _currentStep,
                  onStepTapped: _handleStepTapped,
                ),

                // ── CONTENIDO DEL PASO ─────────────────────────────────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildStepContent(),
                  ),
                ),

                // ── BARRA INFERIOR DE NAVEGACIÓN ───────────────────────
                _buildBottomNavigation(isSubmitting, theme, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return StepClientSelection(
          key: const ValueKey('step_1_client'),
          form: _form,
          onFormChange: _updateForm,
          errors: _errors,
        );
      case 2:
        return StepOrderDetails(
          key: const ValueKey('step_2_details'),
          form: _form,
          onFormChange: _updateForm,
          errors: _errors,
        );
      case 3:
        return StepOrderConfirmation(
          key: const ValueKey('step_3_confirmation'),
          form: _form,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomNavigation(
    bool isSubmitting,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? theme.dividerColor.withValues(alpha: 0.2)
                : Colors.grey.shade200,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botón Anterior
          if (_currentStep > 1) ...[
            OutlinedButton.icon(
              onPressed: isSubmitting ? null : _handlePrevStep,
              icon: const Icon(Icons.chevron_left_rounded, size: 20),
              label: const Text('Anterior'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          const Spacer(),

          // Botón Siguiente o Guardar
          if (_currentStep < WorkOrderCreateConstants.steps.length)
            FilledButton.icon(
              onPressed: _handleNextStep,
              icon: const Icon(Icons.chevron_right_rounded, size: 20),
              label: const Text('Continuar'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          else
            FilledButton.icon(
              onPressed: isSubmitting ? null : _handleSubmit,
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded, size: 20),
              label: Text(
                isSubmitting ? 'Creando OT...' : 'Crear Orden de Trabajo',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
