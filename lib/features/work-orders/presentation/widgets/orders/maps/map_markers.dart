import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkers extends Marker {
  final String name;

  // ignore: use_super_parameters
  MapMarkers(
    this.name, {
    required MarkerId id,
    required lat,
    required lng,
    onTap,
  }) : super(
         markerId: id,
         position: LatLng(lat, lng),
         infoWindow: InfoWindow(title: name, snippet: '*'),
         onTap: onTap,
       );
}
