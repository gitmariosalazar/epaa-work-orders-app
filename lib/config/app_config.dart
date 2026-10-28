import 'package:flutter/foundation.dart';
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
  final bool enableHttpInspector;
  final bool showHttpInspectorNotifications;

  const AppConfig({
    required this.appTitle,
    required this.apiBaseUrl,
    required this.flavor,
    required this.apiKeyGoogleMaps,
    this.enableHttpInspector = false,
    this.showHttpInspectorNotifications = false,
  });

  bool get isProduction => flavor == Flavor.production;
  bool get isDevelopment => flavor == Flavor.development;
  bool get isStaging => flavor == Flavor.staging;
}

String _normalizeBaseUrl(String? url, String fallback) {
  final resolved = (url != null && url.trim().isNotEmpty)
      ? url.trim()
      : fallback;
  return resolved.endsWith('/') ? resolved : '$resolved/';
}

@LazySingleton(as: AppConfig, env: [Flavor.production])
class AppConfigProd extends AppConfig {
  AppConfigProd()
    : super(
        appTitle: "Clean Architecture App",
        apiBaseUrl: _normalizeBaseUrl(
          dotenv.maybeGet("BASE_PRODUCTION"),
          "https://dev.sigepaa-aa.com/",
        ),
        flavor: Flavor.production,
        apiKeyGoogleMaps: dotenv.maybeGet("GOOGLE_MAPS_API_KEY") ?? "",
        enableHttpInspector: false,
        showHttpInspectorNotifications: false,
      );
}

@LazySingleton(as: AppConfig, env: [Flavor.staging])
class AppConfigStg extends AppConfig {
  AppConfigStg()
    : super(
        appTitle: "Clean Architecture App Staging",
        apiBaseUrl: _normalizeBaseUrl(
          dotenv.maybeGet("BASE_STAGING"),
          "https://apidev.sigepaa-aa.com/",
        ),
        flavor: Flavor.staging,
        apiKeyGoogleMaps: dotenv.maybeGet("GOOGLE_MAPS_API_KEY") ?? "",
        enableHttpInspector: kDebugMode,
        showHttpInspectorNotifications: false,
      );
}

@LazySingleton(as: AppConfig, env: [Flavor.development])
class AppConfigDev extends AppConfig {
  AppConfigDev()
    : super(
        appTitle: "Clean Architecture App Development",
        apiBaseUrl: _normalizeBaseUrl(
          dotenv.maybeGet("BASE_DEVELOPMENT"),
          "https://dev.sigepaa-aa.com/",
        ),
        flavor: Flavor.development,
        apiKeyGoogleMaps: dotenv.maybeGet("GOOGLE_MAPS_API_KEY") ?? "",
        enableHttpInspector: kDebugMode,
        showHttpInspectorNotifications: kDebugMode,
      );
}

/// A util class for accessing [AppConfig]
abstract final class AppConfigUtil {
  /// Returns the registered instance of [AppConfig] which is always the same.
  static AppConfig get I => GetIt.I<AppConfig>();
}
