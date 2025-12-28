import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

abstract final class Flavor {
  static const production = 'production';
  static const staging = 'staging';
  static const development = 'development';
}

/// App configuration for different app flavors.
sealed class AppConfig {
  final String appTitle;
  final String apiBaseUrl;
  final String flavor;
  final String apiKeyGoogleMaps;

  const AppConfig({
    required this.appTitle,
    required this.apiBaseUrl,
    required this.flavor,
    required this.apiKeyGoogleMaps,
  });
}

@LazySingleton(as: AppConfig, env: [Flavor.production])
class AppConfigProd extends AppConfig {
  AppConfigProd()
    : super(
        appTitle: "Clean Architecture App",
        apiBaseUrl:
            dotenv.maybeGet("BASE_PRODUCTION") ??
            "https://dev.sigepaa-aa.com:8443/",
        flavor: Flavor.production,
        apiKeyGoogleMaps: dotenv.maybeGet("GOOGLE_MAPS_API_KEY") ?? "",
      );
}

@LazySingleton(as: AppConfig, env: [Flavor.staging])
class AppConfigStg extends AppConfig {
  AppConfigStg()
    : super(
        appTitle: "Clean Architecture App Staging",
        apiBaseUrl:
            dotenv.maybeGet("BASE_STAGING") ??
            "https://dev.sigepaa-aa.com:8443/",
        flavor: Flavor.staging,
        apiKeyGoogleMaps: dotenv.maybeGet("GOOGLE_MAPS_API_KEY") ?? "",
      );
}

@LazySingleton(as: AppConfig, env: [Flavor.development])
class AppConfigDev extends AppConfig {
  AppConfigDev()
    : super(
        appTitle: "Clean Architecture App Development",
        apiBaseUrl:
            dotenv.maybeGet("BASE_DEVELOPMENT") ??
            "https://dev.sigepaa-aa.com:8443/",
        flavor: Flavor.development,
        apiKeyGoogleMaps: dotenv.maybeGet("GOOGLE_MAPS_API_KEY") ?? "",
      );
}

/// A util class for accessing [AppConfig]
abstract final class AppConfigUtil {
  /// Returns the registered instance of [AppConfig] which is always the same.
  static AppConfig get I => GetIt.I<AppConfig>();
}
