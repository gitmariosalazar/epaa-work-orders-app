// lib/features/work-orders/presentation/pages/work_order_map_page.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/constants/app_icons.dart';
import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_entity.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/ui/base/buttons/widget_button.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class WorkOrderMapPage extends StatefulWidget {
  final WorkOrderEntity order;

  const WorkOrderMapPage({super.key, required this.order});

  @override
  State<WorkOrderMapPage> createState() => _WorkOrderMapPageState();
}

class _WorkOrderMapPageState extends State<WorkOrderMapPage> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  GoogleMapController? _mapController;

  LatLng? _workLocation;
  LatLng? _currentLocation;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  String _routeInfo = '';
  MapType _currentMapType = MapType.normal;
  bool _isLoadingRoute = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _parseCoordinates();
    _getCurrentLocation();
  }

  void _parseCoordinates() {
    final String? coordStr = widget.order.coordinates?.trim();
    if (coordStr == null || coordStr.isEmpty) {
      setState(() => _errorMessage = 'No hay coordenadas disponibles.');
      return;
    }

    try {
      final String cleanHex = coordStr.replaceAll(' ', '');
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

      _workLocation = LatLng(lat, lon);

      _addWorkMarker();
      setState(() {});
    } catch (e) {
      setState(() => _errorMessage = 'Error al leer coordenadas: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _errorMessage = 'Activa el GPS en tu dispositivo.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _errorMessage = 'Permiso de ubicación denegado.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(
          () => _errorMessage =
              'Permiso denegado permanentemente. Actívalo en Ajustes.',
        );
        await Geolocator.openAppSettings();
        return;
      }

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
          timeLimit: const Duration(seconds: 15),
        );
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _addCurrentMarker();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'No se pudo obtener tu ubicación: $e');
    }
  }

  void _addWorkMarker() {
    if (_workLocation == null) return;
    _markers.add(
      Marker(
        markerId: const MarkerId('work_location'),
        position: _workLocation!,
        infoWindow: InfoWindow(
          title: 'Orden #${widget.order.orderCode}',
          snippet: widget.order.location ?? 'Ubicación de la orden',
          onTap: () => _showLegendDialog(widget.order),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          MapUtils.getStatusHue(widget.order.status), // ← Usando utils
        ),
      ),
    );
  }

  void _addCurrentMarker() {
    if (_currentLocation == null) return;
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation!,
        infoWindow: const InfoWindow(title: 'Mi ubicación actual'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  Future<void> _centerOnWorkLocation() async {
    if (_workLocation == null || _mapController == null) return;
    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_workLocation!, 16),
      );
    } catch (e) {
      debugPrint('Error centrando en orden: $e');
    }
  }

  Future<void> _centerOnCurrentLocation() async {
    if (_currentLocation == null || _mapController == null) return;
    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16),
      );
    } catch (e) {
      debugPrint('Error centrando en actual: $e');
    }
  }

  Future<void> _zoomToFitBoth() async {
    if (_currentLocation == null ||
        _workLocation == null ||
        _mapController == null)
      return;

    try {
      final LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          min(_currentLocation!.latitude, _workLocation!.latitude),
          min(_currentLocation!.longitude, _workLocation!.longitude),
        ),
        northeast: LatLng(
          max(_currentLocation!.latitude, _workLocation!.latitude),
          max(_currentLocation!.longitude, _workLocation!.longitude),
        ),
      );

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    } catch (e) {
      debugPrint('Error ajustando zoom: $e');
    }
  }

  Future<void> _getDirections() async {
    if (_currentLocation == null || _workLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Espera a que se obtenga tu ubicación actual'),
        ),
      );
      return;
    }

    setState(() {
      _isLoadingRoute = true;
      _polylines.clear();
      _routeInfo = 'Buscando ruta...';
    });

    try {
      final String apiKey = AppConfigUtil.I.apiKeyGoogleMaps;
      final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&destination=${_workLocation!.latitude},${_workLocation!.longitude}'
        '&mode=driving'
        '&language=es'
        '&key=$apiKey',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final legs = data['routes'][0]['legs'][0];
          final String distance = legs['distance']['text'];
          final String duration = legs['duration']['text'];
          setState(
            () => _routeInfo =
                'Distancia: $distance • Tiempo aproximado: $duration',
          );

          final String polylinePoints =
              data['routes'][0]['overview_polyline']['points'];
          final List<LatLng> points = _decodePolyline(polylinePoints);

          setState(() {
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: Colors.blue,
                width: 6,
                points: points,
              ),
            );
          });

          await _zoomToFitBoth();
        } else {
          String msg = 'No se encontró ruta disponible';
          switch (data['status']) {
            case 'ZERO_RESULTS':
              msg = 'No hay ruta entre tu ubicación y la orden';
              break;
            case 'NOT_FOUND':
              msg = 'Una de las ubicaciones no pudo ser localizada';
              break;
          }
          setState(() => _routeInfo = msg);
        }
      } else {
        setState(() => _routeInfo = 'Error de conexión con Google Maps');
      }
    } on TimeoutException {
      setState(() => _routeInfo = 'Tiempo de espera agotado. Intenta de nuevo');
    } catch (e) {
      setState(() => _routeInfo = 'Error al calcular ruta');
      debugPrint('Error Directions API: $e');
    } finally {
      setState(() => _isLoadingRoute = false);
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // === NUEVAS FUNCIONES ===

  // Copiar coordenadas al portapapeles
  Future<void> _copyCoordinates() async {
    if (_workLocation == null) return;
    final String text =
        '${_workLocation!.latitude},${_workLocation!.longitude}';
    await FlutterClipboard.copy(text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coordenadas copiadas al portapapeles')),
    );
  }

  // Copiar dirección completa
  Future<void> _copyAddress() async {
    final String address = widget.order.location ?? 'Dirección no disponible';
    await FlutterClipboard.copy(address);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dirección copiada al portapapeles')),
    );
  }

  // Abrir en Google Maps externo (navegación real con voz)
  Future<void> _openInGoogleMaps() async {
    if (_workLocation == null) return;

    final String googleUrl =
        'https://www.google.com/maps/dir/?api=1'
        '&destination=${_workLocation!.latitude},${_workLocation!.longitude}'
        '&travelmode=driving';

    final Uri uri = Uri.parse(googleUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialPos = _workLocation ?? const LatLng(-16.2902, -63.5887);
    final double bottomInset = MediaQuery.of(context).padding.bottom + 80;
    final double fabBottomPadding = bottomInset + 10;

    final String latLngText = _workLocation != null
        ? 'Lat: ${_workLocation!.latitude.toStringAsFixed(6)} | Lng: ${_workLocation!.longitude.toStringAsFixed(6)}'
        : 'Coordenadas no disponibles';

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Mapa - OT: ${widget.order.orderCode}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: initialPos, zoom: 15),
            onMapCreated: (controller) {
              _mapControllerCompleter.complete(controller);
              _mapController = controller;
              if (_workLocation != null) _centerOnWorkLocation();
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapType: _currentMapType,
            zoomControlsEnabled: false,
            padding: EdgeInsets.only(bottom: bottomInset),
          ),

          if (_isLoadingRoute)
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Card de ruta: ahora más arriba para no quedar detrás de los FAB
          if (_routeInfo.isNotEmpty)
            Positioned(
              top: 0, // Muy arriba de los botones
              left: 16,
              right: 16,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _routeInfo,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // Barra inferior fija con coordenadas y dirección
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          latLngText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.order.location ?? 'Dirección no disponible',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Botones pequeños para copiar
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white, size: 20),
                    tooltip: 'Copiar coordenadas',
                    onPressed: _copyCoordinates,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: 'Copiar dirección',
                    onPressed: _copyAddress,
                  ),
                ],
              ),
            ),
          ),

          if (_errorMessage != null)
            Center(
              child: Card(
                color: Colors.red.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: fabBottomPadding, right: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nuevo botón: Abrir en Google Maps (navegación real con voz)
            FloatingActionButton.small(
              heroTag: 'open_gmaps',
              onPressed: _openInGoogleMaps,
              backgroundColor: Colors.red,
              tooltip: 'Abrir en Google Maps (navegación)',
              child: const Icon(Icons.navigation, color: Colors.white),
            ),
            FloatingActionButton.small(
              heroTag: 'directions',
              onPressed: _getDirections,
              backgroundColor: Colors.green,
              tooltip: 'Trazar ruta',
              child: const Icon(Icons.directions, color: Colors.white),
            ),
            FloatingActionButton.small(
              heroTag: 'my_loc',
              onPressed: _centerOnCurrentLocation,
              tooltip: 'Mi ubicación',
              child: const Icon(Icons.my_location),
            ),
            FloatingActionButton.small(
              heroTag: 'work_loc',
              onPressed: _centerOnWorkLocation,
              tooltip: 'Ir a orden',
              child: const Icon(Icons.location_pin),
            ),
            FloatingActionButton.small(
              heroTag: 'map_type',
              onPressed: _toggleMapType,
              tooltip: 'Cambiar mapa',
              child: const Icon(Icons.layers),
            ),
            FloatingActionButton.small(
              heroTag: 'fit',
              onPressed: _zoomToFitBoth,
              tooltip: 'Ver ambos',
              child: const Icon(Icons.zoom_out_map),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Dialog para cuando se da click en la leyenda del mapa, dos opciones: Ir a detalles de la orden o cerrar el dialog
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
                // Botón Ver detalles
                ActionButton(
                  icon: AppIcons.details,
                  label: 'Ver detalles',
                  tooltip: 'Ver detalles de la orden',
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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
