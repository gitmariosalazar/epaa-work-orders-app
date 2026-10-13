/// Módulo de usuarios — API pública.
///
/// Uso desde cualquier módulo:
/// ```dart
/// import 'package:clean_architecture/features/users/users.dart';
///
/// final result = await GetIt.I<FindTechniciansUseCase>()(TechnicianType.inspector);
/// result.when(
///   success: (technicians) => ...,
///   failure: (message, _) => ...,
///   loading: () {},
/// );
/// ```
library;

export 'domain/entities/technician_entity.dart';
export 'domain/entities/user_entity.dart';
export 'domain/params/user_params.dart';
export 'domain/repositories/user_repository.dart';
export 'domain/usecases/user_use_cases.dart';
