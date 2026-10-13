/// Módulo compartido de archivos — API pública.
///
/// ```dart
/// import 'package:clean_architecture/shared/files/files.dart';
///
/// // Widget
/// SecureFileImage(category: FileCategory.incidents, filename: 'foto.jpg');
///
/// // Caso de uso
/// final result = await GetIt.I<DownloadFileUseCase>()(
///   const FileParams(category: FileCategory.workOrders, filename: 'ot.pdf'),
/// );
/// ```
library;

export 'domain/entities/file_category.dart';
export 'domain/params/file_params.dart';
export 'domain/repositories/file_repository.dart';
export 'domain/usecases/file_use_cases.dart';
export 'presentation/cubit/file_preview_cubit.dart';
export 'presentation/widgets/secure_file_image.dart';
