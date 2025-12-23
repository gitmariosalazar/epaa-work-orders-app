// features/workers/presentation/pages/workers_home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/features/workers/domain/entities/worker_entity.dart';
import 'package:clean_architecture/features/workers/domain/usecases/get_all_workers_use_case.dart';
import 'package:clean_architecture/features/workers/presentation/cubits/workers/workers_cubit.dart';
import 'package:clean_architecture/features/workers/presentation/cubits/workers/workers_state.dart';
import 'package:clean_architecture/features/workers/presentation/widgets/workers_list.dart';
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempPhone = _filterPhone ?? '';
        String tempEmail = _filterEmail ?? '';

        return AlertDialog(
          title: const Text('Filtros de Trabajadores'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    hintText: 'Ej: 099',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => tempPhone = value,
                  controller: TextEditingController(text: tempPhone),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Ej: @hotmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => tempEmail = value,
                  controller: TextEditingController(text: tempEmail),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterPhone = null;
                  _filterEmail = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Limpiar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterPhone = tempPhone.isEmpty ? null : tempPhone;
                  _filterEmail = tempEmail.isEmpty ? null : tempEmail;
                });
                Navigator.pop(context);
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<WorkersCubit>().loadWorkers(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, apellido o cédula...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          // Lista
          Expanded(
            child: BlocBuilder<WorkersCubit, WorkersState>(
              builder: (context, state) {
                if (state is WorkersLoading || state is WorkersInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is WorkersError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error de conexión',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.read<WorkersCubit>().loadWorkers(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final List<WorkerEntity> workers = state is WorkersLoaded
                    ? state.workers
                    : [];

                // Aplicar filtros y búsqueda
                final filteredWorkers = workers.where((worker) {
                  final matchesSearch =
                      _searchController.text.isEmpty ||
                      '${worker.firstNames} ${worker.lastNames}'
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()) ||
                      worker.identification.contains(_searchController.text);

                  final matchesPhone =
                      _filterPhone == null ||
                      worker.phoneNumber.contains(_filterPhone!);
                  final matchesEmail =
                      _filterEmail == null ||
                      worker.email.toLowerCase().contains(
                        _filterEmail!.toLowerCase(),
                      );

                  return matchesSearch && matchesPhone && matchesEmail;
                }).toList();

                if (filteredWorkers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron trabajadores',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Intenta con otros filtros'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<WorkersCubit>().loadWorkers(),
                  child: WorkersList(workers: filteredWorkers),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
