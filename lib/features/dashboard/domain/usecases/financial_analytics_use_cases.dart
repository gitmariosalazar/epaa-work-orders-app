// features/dashboard/domain/usecases/financial_analytics_use_cases.dart

import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/domain/entities/financial_dashboard_entities.dart';
import 'package:clean_architecture/features/dashboard/domain/repositories/dashboard_analytics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetMaterialCostsUseCase
    implements UseCaseNoParameter<List<MaterialCostItemEntity>> {
  final FinancialDashboardRepository _repository;

  const GetMaterialCostsUseCase(this._repository);

  @override
  FutureData<List<MaterialCostItemEntity>> call() =>
      _repository.getMaterialCosts();
}

@lazySingleton
class GetEconomicBalanceUseCase
    implements UseCaseNoParameter<List<EconomicBalanceItemEntity>> {
  final FinancialDashboardRepository _repository;

  const GetEconomicBalanceUseCase(this._repository);

  @override
  FutureData<List<EconomicBalanceItemEntity>> call() =>
      _repository.getEconomicBalance();
}
