// features/workers/presentation/pages/workers_home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/components/loaders/professional_loader.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:clean_architecture/features/workers/domain/usecases/get_all_workers_use_case.dart';
import 'package:clean_architecture/features/workers/presentation/cubits/workers/workers_cubit.dart';
import 'package:clean_architecture/features/workers/presentation/cubits/workers/workers_state.dart';
import 'package:clean_architecture/features/workers/presentation/widgets/workers_list.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class WorkersHomePage extends StatelessWidget {
  const WorkersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WorkersCubit(getAllWorkersUseCase: GetIt.I<GetAllWorkersUseCase>())
            ..loadWorkers(),
      child: const _WorkersHomeView(),
    );
  }
}

class _WorkersHomeView extends StatefulWidget {
  const _WorkersHomeView();

  @override
  State<_WorkersHomeView> createState() => _WorkersHomeViewState();
}

class _WorkersHomeViewState extends State<_WorkersHomeView> {
  final _searchController = TextEditingController();
  String? _filterPhone;
  String? _filterEmail;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _activeFilterCount =>
      (_filterPhone != null && _filterPhone!.isNotEmpty ? 1 : 0) +
      (_filterEmail != null && _filterEmail!.isNotEmpty ? 1 : 0);

  bool get _hasActiveFilters => _activeFilterCount > 0;
  bool get _hasActiveSearch => _searchController.text.trim().isNotEmpty;
  bool get _hasAnyFilterOrSearch => _hasActiveFilters || _hasActiveSearch;

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _filterPhone = null;
      _filterEmail = null;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        final cs = Theme.of(modalContext).colorScheme;
        final isDark = Theme.of(modalContext).brightness == Brightness.dark;

        final phoneCtrl = TextEditingController(text: _filterPhone ?? '');
        final emailCtrl = TextEditingController(text: _filterEmail ?? '');

        return Container(
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHigh : cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(modalContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Título y botón limpiar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Filtros de Trabajadores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  if (_hasActiveFilters)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _filterPhone = null;
                          _filterEmail = null;
                        });
                        Navigator.pop(modalContext);
                      },
                      child: Text(
                        'Restablecer',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),

              // Campo Teléfono
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: cs.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Teléfono o Celular',
                  hintText: 'Ej: 0991234567',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: cs.primary,
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: phoneCtrl,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => phoneCtrl.clear(),
                      );
                    },
                  ),
                  filled: true,
                  fillColor: isDark
                      ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
                      : cs.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Campo Email
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: cs.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  hintText: 'Ej: @epaa.gob.ec',
                  prefixIcon: Icon(
                    Icons.alternate_email_rounded,
                    size: 20,
                    color: cs.primary,
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: emailCtrl,
                    builder: (context, value, _) {
                      if (value.text.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => emailCtrl.clear(),
                      );
                    },
                  ),
                  filled: true,
                  fillColor: isDark
                      ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
                      : cs.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(modalContext),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          final p = phoneCtrl.text.trim();
                          final e = emailCtrl.text.trim();
                          _filterPhone = p.isNotEmpty ? p : null;
                          _filterEmail = e.isNotEmpty ? e : null;
                        });
                        Navigator.pop(modalContext);
                      },
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Aplicar Filtros'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: BaseAppBar(
        title: 'Trabajadores',
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge.count(
              count: _activeFilterCount,
              isLabelVisible: _hasActiveFilters,
              backgroundColor: cs.primary,
              textColor: cs.onPrimary,
              child: const Icon(Icons.tune_rounded),
            ),
            onPressed: _showFilterModal,
            tooltip: 'Filtros',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<WorkersCubit>().loadWorkers(),
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra de Búsqueda Moderna
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: cs.outlineVariant.withValues(
                    alpha: isDark ? 0.35 : 0.6,
                  ),
                  width: 0.9,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, apellido o cédula...',
                  hintStyle: TextStyle(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 13.5,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: cs.primary,
                    size: 21,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          color: cs.onSurfaceVariant,
                          tooltip: 'Borrar texto',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                      IconButton(
                        icon: Badge.count(
                          count: _activeFilterCount,
                          isLabelVisible: _hasActiveFilters,
                          backgroundColor: cs.primary,
                          textColor: cs.onPrimary,
                          child: Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: _hasActiveFilters
                                ? cs.primary
                                : cs.onSurfaceVariant,
                          ),
                        ),
                        tooltip: 'Filtros',
                        onPressed: _showFilterModal,
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),

          // Chips de Filtros Activos
          if (_hasAnyFilterOrSearch)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    if (_hasActiveSearch)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InputChip(
                          avatar: Icon(
                            Icons.search_rounded,
                            size: 14,
                            color: cs.primary,
                          ),
                          label: Text('"${_searchController.text.trim()}"'),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                          backgroundColor: cs.primary.withValues(
                            alpha: isDark ? 0.15 : 0.08,
                          ),
                          side: BorderSide(
                            color: cs.primary.withValues(
                              alpha: isDark ? 0.35 : 0.25,
                            ),
                            width: 0.8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onDeleted: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                      ),
                    if (_filterPhone != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InputChip(
                          avatar: Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: cs.primary,
                          ),
                          label: Text('Tel: $_filterPhone'),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                          backgroundColor: cs.primary.withValues(
                            alpha: isDark ? 0.15 : 0.08,
                          ),
                          side: BorderSide(
                            color: cs.primary.withValues(
                              alpha: isDark ? 0.35 : 0.25,
                            ),
                            width: 0.8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onDeleted: () {
                            setState(() => _filterPhone = null);
                          },
                        ),
                      ),
                    if (_filterEmail != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InputChip(
                          avatar: Icon(
                            Icons.alternate_email_rounded,
                            size: 14,
                            color: cs.primary,
                          ),
                          label: Text('Email: $_filterEmail'),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                          backgroundColor: cs.primary.withValues(
                            alpha: isDark ? 0.15 : 0.08,
                          ),
                          side: BorderSide(
                            color: cs.primary.withValues(
                              alpha: isDark ? 0.35 : 0.25,
                            ),
                            width: 0.8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onDeleted: () {
                            setState(() => _filterEmail = null);
                          },
                        ),
                      ),
                    TextButton.icon(
                      onPressed: _clearAllFilters,
                      icon: const Icon(Icons.close_rounded, size: 14),
                      label: const Text('Limpiar todo'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Contenido principal de la lista
          Expanded(
            child: BlocBuilder<WorkersCubit, WorkersState>(
              builder: (context, state) {
                if (state is WorkersLoading || state is WorkersInitial) {
                  return const Center(
                    child: ProfessionalLoader(
                      label: 'Cargando trabajadores...',
                      description: 'Obteniendo la lista de personal registrado',
                    ),
                  );
                }

                if (state is WorkersError) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(28),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? cs.surfaceContainerHighest.withValues(
                                  alpha: 0.5,
                                )
                              : theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: cs.error.withValues(alpha: 0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.shadow.withValues(
                                alpha: isDark ? 0.2 : 0.04,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cs.error.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cloud_off_rounded,
                                size: 44,
                                color: cs.error,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error de sincronización',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 13,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () =>
                                  context.read<WorkersCubit>().loadWorkers(),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Reintentar'),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final List<WorkerEntity> workers = state is WorkersLoaded
                    ? state.workers
                    : [];

                final query = _searchController.text.trim().toLowerCase();

                // Aplicar filtros y búsqueda
                final filteredWorkers = workers.where((worker) {
                  final fullName = '${worker.firstNames} ${worker.lastNames}'
                      .toLowerCase();
                  final id = worker.identification.toLowerCase();

                  final matchesSearch =
                      query.isEmpty ||
                      fullName.contains(query) ||
                      id.contains(query);

                  final matchesPhone =
                      _filterPhone == null ||
                      worker.phoneNumber.contains(_filterPhone!) ||
                      worker.cellPhone.contains(_filterPhone!);

                  final matchesEmail =
                      _filterEmail == null ||
                      worker.email.toLowerCase().contains(
                        _filterEmail!.toLowerCase(),
                      );

                  return matchesSearch && matchesPhone && matchesEmail;
                }).toList();

                if (filteredWorkers.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.15 : 0.08,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _hasAnyFilterOrSearch
                                  ? Icons.person_search_rounded
                                  : Icons.group_off_rounded,
                              size: 46,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _hasAnyFilterOrSearch
                                ? 'No se encontraron resultados'
                                : 'No hay trabajadores registrados',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _hasAnyFilterOrSearch
                                ? 'No se encontraron trabajadores que coincidan con los criterios de búsqueda o filtros ingresados.'
                                : 'Aún no se encuentran trabajadores disponibles en el sistema.',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (_hasAnyFilterOrSearch)
                            OutlinedButton.icon(
                              onPressed: _clearAllFilters,
                              icon: const Icon(
                                Icons.filter_alt_off_rounded,
                                size: 16,
                              ),
                              label: const Text('Limpiar búsqueda y filtros'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: cs.primary.withValues(alpha: 0.4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 11,
                                ),
                              ),
                            )
                          else
                            FilledButton.icon(
                              onPressed: () =>
                                  context.read<WorkersCubit>().loadWorkers(),
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('Actualizar lista'),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Contador de resultados sutil y elegante
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(
                                alpha: isDark ? 0.16 : 0.08,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredWorkers.length}',
                              style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _hasAnyFilterOrSearch
                                ? 'de ${workers.length} trabajadores coincidentes'
                                : 'trabajadores registrados en total',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lista de trabajadores
                    Expanded(
                      child: RefreshIndicator(
                        color: cs.primary,
                        backgroundColor: isDark
                            ? cs.surfaceContainerHigh
                            : cs.surface,
                        onRefresh: () async =>
                            context.read<WorkersCubit>().loadWorkers(),
                        child: WorkersList(workers: filteredWorkers),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
