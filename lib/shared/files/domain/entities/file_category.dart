/// Categorías de archivos (deben coincidir con el backend `/files/:type/...`).
enum FileCategory {
  incidents('incidents'),
  readings('readings'),
  qrcodes('qrcodes'),
  connections('connections'),
  workOrders('work_orders');

  const FileCategory(this.value);

  /// Segmento de ruta que espera el backend.
  final String value;
}
