import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/app_initializer.dart';
import 'package:clean_architecture/shared_ui/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/foundation.dart'; // ← NUEVO
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart'; // ← NUEVO
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'; // ← NUEVO

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ← ESTA ES LA SOLUCIÓN QUE ELIMINA EL FREEZE Y CARGA INFINITA
  if (defaultTargetPlatform == TargetPlatform.android) {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  await AppInitializer.initializeApp(environment: Flavor.development);
  usePathUrlStrategy(); // Web-only

  runApp(const CleanArchitectureSample());
}
