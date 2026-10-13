import 'package:clean_architecture/core/constants/work_order_status.dart';
import 'package:clean_architecture/core/utils/geo/coordinate_parser.dart';
// lib/features/work-orders/presentation/pages/work_orders_map_page.dart

import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/maps/map_legend.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/components/button/widget_button.dart';
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
  //final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};

  List<WorkOrderEntity> _allOrders = [];
  List<WorkOrderEntity> _displayedOrders = [];

  String? _selectedStatusFilter;
  int? _selectedWorkTypeFilter;

  bool _isLoadingOrders = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  static const int _pageSize = 10; // Ahora usamos 10 en 10
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
        limit: _pageSize,
        offset: _currentOffset,
      );

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
      final typeMatch =
          _selectedWorkTypeFilter == null ||
          order.workTypeId == _selectedWorkTypeFilter;
      return statusMatch && typeMatch;
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

    // Solo actualizamos si el widget sigue montado
    if (!mounted) return;

    setState(() => _markers = newMarkers);

    // Verificamos que el widget esté montado y el controller no sea null
    if (_markers.isNotEmpty && mounted && _controller != null) {
      try {
        final LatLngBounds bounds = _getBoundsFromMarkers(_markers);
        await _controller!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, _boundsPadding),
        );
      } catch (e) {
        // Si falla el animateCamera (por controller disposed), lo ignoramos silenciosamente
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.deepPurple,
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        order.cadastralKey,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
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
                    MapUtils.getWorkTypeIcon(order.workTypeId),
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    MapUtils.getWorkTypeText(order.workTypeId),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
                      order.location ?? 'Sin dirección',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Client info
              Row(
                children: [
                  Icon(AppIcons.user, size: 16, color: Colors.orange),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      order.clientId ?? 'Cliente desconocido',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
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

                // Botón Ver detalles
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

                // Close button
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

    if (_isLoadingOrders) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mapa de Órdenes',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualizar órdenes',
              onPressed: () {
                _loadOrders(refresh: true);
              },
            ),
          ],
        ),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Mapa de Órdenes (${_displayedOrders.length}${_hasMore ? '+' : ''})',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isLoadingMore
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isLoadingMore ? null : () => _loadOrders(refresh: true),
            tooltip: 'Actualizar órdenes',
          ),
        ],
      ),
      body: Stack(
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
            ), // + espacio para botón
          ),

          // Positioned de Informacion de Contenido mostrado
          MapLegend(bottomInset: 20),

          // Filtros de estado y tipo de trabajo
          Positioned(
            top: 0,
            left: 0,
            width: 200,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String?>(
                      isExpanded: true,
                      value: _selectedStatusFilter,
                      hint: const Text('Filtrar por Estado'),
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
                    DropdownButton<int?>(
                      isExpanded: true,
                      value: _selectedWorkTypeFilter,
                      hint: const Text('Filtrar por Tipo de Trabajo'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text(
                            'Todos los tipos',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ...[1, 2, 3, 4, 5].map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Row(
                              children: [
                                Icon(MapUtils.getWorkTypeIcon(v), size: 12),
                                const SizedBox(width: 8),
                                Text(
                                  MapUtils.getWorkTypeText(v),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ), // ← Usando utils
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedWorkTypeFilter = value);
                        _applyFiltersAndLimit();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

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
                      Color.fromARGB(
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
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
