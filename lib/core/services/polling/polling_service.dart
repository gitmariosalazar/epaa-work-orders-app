// Servicio genérico de polling basado en Streams.
//   - SRP: sólo gestiona el ciclo de polling.
//   - OCP: extensible por tipo <T>.
//   - DIP: recibe el fetcher como dependencia.
import 'dart:async';

/// Contrato abstracto (mockeable en tests).
abstract interface class PollingService<T> {
  Stream<T> get stream;
  bool get isRunning;
  void start();
  void stop();
  void dispose();
}

/// Implementación basada en [Timer.periodic]. Resiliente: los errores
/// se emiten en el stream pero no detienen el ciclo.
final class PeriodicPollingService<T> implements PollingService<T> {
  final Future<T> Function() _fetcher;
  final Duration interval;
  final void Function(Object error, StackTrace st)? onError;

  final _controller = StreamController<T>.broadcast();
  Timer? _timer;
  bool _disposed = false;
  bool _fetching = false;

  PeriodicPollingService({
    required Future<T> Function() fetcher,
    required this.interval,
    this.onError,
  }) : _fetcher = fetcher;

  @override
  Stream<T> get stream => _controller.stream;

  @override
  bool get isRunning => _timer?.isActive ?? false;

  @override
  void start() {
    if (_disposed || isRunning) return;
    _fetch();
    _timer = Timer.periodic(interval, (_) => _fetch());
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetch() async {
    if (_disposed || _fetching) return; // evita solapamientos
    _fetching = true;
    try {
      final result = await _fetcher();
      if (!_disposed && !_controller.isClosed) _controller.add(result);
    } catch (e, st) {
      onError?.call(e, st);
      if (!_disposed && !_controller.isClosed) _controller.addError(e, st);
    } finally {
      _fetching = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    stop();
    _controller.close();
  }
}
