// lib/features/work-orders/presentation/pages/work_orders_map_page.dart

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/utils/map_utils.dart'; // ← Import del utils
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/features/work-orders/domain/usecases/get_all_work_order_use_case.dart';
import 'package:clean_architecture/features/work-orders/presentation/widgets/orders/maps/map_legend.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/components/button/widget_button.dart';
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
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};

  List<WorkOrderEntity> _allOrders = [];
  List<WorkOrderEntity> _displayedOrders = [];

  int? _selectedStatusFilter;
  int? _selectedWorkTypeFilter;

  bool _isLoadingOrders = true;
  String? _errorMessage;

  static const int _maxOrdersToShow = 50; // Límite seguro
  static const double _boundsPadding = 100.0;

  final GetAllWorkOrdersUseCase _getAllWorkOrdersUseCase =
      GetIt.I<GetAllWorkOrdersUseCase>();

  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoadingOrders = true;
      _errorMessage = null;
    });

    try {
      final result = await _getAllWorkOrdersUseCase.call();

      result.when(
        success: (orders) {
          setState(() {
            _allOrders = orders;
            _applyFiltersAndLimit();
            _isLoadingOrders = false;
          });
        },
        failure: (message, _) {
          setState(() {
            _errorMessage = message ?? 'Error al cargar órdenes';
            _isLoadingOrders = false;
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
      });
    }
  }

  void _applyFiltersAndLimit() {
    List<WorkOrderEntity> filtered = _allOrders.where((order) {
      if (order.coordinates == null || order.coordinates!.isEmpty) return false;
      final statusMatch =
          _selectedStatusFilter == null ||
          order.status == _selectedStatusFilter;
      final typeMatch =
          _selectedWorkTypeFilter == null ||
          order.workTypeId == _selectedWorkTypeFilter;
      return statusMatch && typeMatch;
    }).toList();

    _displayedOrders = filtered.take(_maxOrdersToShow).toList();

    _updateMarkers();
  }

  LatLng _parseLatLng(String coordStr) {
    try {
      final String cleanHex = coordStr.trim().replaceAll(' ', '');
      final List<int> bytes = [];
      for (int i = 0; i < cleanHex.length; i += 2) {
        bytes.add(int.parse(cleanHex.substring(i, i + 2), radix: 16));
      }

      final ByteData byteData = ByteData.sublistView(
        Uint8List.fromList(bytes),
        9,
      );
      final double lon = byteData.getFloat64(0, Endian.little);
      final double lat = byteData.getFloat64(8, Endian.little);

      return LatLng(lat, lon);
    } catch (e) {
      debugPrint('Error parsing WKB: $e');
      return const LatLng(0, 0);
    }
  }

  Future<void> _updateMarkers() async {
    final Set<Marker> newMarkers = {};

    for (final order in _displayedOrders) {
      final position = _parseLatLng(order.coordinates!);
      if (position.latitude == 0 && position.longitude == 0) continue;

      final customIcon = await MapUtils.getStatusHue(order.status);

      newMarkers.add(
        Marker(
          markerId: MarkerId(order.orderCode ?? 'unknown'),
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

    setState(() => _markers = newMarkers);

    // Ajustar cámara para mostrar todos los marcadores
    if (_markers.isNotEmpty && _controller != null) {
      final LatLngBounds bounds = _getBoundsFromMarkers(_markers);
      _controller!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, _boundsPadding),
      );
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
                      ).withOpacity(0.2),
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
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
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
        title: const Text(
          'Mapa de Órdenes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.33117, -78.21816),
              zoom: 13,
            ),
            onMapCreated: (controller) {
              _mapController.complete(controller);
              _controller = controller;
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            zoomControlsEnabled: true,
            padding: EdgeInsets.only(bottom: bottomInset + 45),
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
                    DropdownButton<int?>(
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
                        ...[1, 2, 3, 4, 5, 6, 7, 8].map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: HSVColor.fromAHSV(
                                    1.0,
                                    MapUtils.getStatusHue(v),
                                    1.0,
                                    1.0,
                                  ).toColor(),
                                  size: 12,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  MapUtils.getStatusText(v),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ), // ← Usando utils
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
