/// Utilidades puras (sin dependencias de Flutter) para rutas de archivos
/// servidos por `/files/:type/:filename`.
abstract final class FilePathUtils {
  static const _imageExtensions = {'.jpg', '.jpeg', '.png', '.webp', '.gif', '.heic'};

  /// Quita el `/` inicial (mismo criterio que app-properties).
  static String clean(String path) =>
      path.startsWith('/') ? path.substring(1) : path;

  /// Extrae el nombre real del archivo desde una URL del backend
  /// (`.../files/work_orders/foto.jpg/preview` → `foto.jpg`).
  static String filenameFromUrl(String url, {String fallback = ''}) {
    if (url.trim().isEmpty) return fallback;
    final parts = url.split('?').first.split('/').where((p) => p.isNotEmpty).toList();
    if (parts.isNotEmpty && (parts.last == 'preview' || parts.last == 'download')) {
      parts.removeLast();
    }
    return parts.isNotEmpty ? parts.last : fallback;
  }

  static bool isImage(String name, {String? mimeType}) {
    if (mimeType != null && mimeType.toLowerCase().startsWith('image/')) return true;
    final lower = name.toLowerCase();
    return _imageExtensions.any(lower.endsWith);
  }
}
