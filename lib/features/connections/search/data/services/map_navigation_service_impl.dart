import 'package:clean_architecture/features/connections/search/domain/services/map_navigation_service.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@LazySingleton(as: MapNavigationService)
class MapNavigationServiceImpl implements MapNavigationService {
  @override
  Future<void> navigateTo(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
    );
    
    bool success = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!success) {
      success = await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    }
    
    if (!success) {
      throw Exception('No se pudo abrir la aplicación de mapas en tu dispositivo.');
    }
  }
}
