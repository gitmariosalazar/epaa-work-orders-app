import 'package:flutter/material.dart';

class MapPickerScreen extends StatelessWidget {
  final double initialLat;
  final double initialLng;
  final Function(double, double) onLocationPicked;

  const MapPickerScreen({
    super.key,
    required this.initialLat,
    required this.initialLng,
    required this.onLocationPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Picker Stub')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onLocationPicked(initialLat, initialLng);
            Navigator.pop(context);
          },
          child: const Text('Pick initial location'),
        ),
      ),
    );
  }
}
