import 'package:clean_architecture/core/utils/map_utils.dart';
import 'package:flutter/material.dart';

class MapLegend extends StatefulWidget {
  const MapLegend({Key? key, this.bottomInset = 16.0}) : super(key: key);

  final double bottomInset;

  @override
  State<MapLegend> createState() => _MapLegendState();
}

class _MapLegendState extends State<MapLegend> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Panel expandido con grid 4x2
        if (_isExpanded)
          Positioned(
            bottom: widget.bottomInset + 6,
            left: 4,
            right: 4,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(2),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.97),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cabecera
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Leyenda de Estados',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => _isExpanded = false),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ),

                    // Grid 4 columnas x 2 filas
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // 4 columnas
                            childAspectRatio:
                                4.2, // Ajusta la altura de cada item
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                          ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final status = index + 1;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: MapUtils.getStatusColor(status),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                MapUtils.getStatusText(status),
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Botón flotante pequeño
        if (!_isExpanded)
          Positioned(
            bottom: widget.bottomInset,
            right: 8,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white.withOpacity(0.95),
              foregroundColor: Colors.black87,
              elevation: 6,
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(
                _isExpanded ? Icons.close : Icons.legend_toggle,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }
}
