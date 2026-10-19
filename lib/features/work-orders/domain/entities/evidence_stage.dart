/// Etapas de evidencia; [code] coincide con etapa_evidencia.id_etapa_evidencia.
enum EvidenceStage {
  initialReport('REPORTE_INICIAL'),
  inProgress('EN_PROCESO'),
  workCompleted('TRABAJO_TERMINADO'),
  customerApproval('CONFORMIDAD_CLIENTE'),
  safetyInspection('INSPECCION_SEGURIDAD');

  const EvidenceStage(this.code);

  final String code;
}
