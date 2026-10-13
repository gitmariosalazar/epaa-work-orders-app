// lib/features/work-orders/presentation/widgets/workers-step/worker_search_dialog.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/users/presentation/widgets/user_picker_dialog.dart';
import 'package:clean_architecture/features/users/users.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/workers-step/step_assign_workers.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Diálogo para agregar personal a la OT. n
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

  /// Adaptador UserEntity → WorkerEntity (contrato existente de los llamadores).
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Agregar Trabajador',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v.trim()),
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, usuario o cédula...',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 6),
            if (_selected != null) _buildSelectedCard(),
            if (_selected != null) _buildRoleSelector(),
            const SizedBox(height: 6),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 0, top: 8),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(fontSize: 11)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _selected == null ? null : _addWorker,
          child: const Text(
            'Agregar',
            style: TextStyle(fontSize: 11, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCard() {
    final u = _selected!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.blue, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  u.fullName,
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
            [
              if ((u.positionName ?? '').isNotEmpty) u.positionName!,
              if ((u.idCard ?? '').isNotEmpty) 'C.I.: ${u.idCard}',
            ].join(' | '),
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _isTechnician,
              activeColor: Colors.teal,
              onChanged: (v) => setState(() {
                _isTechnician = v ?? false;
                if (_isTechnician) _isSupervisor = false;
              }),
            ),
            const Text(
              'Asignar como Técnico',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        if (!_hasSupervisorAssigned)
          Row(
            children: [
              Checkbox(
                value: _isSupervisor,
                activeColor: Colors.orange,
                onChanged: (v) => setState(() {
                  _isSupervisor = v ?? false;
                  if (_isSupervisor) _isTechnician = false;
                }),
              ),
              const Text(
                'Asignar como Supervisor',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          )
        else
          const Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              'Ya existe un supervisor asignado',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            TextButton(onPressed: _loadUsers, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    final items = _filtered;
    if (items.isEmpty) {
      return const Center(child: Text('No se encontraron usuarios'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        final u = items[i];
        final isSelected = _selected?.userId == u.userId;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 3),
          color: isSelected ? Colors.blue.shade50 : null,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            leading: CircleAvatar(
              radius: 16,
              child: Text(
                u.fullName.isNotEmpty ? u.fullName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 11),
              ),
            ),
            title: Text(
              u.fullName,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              [
                u.positionName,
                u.username,
              ].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
              style: const TextStyle(fontSize: 11),
            ),
            onTap: () => setState(() {
              _selected = u;
              _isTechnician = false;
              _isSupervisor = false;
            }),
          ),
        );
      },
    );
  }
}
