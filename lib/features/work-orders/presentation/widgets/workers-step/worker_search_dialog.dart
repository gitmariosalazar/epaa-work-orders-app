// lib/features/work-orders/presentation/widgets/workers-step/worker_search_dialog.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/users/presentation/widgets/user_picker_dialog.dart';
import 'package:clean_architecture/features/users/users.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/workers-step/step_assign_workers.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Diálogo para agregar personal a la OT.
/// La fuente de datos es el módulo **users** (`users-gateway/find-all`),
/// igual que "Asignar Técnico Responsable" y que WorkOrderWorkersCard.tsx.
/// Devuelve un [WorkerWithRole] para mantener compatibilidad con los llamadores.
class WorkerSearchDialog extends StatefulWidget {
  /// Personal ya asignado: se excluye de la lista y define si ya hay supervisor.
  final List<WorkerWithRole>? alreadyAssignedWorkers;

  const WorkerSearchDialog({super.key, this.alreadyAssignedWorkers});

  @override
  State<WorkerSearchDialog> createState() => _WorkerSearchDialogState();
}

class _WorkerSearchDialogState extends State<WorkerSearchDialog> {
  final _searchController = TextEditingController();

  List<UserEntity> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';

  UserEntity? _selected;
  bool _isTechnician = false;
  bool _isSupervisor = false;

  bool get _hasSupervisorAssigned =>
      widget.alreadyAssignedWorkers?.any((w) => w.isSupervisor) ?? false;

  Set<String> get _assignedIds =>
      widget.alreadyAssignedWorkers?.map((w) => w.worker.workerId).toSet() ??
      const {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await GetIt.I<GetUsersUseCase>()(
      const PaginationParams(limit: 500),
    );
    if (!mounted) return;

    final excluded = _assignedIds;
    result.when(
      success: (users) => setState(() {
        _users =
            users
                .where((u) => u.userId.isNotEmpty && u.isActive)
                .where((u) => !excluded.contains(u.userId))
                .where(isServiceTechnician)
                .toList()
              ..sort((a, b) => a.fullName.compareTo(b.fullName));
        _isLoading = false;
      }),
      failure: (msg, _) => setState(() {
        _errorMessage = msg ?? 'Error al cargar usuarios';
        _isLoading = false;
      }),
      loading: () {},
    );
  }

  List<UserEntity> get _filtered {
    if (_query.isEmpty) return _users;
    final q = _query.toLowerCase();
    return _users
        .where(
          (u) =>
              u.fullName.toLowerCase().contains(q) ||
              u.username.toLowerCase().contains(q) ||
              (u.idCard ?? '').contains(q) ||
              (u.positionName ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  WorkerEntity _toWorker(UserEntity u) => WorkerEntity(
    workerId: u.userId,
    identification: u.idCard ?? '',
    firstNames: u.firstName ?? u.fullName,
    lastNames: u.lastName ?? '',
    phoneNumber: u.internalPhone ?? '',
    cellPhone: u.internalPhone ?? '',
    email: u.email.isNotEmpty ? u.email : (u.internalEmail ?? ''),
    address: '',
  );

  void _addWorker() {
    if (_selected == null) return;
    Navigator.pop(
      context,
      WorkerWithRole(
        worker: _toWorker(_selected!),
        isTechnician: _isTechnician,
        isSupervisor: _isSupervisor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = AppColors.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 460,
          maxHeight: MediaQuery.of(context).size.height * 0.78,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              // ─── Header ───
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 20, 12, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary.withOpacity(0.12),
                      primary.withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Agregar Trabajador',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Selecciona personal y asigna un rol',
                            style: TextStyle(
                              fontSize: 13,
                              color: onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: onSurface.withOpacity(0.5),
                      ),
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),
              ),

              // ─── Contenido ───
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      // Buscador
                      TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _query = v.trim()),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre, usuario o cédula...',
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: onSurface.withOpacity(0.4),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: onSurface.withOpacity(0.45),
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: onSurface.withOpacity(0.45),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _query = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.45),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: theme.dividerColor.withOpacity(0.35),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: primary, width: 1.6),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Seleccionado + roles
                      if (_selected != null) ...[
                        _buildSelectedCard(),
                        const SizedBox(height: 12),
                        _buildRoleSelector(),
                        const SizedBox(height: 14),
                      ],

                      // Lista
                      Expanded(child: _buildList()),
                    ],
                  ),
                ),
              ),

              // ─── Footer ───
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    0.25,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: theme.dividerColor.withOpacity(0.6),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: onSurface.withOpacity(0.75),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _selected == null ? null : _addWorker,
                        icon: const Icon(Icons.person_add_rounded, size: 18),
                        label: const Text(
                          'Agregar',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: primary,
                          disabledBackgroundColor: primary.withOpacity(0.35),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Widgets internos ─────────────────────────

  Widget _buildSelectedCard() {
    final u = _selected!;
    final theme = Theme.of(context);
    final primary = AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: primary.withOpacity(0.18),
            child: Text(
              u.fullName.isNotEmpty ? u.fullName[0].toUpperCase() : '?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  u.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  [
                    if ((u.positionName ?? '').isNotEmpty) u.positionName!,
                    if ((u.idCard ?? '').isNotEmpty) 'C.I.: ${u.idCard}',
                  ].join('  ·  '),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              _selected = null;
              _isTechnician = false;
              _isSupervisor = false;
            }),
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            ),
            tooltip: 'Quitar selección',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asignar rol',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _RoleChip(
                label: 'Técnico',
                icon: Icons.handyman_rounded,
                selected: _isTechnician,
                color: Colors.teal,
                onTap: () => setState(() {
                  _isTechnician = !_isTechnician;
                  if (_isTechnician) _isSupervisor = false;
                }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _hasSupervisorAssigned
                  ? Tooltip(
                      message: 'Ya existe un supervisor asignado',
                      child: _RoleChip(
                        label: 'Supervisor',
                        icon: Icons.supervisor_account_rounded,
                        selected: false,
                        color: Colors.orange,
                        enabled: false,
                        onTap: () {},
                      ),
                    )
                  : _RoleChip(
                      label: 'Supervisor',
                      icon: Icons.supervisor_account_rounded,
                      selected: _isSupervisor,
                      color: Colors.orange,
                      onTap: () => setState(() {
                        _isSupervisor = !_isSupervisor;
                        if (_isSupervisor) _isTechnician = false;
                      }),
                    ),
            ),
          ],
        ),
        if (_hasSupervisorAssigned)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Ya hay un supervisor asignado en esta OT',
              style: TextStyle(
                fontSize: 11.5,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildList() {
    final theme = Theme.of(context);
    final primary = AppColors.primary;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(strokeWidth: 3, color: primary),
            ),
            const SizedBox(height: 14),
            Text(
              'Cargando personal...',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: theme.colorScheme.error.withOpacity(0.7),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _loadUsers,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reintentar'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 42,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              _query.isEmpty
                  ? 'No hay personal disponible'
                  : 'No se encontraron resultados',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final u = items[i];
        final isSelected = _selected?.userId == u.userId;

        return Material(
          color: isSelected
              ? primary.withOpacity(0.08)
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.35),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () => setState(() {
              _selected = u;
              _isTechnician = false;
              _isSupervisor = false;
            }),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? primary.withOpacity(0.35)
                      : Colors.transparent,
                  width: 1.4,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isSelected
                        ? primary.withOpacity(0.2)
                        : theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      u.fullName.isNotEmpty ? u.fullName[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isSelected ? primary : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          u.fullName,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          [u.positionName, u.username]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .join('  ·  '),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(
                              0.55,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle_rounded, color: primary, size: 22),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Chip de selección de rol (Técnico / Supervisor)
class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled ? color : Colors.grey;

    return Material(
      color: selected
          ? effectiveColor.withOpacity(0.15)
          : Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? effectiveColor.withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? effectiveColor
                    : effectiveColor.withOpacity(enabled ? 0.7 : 0.4),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? effectiveColor
                      : effectiveColor.withOpacity(enabled ? 0.85 : 0.45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
