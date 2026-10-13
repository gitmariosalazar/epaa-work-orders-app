/// Nombres de eventos emitidos por el gateway `/realtime` del backend.
abstract final class WsEvents {
  static const readingUpdated = 'reading:updated';
  static const auditUpdated = 'audit:updated';
}

/// Evento genérico recibido por socket (OCP: nuevos eventos sin cambiar el servicio).
final class RealtimeEvent {
  final String name;
  final Map<String, dynamic> payload;
  const RealtimeEvent(this.name, this.payload);
}
