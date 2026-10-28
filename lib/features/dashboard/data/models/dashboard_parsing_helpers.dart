// features/dashboard/data/models/dashboard_parsing_helpers.dart

int parseToInt(dynamic v, [int fallback = 0]) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ??
      double.tryParse(v.toString())?.toInt() ??
      fallback;
}

int? parseToIntOrNull(dynamic v) => v == null ? null : parseToInt(v);

double parseToDouble(dynamic v, [double fallback = 0.0]) {
  if (v == null) return fallback;
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? fallback;
}

double? parseToDoubleOrNull(dynamic v) => v == null ? null : parseToDouble(v);

String parseToStr(dynamic v, [String fallback = '']) =>
    v?.toString() ?? fallback;

String? parseToStrOrNull(dynamic v) => v?.toString();

bool parseToBool(dynamic v, [bool fallback = false]) {
  if (v == null) return fallback;
  if (v is bool) return v;
  final str = v.toString().toLowerCase();
  if (str == 'true' || str == '1' || str == 't') return true;
  if (str == 'false' || str == '0' || str == 'f') return false;
  return fallback;
}
