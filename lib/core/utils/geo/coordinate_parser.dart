import 'dart:convert';
import 'dart:typed_data';

/// Coordenada geográfica independiente de cualquier SDK de mapas.
typedef GeoPoint = ({double lat, double lng});

/// Convierte las distintas representaciones de coordenadas que puede enviar
/// el backend en un [GeoPoint] válido (SRP: única responsabilidad = parseo).
///
/// Formatos soportados:
/// * WKB / EWKB hexadecimal (PostGIS)            `0101000020E6100000...`
/// * WKT                                          `POINT(-78.21 0.33)`
/// * Punto Postgres (node-pg) como Map o String   `{x: -78.21, y: 0.33}`
/// * GeoJSON                                      `{"type":"Point","coordinates":[lng,lat]}`
/// * Texto plano                                  `"0.33, -78.21"` o `"(-78.21,0.33)"`
/// * Campos sueltos `latitude` / `longitude` como respaldo.
abstract final class CoordinateParser {
  static GeoPoint? parse(
    Object? raw, {
    double? latitude,
    double? longitude,
  }) {
    final fromRaw = _parseRaw(raw);
    if (fromRaw != null) return fromRaw;
    if (latitude != null && longitude != null) {
      return _validated(latitude, longitude);
    }
    return null;
  }

  static GeoPoint? _parseRaw(Object? raw) {
    if (raw == null) return null;
    if (raw is Map) return _fromMap(raw);

    final s = raw.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return null;

    // JSON (GeoJSON o {x,y} serializado)
    if (s.startsWith('{') && s.contains('"')) {
      try {
        final decoded = jsonDecode(s);
        if (decoded is Map) return _fromMap(decoded);
      } catch (_) {}
    }

    // {x: -78.2, y: 0.33}  (Map.toString())
    final xy = RegExp(
      r'x\s*:\s*(-?\d+(?:\.\d+)?)\s*,\s*y\s*:\s*(-?\d+(?:\.\d+)?)',
      caseSensitive: false,
    ).firstMatch(s);
    if (xy != null) {
      return _validated(double.parse(xy.group(2)!), double.parse(xy.group(1)!));
    }

    // WKT: POINT(lng lat)
    final wkt = RegExp(
      r'POINT\s*\(\s*(-?\d+(?:\.\d+)?)\s+(-?\d+(?:\.\d+)?)\s*\)',
      caseSensitive: false,
    ).firstMatch(s);
    if (wkt != null) {
      return _validated(
        double.parse(wkt.group(2)!),
        double.parse(wkt.group(1)!),
      );
    }

    // WKB hex
    if (RegExp(r'^[0-9a-fA-F]+$').hasMatch(s) && s.length >= 42) {
      return _fromWkb(s);
    }

    // "a, b" o "(a,b)"
    final pair = RegExp(
      r'^\(?\s*(-?\d+(?:\.\d+)?)\s*[,\s]\s*(-?\d+(?:\.\d+)?)\s*\)?$',
    ).firstMatch(s);
    if (pair != null) {
      final a = double.parse(pair.group(1)!);
      final b = double.parse(pair.group(2)!);
      // Si el primer valor no puede ser latitud, viene como (lng, lat).
      return a.abs() > 90 ? _validated(b, a) : _validated(a, b);
    }

    return null;
  }

  static GeoPoint? _fromMap(Map map) {
    double? n(Object? v) =>
        v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '');

    final coords = map['coordinates'];
    if (coords is List && coords.length >= 2) {
      final lng = n(coords[0]);
      final lat = n(coords[1]);
      if (lat != null && lng != null) return _validated(lat, lng);
    }
    final lat = n(map['lat'] ?? map['latitude'] ?? map['y']);
    final lng = n(map['lng'] ?? map['lon'] ?? map['longitude'] ?? map['x']);
    if (lat != null && lng != null) return _validated(lat, lng);
    return null;
  }

  static GeoPoint? _fromWkb(String hex) {
    try {
      final bytes = Uint8List(hex.length ~/ 2);
      for (var i = 0; i < bytes.length; i++) {
        bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
      }
      final data = ByteData.sublistView(bytes);
      final endian = bytes[0] == 1 ? Endian.little : Endian.big;
      final type = data.getUint32(1, endian);
      // EWKB con SRID (flag 0x20000000) → 4 bytes extra.
      final offset = (type & 0x20000000) != 0 ? 9 : 5;
      final lng = data.getFloat64(offset, endian);
      final lat = data.getFloat64(offset + 8, endian);
      return _validated(lat, lng);
    } catch (_) {
      return null;
    }
  }

  static GeoPoint? _validated(double lat, double lng) {
    if (lat.isNaN || lng.isNaN) return null;
    if (lat.abs() > 90 || lng.abs() > 180) return null;
    if (lat == 0 && lng == 0) return null;
    return (lat: lat, lng: lng);
  }
}
