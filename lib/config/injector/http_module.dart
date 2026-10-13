import 'package:clean_architecture/core/services/api/auth_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@module
abstract class HttpModule {
  /// Cliente `package:http` con renovación automática de token.
  @lazySingleton
  http.Client get client => AuthHttpClient(http.Client());
}
