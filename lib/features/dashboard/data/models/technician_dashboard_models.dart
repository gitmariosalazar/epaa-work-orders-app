// features/dashboard/data/models/technician_dashboard_models.dart

import 'package:clean_architecture/features/dashboard/data/models/dashboard_parsing_helpers.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/technician_dashboard_entities.dart';

class TechnicianPerformanceItemModel extends TechnicianPerformanceItemEntity {
  const TechnicianPerformanceItemModel({
    required super.idTecnico,
    required super.nombreTecnico,
    super.cedula,
    super.telefonoInterno,
    required super.totalOrdenesAsignadasHistoricas,
    required super.ordenesPorIniciar,
    required super.ordenesEnEjecucionHoy,
    required super.ordenesEnPausa,
    required super.totalBacklogActivo,
    required super.totalCompletadas,
    required super.completadasEsteMes,
    super.tasaCumplimientoSlaPct,
    super.horasPromedioEnCampo,
  });

  factory TechnicianPerformanceItemModel.fromJson(Map<String, dynamic> json) =>
      TechnicianPerformanceItemModel(
        idTecnico: parseToStr(json['idTecnico']),
        nombreTecnico: parseToStr(json['nombreTecnico']),
        cedula: parseToStrOrNull(json['cedula']),
        telefonoInterno: parseToStrOrNull(json['telefonoInterno']),
        totalOrdenesAsignadasHistoricas: parseToInt(
          json['totalOrdenesAsignadasHistoricas'],
        ),
        ordenesPorIniciar: parseToInt(json['ordenesPorIniciar']),
        ordenesEnEjecucionHoy: parseToInt(json['ordenesEnEjecucionHoy']),
        ordenesEnPausa: parseToInt(json['ordenesEnPausa']),
        totalBacklogActivo: parseToInt(json['totalBacklogActivo']),
        totalCompletadas: parseToInt(json['totalCompletadas']),
        completadasEsteMes: parseToInt(json['completadasEsteMes']),
        tasaCumplimientoSlaPct: parseToDoubleOrNull(
          json['tasaCumplimientoSlaPct'],
        ),
        horasPromedioEnCampo: parseToDoubleOrNull(json['horasPromedioEnCampo']),
      );

  TechnicianPerformanceItemEntity toEntity() => this;
}

class TechnicianDailyFeedItemModel extends TechnicianDailyFeedItemEntity {
  const TechnicianDailyFeedItemModel({
    required super.idOrdenTrabajo,
    required super.codigoOrden,
    required super.estado,
    required super.nombreEstado,
    required super.tipoTrabajo,
    required super.prioridad,
    required super.slaHoras,
    super.direccion,
    super.ubicacionDetalles,
    super.claveCatastral,
    super.fechaAsignacion,
    super.fechaInicioCampo,
    super.latitud,
    super.longitud,
    required super.horasRestantesSla,
    required super.esOrdenMasPrioritaria,
  });

  factory TechnicianDailyFeedItemModel.fromJson(Map<String, dynamic> json) =>
      TechnicianDailyFeedItemModel(
        idOrdenTrabajo: parseToInt(json['idOrdenTrabajo']),
        codigoOrden: parseToStr(json['codigoOrden']),
        estado: parseToStr(json['estado']),
        nombreEstado: parseToStr(json['nombreEstado']),
        tipoTrabajo: parseToStr(json['tipoTrabajo']),
        prioridad: parseToStr(json['prioridad']),
        slaHoras: parseToInt(json['slaHoras']),
        direccion: parseToStrOrNull(json['direccion']),
        ubicacionDetalles: parseToStrOrNull(json['ubicacionDetalles']),
        claveCatastral: parseToStrOrNull(json['claveCatastral']),
        fechaAsignacion: parseToStrOrNull(json['fechaAsignacion']),
        fechaInicioCampo: parseToStrOrNull(json['fechaInicioCampo']),
        latitud: parseToDoubleOrNull(json['latitud']),
        longitud: parseToDoubleOrNull(json['longitud']),
        horasRestantesSla: parseToDouble(json['horasRestantesSla']),
        esOrdenMasPrioritaria: parseToBool(json['esOrdenMasPrioritaria']),
      );

  TechnicianDailyFeedItemEntity toEntity() => this;
}

class CrewAssignmentItemModel extends CrewAssignmentItemEntity {
  const CrewAssignmentItemModel({
    required super.codigoOrden,
    required super.estadoOt,
    required super.tipoTrabajo,
    required super.nombreTrabajador,
    super.cedula,
    super.rolEnCuadrilla,
    required super.esResponsable,
    super.fechaAsignacion,
  });

  factory CrewAssignmentItemModel.fromJson(Map<String, dynamic> json) =>
      CrewAssignmentItemModel(
        codigoOrden: parseToStr(json['codigoOrden']),
        estadoOt: parseToStr(json['estadoOt']),
        tipoTrabajo: parseToStr(json['tipoTrabajo']),
        nombreTrabajador: parseToStr(json['nombreTrabajador']),
        cedula: parseToStrOrNull(json['cedula']),
        rolEnCuadrilla: parseToStrOrNull(json['rolEnCuadrilla']),
        esResponsable: parseToBool(json['esResponsable']),
        fechaAsignacion: parseToStrOrNull(json['fechaAsignacion']),
      );

  CrewAssignmentItemEntity toEntity() => this;
}
