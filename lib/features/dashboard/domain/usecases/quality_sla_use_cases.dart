// features/dashboard/domain/usecases/quality_sla_use_cases.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/quality_sla_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/dashboard_analytics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSlaMonitorUseCase
    implements UseCaseNoParameter<List<SlaMonitorItemEntity>> {
  final QualityAndSlaDashboardRepository _repository;

  const GetSlaMonitorUseCase(this._repository);

  @override
  FutureData<List<SlaMonitorItemEntity>> call() => _repository.getSlaMonitor();
}

@lazySingleton
class GetQualityIndicatorsUseCase
    implements UseCaseNoParameter<List<QualityIndicatorItemEntity>> {
  final QualityAndSlaDashboardRepository _repository;

  const GetQualityIndicatorsUseCase(this._repository);

  @override
  FutureData<List<QualityIndicatorItemEntity>> call() =>
      _repository.getQualityIndicators();
}

@lazySingleton
class GetEscalationAuditUseCase
    implements UseCaseNoParameter<List<EscalationAuditItemEntity>> {
  final QualityAndSlaDashboardRepository _repository;

  const GetEscalationAuditUseCase(this._repository);

  @override
  FutureData<List<EscalationAuditItemEntity>> call() =>
      _repository.getEscalationAudit();
}
