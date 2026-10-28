import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/presentation/cubits/departments/departments_cubit.dart';
import 'package:clean_architecture/features/work-orders/presentation/pages/create/constants/work_order_create_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkTypeSelectionResult {
  final DepartmentEntity department;
  final WorkTypeEntity workType;

  const WorkTypeSelectionResult({
    required this.department,
    required this.workType,
  });
}

class WorkTypeSelectionModal extends StatefulWidget {
  final String? selectedTypeCode;
  final int? selectedWorkTypeId;
  final String? selectedTypeName;
  final int? selectedDepartmentId;

  const WorkTypeSelectionModal({
    super.key,
    this.selectedTypeCode,
    this.selectedWorkTypeId,
    this.selectedTypeName,
    this.selectedDepartmentId,
  });

  /// Método estático conveniente para desplegar el modal desde cualquier lugar
  static Future<WorkTypeSelectionResult?> show({
    required BuildContext context,
    String? selectedTypeCode,
    int? selectedWorkTypeId,
    String? selectedTypeName,
    int? selectedDepartmentId,
    DepartmentsCubit? departmentsCubit,
  }) {
    final cubit = departmentsCubit ?? context.read<DepartmentsCubit>();

    return showModalBottomSheet<WorkTypeSelectionResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: WorkTypeSelectionModal(
            selectedTypeCode: selectedTypeCode,
            selectedWorkTypeId: selectedWorkTypeId,
            selectedTypeName: selectedTypeName,
            selectedDepartmentId: selectedDepartmentId,
          ),
        );
      },
    );
  }

  @override
  State<WorkTypeSelectionModal> createState() => _WorkTypeSelectionModalState();
}

class _WorkTypeSelectionModalState extends State<WorkTypeSelectionModal> {
  final TextEditingController _searchController = TextEditingController();
  int? _activeDepartmentFilter; // null = Todos
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark
        ? const Color(0xFF111827) // Slate 900
        : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Header
              _buildHeader(context, isDark),

              // Search Bar
              _buildSearchBar(context, isDark),

              const SizedBox(height: 8),

              // Content Area con BlocBuilder
              Expanded(
                child: BlocBuilder<DepartmentsCubit, DepartmentsState>(
                  builder: (context, state) {
                    if (state is DepartmentsLoading) {
                      return _buildLoadingState(isDark);
                    }

                    if (state is DepartmentsError) {
                      return _buildErrorState(context, state.message, isDark);
                    }

                    if (state is DepartmentsLoaded) {
                      return _buildLoadedContent(
                        context,
                        scrollController,
                        state.departments,
                        isDark,
                      );
                    }

                    // Initial state -> disparar carga si no está cargando
                    context.read<DepartmentsCubit>().loadDepartments();
                    return _buildLoadingState(isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── HEADER ───────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.engineering_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipo de Trabajo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Categorizado por departamentos y labores técnicas',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ───────────────────────────────────────────────────────────
  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade300,
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _searchQuery = val.trim().toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar labor técnica (ej. fuga, medidor, inspección)...',
            hintStyle: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  // ── LOADED CONTENT ───────────────────────────────────────────────────────
  Widget _buildLoadedContent(
    BuildContext context,
    ScrollController scrollController,
    List<DepartmentEntity> departments,
    bool isDark,
  ) {
    // Si la lista de departamentos de la API vino vacía, usamos fallback resiliente
    final depts = departments.isNotEmpty
        ? departments
        : _buildFallbackDepartments();

    // Calcular totales para los tabs
    final totalWorkTypes = depts.fold<int>(
      0,
      (sum, d) => sum + d.workTypes.length,
    );

    // Filtrar departamentos y work types según búsqueda y tab activo
    final filteredDepartments = <DepartmentEntity>[];

    for (final dept in depts) {
      if (_activeDepartmentFilter != null &&
          dept.departmentId != _activeDepartmentFilter) {
        continue;
      }

      final matchingTypes = dept.workTypes.where((wt) {
        if (_searchQuery.isEmpty) return true;
        return wt.typeName.toLowerCase().contains(_searchQuery) ||
            wt.typeDescription.toLowerCase().contains(_searchQuery) ||
            wt.typeCode.toLowerCase().contains(_searchQuery) ||
            dept.departmentName.toLowerCase().contains(_searchQuery);
      }).toList();

      if (matchingTypes.isNotEmpty) {
        filteredDepartments.add(
          DepartmentEntity(
            departmentId: dept.departmentId,
            departmentName: dept.departmentName,
            departmentDescription: dept.departmentDescription,
            workTypes: matchingTypes,
          ),
        );
      }
    }

    return Column(
      children: [
        // Department Chips Selector
        _buildDepartmentChips(depts, totalWorkTypes, isDark),

        const Divider(height: 1, thickness: 1),

        // Listado de Categorías y Tipos de Trabajo
        Expanded(
          child: filteredDepartments.isEmpty
              ? _buildEmptySearchState(isDark)
              : ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: filteredDepartments.length,
                  itemBuilder: (context, index) {
                    final dept = filteredDepartments[index];
                    return _buildDepartmentSection(context, dept, isDark);
                  },
                ),
        ),
      ],
    );
  }

  // ── DEPARTMENT FILTER CHIPS ──────────────────────────────────────────────
  Widget _buildDepartmentChips(
    List<DepartmentEntity> departments,
    int totalCount,
    bool isDark,
  ) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: departments.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = _activeDepartmentFilter == null;
            return ChoiceChip(
              label: Text('Todos ($totalCount)'),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: isDark
                  ? const Color(0xFF1F2937)
                  : Colors.grey.shade100,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white10 : Colors.grey.shade300),
              ),
              onSelected: (_) {
                setState(() {
                  _activeDepartmentFilter = null;
                });
              },
            );
          }

          final dept = departments[index - 1];
          final isSelected = _activeDepartmentFilter == dept.departmentId;
          final visual = WorkOrderCreateConstants.getDepartmentVisual(
            dept.departmentName,
            dept.departmentId,
          );

          return ChoiceChip(
            avatar: Icon(
              visual.icon,
              size: 16,
              color: isSelected ? Colors.white : visual.color,
            ),
            label: Text('${dept.departmentName} (${dept.workTypes.length})'),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade300 : Colors.grey.shade800),
            ),
            selected: isSelected,
            selectedColor: visual.color,
            backgroundColor: isDark
                ? visual.resolveBackgroundColor(true).withValues(alpha: 0.3)
                : visual.resolveBackgroundColor(false),
            side: BorderSide(
              color: isSelected
                  ? visual.color
                  : visual.color.withValues(alpha: 0.3),
            ),
            onSelected: (_) {
              setState(() {
                _activeDepartmentFilter = isSelected ? null : dept.departmentId;
              });
            },
          );
        },
      ),
    );
  }

  // ── SECCIÓN DE UN DEPARTAMENTO ───────────────────────────────────────────
  Widget _buildDepartmentSection(
    BuildContext context,
    DepartmentEntity department,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final visual = WorkOrderCreateConstants.getDepartmentVisual(
      department.departmentName,
      department.departmentId,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? visual.color.withValues(alpha: 0.25)
              : visual.color.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: visual.color.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header de la tarjeta del Departamento
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? visual.color.withValues(alpha: 0.15)
                  : visual.resolveBackgroundColor(false),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: visual.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(visual.icon, color: visual.color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        department.departmentName.toUpperCase(),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          fontSize: 13,
                          color: visual.color,
                        ),
                      ),
                      if (department.departmentDescription.isNotEmpty)
                        Text(
                          department.departmentDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: visual.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${department.workTypes.length} ${department.workTypes.length == 1 ? "labor" : "labores"}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: visual.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items / Tipos de trabajo pertenecientes al departamento
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            itemCount: department.workTypes.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: isDark ? Colors.white10 : Colors.grey.shade100,
            ),
            itemBuilder: (context, idx) {
              final wt = department.workTypes[idx];
              return _buildWorkTypeTile(context, department, wt, visual, isDark);
            },
          ),
        ],
      ),
    );
  }

  // ── TILE DE UN TIPO DE TRABAJO ───────────────────────────────────────────
  Widget _buildWorkTypeTile(
    BuildContext context,
    DepartmentEntity department,
    WorkTypeEntity workType,
    DepartmentVisualItem visual,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final isSelected = _isWorkTypeSelected(workType, department);

    final itemIcon = WorkOrderCreateConstants.getWorkTypeIcon(
      workType.typeName,
      workType.typeCode,
      department.departmentName,
    );

    final priorityColor = WorkOrderCreateConstants.getSuggestedPriorityColor(
      workType.suggestedPriority,
    );

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(
          WorkTypeSelectionResult(
            department: department,
            workType: workType,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? visual.color.withValues(alpha: isDark ? 0.2 : 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: visual.color, width: 1.5)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected
                    ? visual.color
                    : (isDark
                        ? const Color(0xFF374151)
                        : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                itemIcon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade300 : visual.color),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workType.typeName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? (isDark ? Colors.white : visual.color)
                          : (isDark ? Colors.white : Colors.grey.shade900),
                    ),
                  ),
                  if (workType.typeDescription.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      workType.typeDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),

                  // Suggested Priority Badge
                  if (workType.suggestedPriority.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(
                          alpha: isDark ? 0.25 : 0.12,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: priorityColor.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: priorityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Prioridad sugerida: ${workType.suggestedPriority}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: priorityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Selector Indicator
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: visual.color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              )
            else
              Icon(
                Icons.radio_button_unchecked_rounded,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  bool _isWorkTypeSelected(
    WorkTypeEntity workType,
    DepartmentEntity department,
  ) {
    // 1. Coincidencia por código único del tipo de trabajo
    if (widget.selectedTypeCode != null &&
        widget.selectedTypeCode!.isNotEmpty) {
      return widget.selectedTypeCode == workType.typeCode;
    }

    // 2. Coincidencia por nombre exacto de la labor técnica
    if (widget.selectedTypeName != null &&
        widget.selectedTypeName!.isNotEmpty) {
      return widget.selectedTypeName!.trim().toLowerCase() ==
          workType.typeName.trim().toLowerCase();
    }

    // 3. Coincidencia por ID numérico sólo si el typeCode es numérico y coincide exactamente
    if (widget.selectedWorkTypeId != null &&
        widget.selectedWorkTypeId! > 0) {
      final parsedCode = int.tryParse(workType.typeCode);
      if (parsedCode != null && parsedCode == widget.selectedWorkTypeId) {
        return true;
      }
    }

    return false;
  }

  // ── ESTADOS AUXILIARES (LOADING, ERROR, EMPTY) ────────────────────────────
  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando catálogo de departamentos y labores...',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Colors.red,
                size: 36,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No se pudo conectar con el catálogo',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<DepartmentsCubit>().loadDepartments(refresh: true);
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 52,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No encontramos resultados para "$_searchQuery"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Intenta con otra palabra clave o cambia de departamento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _activeDepartmentFilter = null;
                });
              },
              child: const Text('Limpiar filtros y búsqueda'),
            ),
          ],
        ),
      ),
    );
  }

  /// Departamentos de respaldo en caso de que el backend no retorne datos o esté offline
  List<DepartmentEntity> _buildFallbackDepartments() {
    return [
      DepartmentEntity(
        departmentId: 2,
        departmentName: 'Agua Potable',
        departmentDescription: 'Red de distribución y acometidas de agua potable',
        workTypes: [
          WorkTypeEntity(
            typeCode: '2',
            typeName: 'Reparación de fuga en matriz o vereda',
            typeDescription: 'Atención a fugas visibles u ocultas en la red',
            suggestedPriority: 'URGENTE',
          ),
          WorkTypeEntity(
            typeCode: '3',
            typeName: 'Instalación o cambio de medidor',
            typeDescription: 'Colocación de nuevo medidor volumétrico o cambio por daño',
            suggestedPriority: 'MEDIA',
          ),
          WorkTypeEntity(
            typeCode: '1',
            typeName: 'Inspección técnica de acometida',
            typeDescription: 'Revisión de presión, fugas internas o estado de red',
            suggestedPriority: 'BAJA',
          ),
        ],
      ),
      DepartmentEntity(
        departmentId: 1,
        departmentName: 'Alcantarillado',
        departmentDescription: 'Red hidrosanitaria y drenaje pluvial',
        workTypes: [
          WorkTypeEntity(
            typeCode: '6',
            typeName: 'Limpieza y desazolve de red',
            typeDescription: 'Mantenimiento preventivo o correctivo de tuberías y pozos',
            suggestedPriority: 'ALTA',
          ),
          WorkTypeEntity(
            typeCode: '7',
            typeName: 'Reparación de sumidero o pozo',
            typeDescription: 'Reemplazo o arreglo de tapas, rejillas y canaletas',
            suggestedPriority: 'MEDIA',
          ),
        ],
      ),
      DepartmentEntity(
        departmentId: 3,
        departmentName: 'Comercialización',
        departmentDescription: 'Gestión de servicios y cartera de clientes',
        workTypes: [
          WorkTypeEntity(
            typeCode: '4',
            typeName: 'Corte de servicio por mora',
            typeDescription: 'Suspensión del suministro por falta de pago',
            suggestedPriority: 'MEDIA',
          ),
          WorkTypeEntity(
            typeCode: '5',
            typeName: 'Reconexión de servicio',
            typeDescription: 'Reapertura tras cancelación de valores pendientes',
            suggestedPriority: 'ALTA',
          ),
        ],
      ),
      DepartmentEntity(
        departmentId: 4,
        departmentName: 'Mantenimiento General',
        departmentDescription: 'Infraestructura electromecánica y redes',
        workTypes: [
          WorkTypeEntity(
            typeCode: '8',
            typeName: 'Mantenimiento preventivo general',
            typeDescription: 'Revisión periódica de válvulas y estaciones de bombeo',
            suggestedPriority: 'BAJA',
          ),
        ],
      ),
    ];
  }
}
