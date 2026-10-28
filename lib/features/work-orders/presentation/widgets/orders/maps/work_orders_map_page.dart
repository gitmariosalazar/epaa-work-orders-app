import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/components/button/widget_button.dart';
import 'package:clean_architecture/components/widgets/app_search_bar.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/constants/work_order_status.dart';
import 'package:clean_architecture/core/utils/geo/coordinate_parser.dart';
import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/maps/map_legend.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/app_bar/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class WorkOrdersMapPage extends StatefulWidget {
  const WorkOrdersMapPage({super.key});

  @override
  State<WorkOrdersMapPage> createState() => _WorkOrdersMapPageState();
}

class _WorkOrdersMapPageState extends State<WorkOrdersMapPage> {
  Set<Marker> _markers = {};

  List<WorkOrderEntity> _allOrders = [];
  List<WorkOrderEntity> _displayedOrders = [];

  String? _selectedStatusFilter;
  int? _selectedDepartmentFilter;

  final TextEditingController _searchController = TextEditingController();
  String? _searchValue;

  bool _isLoadingOrders = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  static const int _pageSize = 10;
  int _currentOffset = 0;

  static const double _boundsPadding = 100.0;

  final GetAllWorkOrdersUseCase _getAllWorkOrdersUseCase =
      GetIt.I<GetAllWorkOrdersUseCase>();

  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _loadOrders(refresh: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onSearch() {
    final text = _searchController.text.trim();
    _searchValue = text.isEmpty ? null : text;
    _loadOrders(refresh: true);
  }

  void _onClearSearch() {
    _searchController.clear();
    _searchValue = null;
    _loadOrders(refresh: true);
  }

  Future<void> _loadOrders({required bool refresh}) async {
    if (refresh) {
      _currentOffset = 0;
      _hasMore = true;
      _allOrders.clear();
    }

    if (!_hasMore && !refresh) return;

    setState(() {
      _isLoadingOrders = refresh ? true : _isLoadingOrders;
      _isLoadingMore = !refresh;
      _errorMessage = null;
    });

    try {
      final result = await _getAllWorkOrdersUseCase.call(
        searchValue: _searchValue,
        limit: _pageSize,
        offset: _currentOffset,
      );

      if (!mounted) return;

      result.when(
        success: (orders) {
          setState(() {
            if (refresh) {
              _allOrders = orders;
            } else {
              _allOrders.addAll(orders);
            }

            _hasMore = orders.length == _pageSize;
            _currentOffset += orders.length;

            _applyFiltersAndLimit();
            _isLoadingOrders = false;
            _isLoadingMore = false;
          });
        },
        failure: (message, _) {
          setState(() {
            _errorMessage = message ?? 'Error al cargar órdenes';
            _isLoadingOrders = false;
            _isLoadingMore = false;
          });
        },
        loading: () => setState(() {
          _isLoadingOrders = true;
        }),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error inesperado: $e';
        _isLoadingOrders = false;
        _isLoadingMore = false;
      });
    }
  }

  void _applyFiltersAndLimit() {
    List<WorkOrderEntity> filtered = _allOrders.where((order) {
      if (_positionOf(order) == null) return false;
      final statusMatch =
          _selectedStatusFilter == null ||
          WorkOrderStatus.normalize(order.status) == _selectedStatusFilter;
      final departmentMatch =
          _selectedDepartmentFilter == null ||
          order.departmentId == _selectedDepartmentFilter;
      return statusMatch && departmentMatch;
    }).toList();

    _displayedOrders = filtered;

    _updateMarkers();
  }

  /// Posición de la orden o `null` si no tiene coordenadas válidas.
  LatLng? _positionOf(WorkOrderEntity order) {
    final p = CoordinateParser.parse(
      order.coordinates,
      latitude: order.latitude,
      longitude: order.longitude,
    );
    return p == null ? null : LatLng(p.lat, p.lng);
  }

  Future<void> _updateMarkers() async {
    final Set<Marker> newMarkers = {};

    for (final order in _displayedOrders) {
      final position = _positionOf(order);
      if (position == null) continue;

      newMarkers.add(
        Marker(
          markerId: MarkerId(
            [order.workOrderId, order.orderCode].firstWhere(
              (s) => s != null && s.isNotEmpty,
              orElse: () => '${position.latitude},${position.longitude}',
            )!,
          ),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            MapUtils.getStatusHue(order.status),
          ),
          infoWindow: InfoWindow(
            title: 'OT #: ${order.orderCode}',
            snippet: order.location,
            onTap: () {
              _showLegendDialog(order);
            },
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() => _markers = newMarkers);

    if (_markers.isNotEmpty && mounted && _controller != null) {
      try {
        final LatLngBounds bounds = _getBoundsFromMarkers(_markers);
        await _controller!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, _boundsPadding),
        );
      } catch (e) {
        debugPrint('Error al ajustar cámara: $e');
      }
    }
  }

  // Dialogo con leyenda y acciones
  void _showLegendDialog(WorkOrderEntity order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            'Orden N°: ${order.orderCode}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.connection, size: 16, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(
                        'C.C:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.cadastralKey,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MapUtils.getStatusColor(
                        order.status,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: MapUtils.getStatusColor(order.status),
                      ),
                    ),
                    child: Text(
                      MapUtils.getStatusText(order.status),
                      style: TextStyle(
                        color: MapUtils.getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    MapUtils.getDepartmentIcon(order.departmentId ?? 0),
                    size: 16,
                    color: MapUtils.getDepartmentColor(order.departmentId ?? 0),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      MapUtils.getDepartmentText(order.departmentId ?? 0),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(AppIcons.location, size: 16, color: Colors.red),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      order.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(AppIcons.user, size: 16, color: Colors.orange),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      order.clientId,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionButton(
                  icon: AppIcons.location,
                  label: 'Mapa',
                  tooltip: 'Ver en el mapa',
                  size: ActionButtonSize.small,
                  circular: true,
                  onPressed: () => {
                    context.router.pop(),
                    context.router.push(WorkOrderMapRoute(order: order)),
                  },
                ),
                ActionButton(
                  icon: AppIcons.details,
                  label: 'Ver detalles',
                  tooltip: 'Ver detalles de la orden',
                  circular: true,
                  size: ActionButtonSize.small,
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    context.router.push(WorkOrderDetailRoute(order: order)),
                  },
                ),
                ActionButton(
                  icon: AppIcons.close,
                  label: 'Cerrar',
                  tooltip: 'Cerrar diálogo',
                  size: ActionButtonSize.small,
                  onPressed: () => Navigator.of(context).pop(),
                  style: ActionButtonStyle.outlined,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  LatLngBounds _getBoundsFromMarkers(Set<Marker> markers) {
    final List<double> latitudes = [];
    final List<double> longitudes = [];

    for (final marker in markers) {
      latitudes.add(marker.position.latitude);
      longitudes.add(marker.position.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(latitudes.reduce(min), longitudes.reduce(min)),
      northeast: LatLng(latitudes.reduce(max), longitudes.reduce(max)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom + 80;

    return Scaffold(
      extendBody: true,
      appBar: BaseAppBar(
        title:
            'Mapa de Órdenes (${_displayedOrders.length}${_hasMore ? '+' : ''})',
        actions: [
          IconButton(
            icon: _isLoadingOrders || _isLoadingMore
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: (_isLoadingOrders || _isLoadingMore)
                ? null
                : () => _loadOrders(refresh: true),
            tooltip: 'Actualizar órdenes',
          ),
        ],
      ),
      body: Column(
        children: [
          Tooltip(
            message: 'Buscar por código de orden, cédula o clave catastral',
            waitDuration: const Duration(milliseconds: 500),
            showDuration: const Duration(seconds: 2),
            child: AppSearchBar(
              controller: _searchController,
              hintText: 'Código de orden, cédula o clave catastral',
              onSearch: _onSearch,
              onClear: _onClearSearch,
            ),
          ),
          if (_isLoadingOrders && _allOrders.isNotEmpty)
            const LinearProgressIndicator(minHeight: 3),
          Expanded(
            child: _buildBody(context, bottomInset),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, double bottomInset) {
    if (_isLoadingOrders && _allOrders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _allOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _loadOrders(refresh: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(0.33117, -78.21816),
            zoom: 13,
          ),
          onMapCreated: (controller) {
            if (mounted) {
              setState(() {
                _controller = controller;
              });
            }
          },
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: true,
          zoomControlsEnabled: true,
          padding: EdgeInsets.only(
            bottom: bottomInset + 120,
          ),
        ),

        // Información de Contenido mostrado
        MapLegend(bottomInset: 20),

        // Filtros de estado y departamento
        Positioned(
          top: 8,
          left: 8,
          width: 210,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String?>(
                    isExpanded: true,
                    value: _selectedStatusFilter,
                    hint: const Text(
                      'Filtrar por Estado',
                      style: TextStyle(fontSize: 12),
                    ),
                    underline: const SizedBox.shrink(),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text(
                          'Todos los estados',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      ...WorkOrderStatus.all.map(
                        (s) => DropdownMenuItem<String?>(
                          value: s.code,
                          child: Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: MapUtils.getStatusColor(s.code),
                                size: 12,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.label,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedStatusFilter = value);
                      _applyFiltersAndLimit();
                    },
                  ),
                  const Divider(height: 1),
                  DropdownButton<int?>(
                    isExpanded: true,
                    value: _selectedDepartmentFilter,
                    hint: const Text(
                      'Filtrar por Departamento',
                      style: TextStyle(fontSize: 12),
                    ),
                    underline: const SizedBox.shrink(),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text(
                          'Todos los Departamentos',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      ...[1, 2, 3, 4, 5, 6].map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Row(
                            children: [
                              Icon(
                                MapUtils.getDepartmentIcon(v),
                                size: 14,
                                color: MapUtils.getDepartmentColor(v),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  MapUtils.getDepartmentText(v),
                                  style: const TextStyle(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedDepartmentFilter = value);
                      _applyFiltersAndLimit();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // Aviso si no hay resultados cargados que coincidan
        if (_displayedOrders.isEmpty && !_isLoadingOrders)
          Positioned(
            top: 130,
            left: 20,
            right: 20,
            child: Center(
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white.withValues(alpha: 0.95),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _allOrders.isEmpty
                              ? 'No se encontraron órdenes'
                              : 'Ninguna orden cargada coincide con los filtros',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Botón Cargar más OTs
        if (_hasMore)
          Positioned(
            bottom: bottomInset + 35,
            left: 20,
            right: 20,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _isLoadingMore
                    ? null
                    : () => _loadOrders(refresh: false),
                icon: _isLoadingMore
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh_sharp),
                label: Text(
                  _isLoadingMore
                      ? 'Cargando...'
                      : 'Cargar más $_pageSize OTs',
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(
                      255,
                      141,
                      68,
                      243,
                    ).withValues(alpha: _isLoadingMore ? 0.5 : 1.0),
                  ),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
