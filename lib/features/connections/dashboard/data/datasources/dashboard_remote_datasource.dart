import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:clean_architecture/features/incidents/data/datasources/incident_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

class DashboardAdvanceDto {
  final int totalUniverso;
  final double pctProgresoTotal;
  final int actualizacionesHoy;
  final List<Map<String, dynamic>> historico;
  final List<Map<String, dynamic>> distribucion;
  final List<Map<String, dynamic>> porZonas;
  final List<Map<String, dynamic>> distribucionTarifas;
  final List<Map<String, dynamic>> instalacionesRecientesCoords;
  final List<Map<String, dynamic>> curvaCrecimiento;
  final int conAlcantarillado;
  final int sinAlcantarillado;
  final double precisionPromedio;
  final int totalHabitantes;
  final int conMedidor;
  final int sinMedidor;
  final int activas;
  final int inactivas;

  const DashboardAdvanceDto({
    required this.totalUniverso,
    required this.pctProgresoTotal,
    required this.actualizacionesHoy,
    required this.historico,
    required this.distribucion,
    required this.porZonas,
    required this.distribucionTarifas,
    required this.instalacionesRecientesCoords,
    required this.curvaCrecimiento,
    required this.conAlcantarillado,
    required this.sinAlcantarillado,
    required this.precisionPromedio,
    required this.totalHabitantes,
    required this.conMedidor,
    required this.sinMedidor,
    required this.activas,
    required this.inactivas,
  });

  static int _int(dynamic v, [int fallback = 0]) {
    if (v == null) return fallback;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  static double _double(dynamic v, [double fallback = 0.0]) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? fallback;
  }

  static List<Map<String, dynamic>> _list(dynamic v) {
    if (v is List) {
      return v.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  factory DashboardAdvanceDto.fromJson(Map<String, dynamic> json) {
    final resumen = json['resumen'] as Map<String, dynamic>? ?? {};
    final cobAlc =
        json['coberturaAlcantarillado'] as Map<String, dynamic>? ?? {};
    final gps = json['calidadGps'] as Map<String, dynamic>? ?? {};
    final pob = json['poblacionServida'] as Map<String, dynamic>? ?? {};
    final med = json['coberturaMedidores'] as Map<String, dynamic>? ?? {};
    final red = json['estadoRed'] as Map<String, dynamic>? ?? {};

    return DashboardAdvanceDto(
      totalUniverso: _int(resumen['total_universo']),
      pctProgresoTotal: _double(resumen['pct_progreso_total']),
      actualizacionesHoy: _int(resumen['actualizaciones_hoy']),
      historico: _list(json['historico']),
      distribucion: _list(json['distribucion']),
      porZonas: _list(json['porZonas']),
      distribucionTarifas: _list(json['distribucionTarifas']),
      instalacionesRecientesCoords: _list(json['instalacionesRecientesCoords']),
      curvaCrecimiento: _list(json['curvaCrecimiento']),
      conAlcantarillado: _int(cobAlc['con_alcantarillado']),
      sinAlcantarillado: _int(cobAlc['sin_alcantarillado']),
      precisionPromedio: _double(gps['precision_promedio']),
      totalHabitantes: _int(pob['total_habitantes']),
      conMedidor: _int(med['con_medidor']),
      sinMedidor: _int(med['sin_medidor']),
      activas: _int(red['activas']),
      inactivas: _int(red['inactivas']),
    );
  }
}

abstract class DashboardRemoteDataSource {
  FutureData<DashboardAdvanceDto> getDashboardAdvance();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiService apiService;

  DashboardRemoteDataSourceImpl(this.apiService);

  @override
  FutureData<DashboardAdvanceDto> getDashboardAdvance() {
    return DataHandler.safeApiCall<DashboardAdvanceDto, DashboardAdvanceDto>(
      request: () => apiService.get('/connections/dashboard/advancement-stats'),
      fromJson: (json) => DashboardAdvanceDto.fromJson(json),
      isStandardResponse: true,
      responseDataKey: 'data',
    );
  }
}
