import 'package:clean_architecture/features/work-orders/domain/entities/work_order_tracking_entity.dart';

class TimelineMilestoneModel {
  final String estado;
  final String estadoLabel;
  final String? estadoAnterior;
  final String fecha;
  final String? comentario;
  final String? usuarioId;

  TimelineMilestoneModel({
    required this.estado,
    required this.estadoLabel,
    this.estadoAnterior,
    required this.fecha,
    this.comentario,
    this.usuarioId,
  });

  factory TimelineMilestoneModel.fromJson(Map<String, dynamic> json) {
    return TimelineMilestoneModel(
      estado: (json['estado'] ?? '').toString(),
      estadoLabel: (json['estadoLabel'] ?? json['estado'] ?? '').toString(),
      estadoAnterior: json['estadoAnterior']?.toString(),
      fecha: (json['fecha'] ?? '').toString(),
      comentario: json['comentario']?.toString(),
      usuarioId: json['usuarioId']?.toString(),
    );
  }

  TimelineMilestoneEntity toEntity() {
    return TimelineMilestoneEntity(
      estado: estado,
      estadoLabel: estadoLabel,
      estadoAnterior: estadoAnterior,
      fecha: fecha,
      comentario: comentario,
      usuarioId: usuarioId,
    );
  }
}

class WorkOrderTrackingModel {
  final String idOrdenTrabajo;
  final String codigoOrden;
  final int numeroSecuencial;
  final String origen;
  final String? idEntidadOrigen;
  final String tipoTrabajo;
  final String prioridad;
  final List<TimelineMilestoneModel> historial;

  WorkOrderTrackingModel({
    required this.idOrdenTrabajo,
    required this.codigoOrden,
    this.numeroSecuencial = 0,
    required this.origen,
    this.idEntidadOrigen,
    required this.tipoTrabajo,
    required this.prioridad,
    this.historial = const [],
  });

  static int _toInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? defaultValue;
    return defaultValue;
  }

  factory WorkOrderTrackingModel.fromJson(Map<String, dynamic> json) {
    final history =
        (json['historial'] as List?)
            ?.map(
              (e) => TimelineMilestoneModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList() ??
        [];

    return WorkOrderTrackingModel(
      idOrdenTrabajo: (json['idOrdenTrabajo'] ?? json['id_orden_trabajo'] ?? '')
          .toString(),
      codigoOrden: (json['codigoOrden'] ?? json['codigo_orden'] ?? '')
          .toString(),
      numeroSecuencial: _toInt(
        json['numeroSecuencial'] ?? json['numero_secuencial'],
      ),
      origen: (json['origen'] ?? '').toString(),
      idEntidadOrigen: json['idEntidadOrigen']?.toString(),
      tipoTrabajo: (json['tipoTrabajo'] ?? '').toString(),
      prioridad: (json['prioridad'] ?? '').toString(),
      historial: history,
    );
  }

  WorkOrderTrackingEntity toEntity() {
    return WorkOrderTrackingEntity(
      idOrdenTrabajo: idOrdenTrabajo,
      codigoOrden: codigoOrden,
      numeroSecuencial: numeroSecuencial,
      origen: origen,
      idEntidadOrigen: idEntidadOrigen,
      tipoTrabajo: tipoTrabajo,
      prioridad: prioridad,
      historial: historial.map((m) => m.toEntity()).toList(),
    );
  }
}
