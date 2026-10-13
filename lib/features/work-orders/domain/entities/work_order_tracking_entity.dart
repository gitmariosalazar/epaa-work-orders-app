import 'package:equatable/equatable.dart';

class TimelineMilestoneEntity extends Equatable {
  final String estado;
  final String estadoLabel;
  final String? estadoAnterior;
  final String fecha;
  final String? comentario;
  final String? usuarioId;

  const TimelineMilestoneEntity({
    required this.estado,
    required this.estadoLabel,
    this.estadoAnterior,
    required this.fecha,
    this.comentario,
    this.usuarioId,
  });

  String? get usuario => usuarioId;

  @override
  List<Object?> get props => [
        estado,
        estadoLabel,
        estadoAnterior,
        fecha,
        comentario,
        usuarioId,
      ];
}

class WorkOrderTrackingEntity extends Equatable {
  final String idOrdenTrabajo;
  final String codigoOrden;
  final int numeroSecuencial;
  final String origen;
  final String? idEntidadOrigen;
  final String tipoTrabajo;
  final String prioridad;
  final List<TimelineMilestoneEntity> historial;

  const WorkOrderTrackingEntity({
    required this.idOrdenTrabajo,
    required this.codigoOrden,
    this.numeroSecuencial = 0,
    required this.origen,
    this.idEntidadOrigen,
    required this.tipoTrabajo,
    required this.prioridad,
    this.historial = const [],
  });

  @override
  List<Object?> get props => [
        idOrdenTrabajo,
        codigoOrden,
        numeroSecuencial,
        origen,
        idEntidadOrigen,
        tipoTrabajo,
        prioridad,
        historial,
      ];
}
