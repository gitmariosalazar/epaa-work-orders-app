// lib/features/work-orders/presentation/widgets/worker_search_dialog.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/workers-step/step_assign_workers.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:clean_architecture/features/workers/domain/usecases/get_all_workers_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class WorkerSearchDialog extends StatefulWidget {
  final List<WorkerWithRole>?
  alreadyAssignedWorkers; // ← Parámetro para saber si ya hay supervisor

  const WorkerSearchDialog({super.key, this.alreadyAssignedWorkers});

  @override
  State<WorkerSearchDialog> createState() => _WorkerSearchDialogState();
}

class _WorkerSearchDialogState extends State<WorkerSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<WorkerEntity> _workers = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  String _currentQuery = '';
  int _offset = 0;
  final int _limit = 50;

  WorkerEntity? selectedWorker;
  bool isTechnician = false;
  bool isSupervisor = false;

  // ← Detecta si ya hay un supervisor asignado
  bool get _hasSupervisorAssigned {
    return widget.alreadyAssignedWorkers?.any((w) => w.isSupervisor) ?? false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadWorkers(isRefresh: true);
      }
    });
  }

  Future<void> _loadWorkers({bool isRefresh = false}) async {
    if (isRefresh) {
      _offset = 0;
      _hasMore = true;
    }

    if (!_hasMore && !isRefresh) return;

    if (!mounted) return;

    setState(() {
      if (isRefresh) {
        _isLoading = true;
        _errorMessage = null;
      } else {
        _isLoadingMore = true;
      }
    });

    final useCase = getIt<GetAllWorkersPaginatedUseCase>();
    final result = await useCase(
      WorkerPaginatedParams(
        query: _currentQuery.isEmpty ? null : _currentQuery,
        limit: _limit,
        offset: _offset,
      ),
    );

    if (!mounted) return;

    result.when(
      success: (workers) {
        if (!mounted) return;

        setState(() {
          if (isRefresh) {
            _workers = workers;
          } else {
            _workers.addAll(workers);
          }

          _hasMore = workers.length == _limit;
          _offset += workers.length;
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      failure: (message, _) {
        if (!mounted) return;

        setState(() {
          _errorMessage = message ?? "Error al cargar trabajadores";
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      loading: () {},
    );
  }

  void _onSearchChanged(String query) {
    _currentQuery = query.trim();
    _loadWorkers(isRefresh: true);
  }

  void _onSearchPressed() {
    _currentQuery = _searchController.text.trim();
    _loadWorkers(isRefresh: true);
  }

  void _onWorkerSelected(WorkerEntity worker) {
    if (!mounted) return;

    setState(() {
      selectedWorker = worker;
      isTechnician = false;
      isSupervisor = false;
    });
  }

  void _addWorker() {
    if (selectedWorker == null) return;

    final result = WorkerWithRole(
      worker: selectedWorker!,
      isTechnician: isTechnician,
      isSupervisor: isSupervisor,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Agregar Trabajador",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.7, // Altura fija
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
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchPressed();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _onSearchPressed,
                      color: AppColors.primary,
                    ),
                  ],
                ),
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
              onSubmitted: (_) => _onSearchPressed(),
            ),

            const SizedBox(height: 6),

            if (selectedWorker != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade300, width: 1),
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
                            '${selectedWorker!.firstNames!} ${selectedWorker!.lastNames!}',
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
                      "Cédula: ${selectedWorker!.identification} ${selectedWorker!.phoneNumber.isNotEmpty ? '| ${selectedWorker!.phoneNumber}' : ''}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            if (selectedWorker != null)
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isTechnician,
                        onChanged: (v) {
                          if (!mounted) return;
                          setState(() {
                            isTechnician = v ?? false;
                            if (isTechnician) isSupervisor = false;
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
                  // ← Solo muestra el checkbox de Supervisor si no hay uno asignado
                  if (!_hasSupervisorAssigned)
                    Row(
                      children: [
                        Checkbox(
                          value: isSupervisor,
                          onChanged: (v) {
                            if (!mounted) return;
                            setState(() {
                              isSupervisor = v ?? false;
                              if (isSupervisor) isTechnician = false;
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
                    ),
                  // Mensaje si ya hay supervisor
                  if (_hasSupervisorAssigned)
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text(
                        "Ya existe un supervisor asignado",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 6),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_errorMessage!),
                          TextButton(
                            onPressed: () => _loadWorkers(isRefresh: true),
                            child: const Text("Reintentar"),
                          ),
                        ],
                      ),
                    )
                  : _workers.isEmpty
                  ? const Center(child: Text("No se encontraron resultados"))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _workers.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == _workers.length) {
                          if (_hasMore) {
                            _loadWorkers();
                          }
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final w = _workers[i];
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
                                w.firstNames![0],
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            title: Text(
                              w.firstNames! + ' ' + w.lastNames!,
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              "C.I.: ${w.identification}",
                              style: const TextStyle(fontSize: 11),
                            ),
                            onTap: () => _onWorkerSelected(w),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 0, top: 8),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar", style: TextStyle(fontSize: 11)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: selectedWorker == null ? null : _addWorker,
          child: const Text(
            "Agregar",
            style: TextStyle(fontSize: 11, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
