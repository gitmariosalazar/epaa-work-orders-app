import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/connections/form/presentation/screen/map_picker_screen.dart';
import 'package:clean_architecture/utils/convert_coordinates.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/work_order_create_constants.dart';
import '../models/work_order_form_state.dart';

class StepOrderDetails extends StatefulWidget {
  final WorkOrderFormState form;
  final void Function(WorkOrderFormState updatedForm) onFormChange;
  final Map<String, String>? errors;

  const StepOrderDetails({
    super.key,
    required this.form,
    required this.onFormChange,
    this.errors,
  });

  @override
  State<StepOrderDetails> createState() => _StepOrderDetailsState();
}

class _StepOrderDetailsState extends State<StepOrderDetails> {
  late final TextEditingController _locationCtrl;
  late final TextEditingController _descriptionCtrl;
  bool _isLocating = false;
  String? _gpsError;

  @override
  void initState() {
    super.initState();
    _locationCtrl = TextEditingController(text: widget.form.location);
    _descriptionCtrl = TextEditingController(text: widget.form.description);
  }

  @override
  void didUpdateWidget(covariant StepOrderDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.form.location != _locationCtrl.text &&
        widget.form.location != oldWidget.form.location) {
      _locationCtrl.text = widget.form.location;
    }
    if (widget.form.description != _descriptionCtrl.text &&
        widget.form.description != oldWidget.form.description) {
      _descriptionCtrl.text = widget.form.description;
    }
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleGetCurrentLocation() async {
    setState(() {
      _isLocating = true;
      _gpsError = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Los servicios de ubicación GPS están desactivados.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permiso de ubicación GPS denegado.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Permisos de ubicación denegados de forma permanente en la configuración del dispositivo.',
        );
      }

      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 12),
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: settings,
      );

      if (!mounted) return;

      widget.onFormChange(
        widget.form.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

      // Si la dirección está vacía, intentar geocodificación inversa
      if (_locationCtrl.text.trim().isEmpty) {
        try {
          final placemarks = await Geocoding().placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty && mounted) {
            final place = placemarks.first;
            final address = [
              place.street,
              place.subLocality,
              place.locality,
              place.subAdministrativeArea,
            ].whereType<String>().where((e) => e.isNotEmpty).join(', ');

            if (address.isNotEmpty) {
              _locationCtrl.text = address;
              widget.onFormChange(widget.form.copyWith(location: address));
            }
          }
        } catch (_) {
          // Ignorar fallo de geocodificación inversa silenciosamente
        }
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceAll('Exception: ', '');
      setState(() {
        _gpsError = msg;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  void _handleUseConnectionLocation() {
    final conn = widget.form.selectedConnection;
    if (conn == null ||
        conn.connectionCoordinates == null ||
        conn.connectionCoordinates!.isEmpty) {
      return;
    }

    final coords = extractCoordinates(conn.connectionCoordinates!);
    final lat = coords['latitude'];
    final lng = coords['longitude'];

    if (lat != null && lng != null) {
      widget.onFormChange(
        widget.form.copyWith(
          latitude: lat,
          longitude: lng,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coordenadas de la acometida aplicadas con éxito.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleOpenMapPicker() async {
    // Si no hay coordenadas, usar centro de Antonio Ante / Imbabura
    final initialLat = widget.form.latitude ?? 0.3385;
    final initialLng = widget.form.longitude ?? -78.1757;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialLat: initialLat,
          initialLng: initialLng,
          onLocationPicked: (lat, lng) {
            if (!mounted) return;
            widget.onFormChange(
              widget.form.copyWith(
                latitude: lat,
                longitude: lng,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasConnectionCoords = widget.form.selectedConnection?.connectionCoordinates !=
            null &&
        widget.form.selectedConnection!.connectionCoordinates!.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── SECCIÓN 1: CLASIFICACIÓN ─────────────────────────────────
          _buildCard(
            context,
            icon: Icons.assignment_outlined,
            iconColor: AppColors.primary,
            title: 'Clasificación',
            subtitle: 'Define el origen, tipo de labor técnica y prioridad',
            child: Column(
              children: [
                // Origen
                _buildDropdown<String>(
                  context,
                  label: 'Origen *',
                  value: widget.form.origin,
                  items: WorkOrderCreateConstants.origins.map((orig) {
                    return DropdownMenuItem<String>(
                      value: orig.value,
                      child: Row(
                        children: [
                          Icon(orig.icon, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              orig.label,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      widget.onFormChange(widget.form.copyWith(origin: val));
                    }
                  },
                ),
                const SizedBox(height: 14),

                // Tipo de Trabajo
                _buildDropdown<int>(
                  context,
                  label: 'Tipo de Trabajo *',
                  value: widget.form.workTypeId,
                  errorText: widget.errors?['workTypeId'],
                  items: WorkOrderCreateConstants.workTypes.map((t) {
                    return DropdownMenuItem<int>(
                      value: t.id,
                      child: Row(
                        children: [
                          Icon(t.icon, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t.label,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      widget.onFormChange(widget.form.copyWith(workTypeId: val));
                    }
                  },
                ),
                const SizedBox(height: 14),

                // Prioridad
                _buildDropdown<int>(
                  context,
                  label: 'Prioridad *',
                  value: widget.form.priorityId,
                  errorText: widget.errors?['priorityId'],
                  items: WorkOrderCreateConstants.priorities.map((p) {
                    return DropdownMenuItem<int>(
                      value: p.id,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: p.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p.label,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      widget.onFormChange(widget.form.copyWith(priorityId: val));
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── SECCIÓN 2: UBICACIÓN ─────────────────────────────────────
          _buildCard(
            context,
            icon: Icons.location_on_outlined,
            iconColor: Colors.teal,
            title: 'Ubicación',
            subtitle: 'Dirección física y coordenadas geográficas de la orden',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dirección / Lugar
                TextFormField(
                  controller: _locationCtrl,
                  decoration: InputDecoration(
                    labelText: 'Dirección / Lugar del trabajo *',
                    hintText: 'Ej: Av. de los Shyris y Naciones Unidas',
                    prefixIcon: const Icon(Icons.place_outlined),
                    errorText: widget.errors?['location'],
                    filled: true,
                    fillColor: isDark
                        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                        : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (val) {
                    widget.onFormChange(widget.form.copyWith(location: val));
                  },
                ),

                const SizedBox(height: 14),

                // Coordenadas actuales
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? theme.dividerColor.withValues(alpha: 0.2)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.form.latitude != null
                            ? Icons.gps_fixed_rounded
                            : Icons.gps_not_fixed_rounded,
                        color: widget.form.latitude != null
                            ? Colors.green.shade600
                            : Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: widget.form.latitude != null &&
                                widget.form.longitude != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coordenadas GPS capturadas',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Lat: ${widget.form.latitude!.toStringAsFixed(6)}  •  Lng: ${widget.form.longitude!.toStringAsFixed(6)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sin coordenadas GPS',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    'Use el GPS del dispositivo, la acometida o marque en el mapa.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      if (widget.form.latitude != null)
                        IconButton(
                          tooltip: 'Borrar coordenadas',
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            widget.onFormChange(
                              widget.form.copyWith(clearCoordinates: true),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Botones de geolocalización
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Botón 1: GPS Actual
                    OutlinedButton.icon(
                      onPressed: _isLocating ? null : _handleGetCurrentLocation,
                      icon: _isLocating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location_rounded, size: 18),
                      label: Text(_isLocating ? 'Obteniendo GPS...' : 'GPS Actual'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // Botón 2: Ubicación Acometida
                    if (hasConnectionCoords)
                      OutlinedButton.icon(
                        onPressed: _handleUseConnectionLocation,
                        icon: const Icon(Icons.water_drop_outlined, size: 18),
                        label: const Text('De Acometida'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                    // Botón 3: Ajustar en mapa
                    FilledButton.tonalIcon(
                      onPressed: _handleOpenMapPicker,
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text('Ajustar en Mapa'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),

                if (_gpsError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _gpsError!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── SECCIÓN 3: DESCRIPCIÓN ───────────────────────────────────
          _buildCard(
            context,
            icon: Icons.description_outlined,
            iconColor: Colors.deepPurple,
            title: 'Descripción del Trabajo',
            subtitle: 'Detalle las observaciones técnicas o motivo del requerimiento',
            child: TextFormField(
              controller: _descriptionCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Ej: Fuga visible en acometida, medidor trabado, cambio de llave de paso...',
                filled: true,
                fillColor: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (val) {
                widget.onFormChange(widget.form.copyWith(description: val));
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    BuildContext context, {
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? errorText,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        filled: true,
        fillColor: isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? theme.dividerColor.withValues(alpha: 0.2) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
