import 'package:clean_architecture/shared/files/domain/entities/file_category.dart';
import 'package:clean_architecture/shared/files/domain/params/file_params.dart';
import 'package:clean_architecture/shared/files/presentation/cubit/file_preview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Imagen protegida del backend (`/files/:type/:filename/preview`).
///
/// Uso:
/// ```dart
/// SecureFileImage(category: FileCategory.incidents, filename: 'foto.jpg')
/// SecureFileImage.fromPath('/uploads/incidents/foto.jpg')
/// ```
class SecureFileImage extends StatelessWidget {
  final FileParams params;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  SecureFileImage({
    super.key,
    required FileCategory category,
    required String filename,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
  }) : params = FileParams(category: category, filename: filename);

  SecureFileImage.fromPath(
    String path, {
    super.key,
    FileCategory fallback = FileCategory.incidents,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
  }) : params = FileParams.fromPath(path, fallback: fallback);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // key por archivo: cada imagen mantiene su propio estado.
      key: ValueKey(params),
      create: (_) => FilePreviewCubit()..load(params),
      child: BlocBuilder<FilePreviewCubit, FilePreviewState>(
        builder: (context, state) {
          final cs = Theme.of(context).colorScheme;
          Widget child;
          if (state.hasData) {
            child = Image.memory(
              state.bytes!,
              fit: fit,
              width: width,
              height: height,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _placeholder(cs, Icons.broken_image),
            );
          } else if (state.error != null) {
            child = InkWell(
              onTap: () => context.read<FilePreviewCubit>().load(params),
              child: _placeholder(cs, Icons.refresh_rounded),
            );
          } else {
            child = Container(
              width: width,
              height: height,
              color: cs.surfaceContainerHighest,
              alignment: Alignment.center,
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final framed = ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: child,
          );
          return onTap == null || !state.hasData
              ? framed
              : GestureDetector(onTap: onTap, child: framed);
        },
      ),
    );
  }

  Widget _placeholder(ColorScheme cs, IconData icon) => Container(
    width: width,
    height: height,
    color: cs.surfaceContainerHighest,
    alignment: Alignment.center,
    child: Icon(icon, color: cs.onSurfaceVariant),
  );
}
