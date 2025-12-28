// lib/features/work-orders/presentation/widgets/connection_search_dialog.dart

import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/connections/domain/entities/connection.dart';
import 'package:clean_architecture/features/connections/domain/usecases/connection_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ConnectionSearchDialog extends StatefulWidget {
  const ConnectionSearchDialog({super.key});

  @override
  State<ConnectionSearchDialog> createState() => _ConnectionSearchDialogState();
}

class _ConnectionSearchDialogState extends State<ConnectionSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ConnectionEntity> _connections = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  String _currentQuery = '';
  int _offset = 0;
  final int _limit = 50;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadConnections(isRefresh: true);
      }
    });
  }

  Future<void> _loadConnections({bool isRefresh = false}) async {
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

    final useCase = getIt<GetAllConnectionsPaginatedUseCase>();
    final result = await useCase(
      ConnectionPaginatedParams(
        query: _currentQuery.isEmpty ? null : _currentQuery,
        limit: _limit,
        offset: _offset,
      ),
    );

    if (!mounted) return;

    result.when(
      success: (connections) {
        if (!mounted) return;

        setState(() {
          if (isRefresh) {
            _connections = connections;
          } else {
            _connections.addAll(connections);
          }

          _hasMore = connections.length == _limit;
          _offset += connections.length;
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      failure: (message, _) {
        if (!mounted) return;

        setState(() {
          _errorMessage = message ?? "Error al buscar conexiones";
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
      loading: () {},
    );
  }

  void _performSearch() {
    _currentQuery = _searchController.text.trim();
    _loadConnections(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.textOnPrimary,
      contentPadding: context.screenPadding,
      title: const Text(
        "Buscar Conexión o Cliente",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.7, // Altura fija
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Clave, medidor, dirección o cliente",
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 11),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _performSearch,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 12),
            // Aquí va el ListView con Flexible en lugar de Expanded
            Flexible(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_errorMessage!),
                          TextButton(
                            onPressed: () => _loadConnections(isRefresh: true),
                            child: const Text("Reintentar"),
                          ),
                        ],
                      ),
                    )
                  : _connections.isEmpty
                  ? const Center(child: Text("No se encontraron resultados"))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _connections.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == _connections.length) {
                          if (_hasMore) {
                            _loadConnections();
                          }
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final conn = _connections[i];
                        return Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conn.person != null
                                        ? "${conn.person!.firstName ?? ''} ${conn.person!.lastName ?? ''}"
                                        : conn.company != null
                                        ? conn.company!.businessName ?? ''
                                        : 'Sin Nombre',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 8),
                                    const Text(
                                      "C.I.: ",
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      conn.clientId ?? '',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      "Clave: ",
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      conn.connectionCadastralKey ?? '',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    conn.connectionAddress ?? '',
                                    style: const TextStyle(fontSize: 9),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => Navigator.pop(context, conn),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
          child: const Text("Cancelar"),
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
