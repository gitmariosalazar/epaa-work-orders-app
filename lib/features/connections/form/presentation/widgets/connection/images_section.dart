// lib/features/properties/form/add-img/presentation/widgets/images_section.dart
/*
import 'dart:io';
import 'package:clean_architecture/components/widgets/attachment_source_picker.dart';
import 'package:clean_architecture/components/common/form_card.dart';
import 'package:clean_architecture/features/connections/form/add-img/presentation/blocs/add_property_image_bloc.dart';
import 'package:clean_architecture/features/connections/form/add-img/presentation/blocs/add_property_image_event.dart';
import 'package:clean_architecture/features/connections/form/add-img/presentation/blocs/add_property_image_state.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/// Images upload section. All colors from [ColorScheme] — adapts to light/dark.
class ImagesSection extends StatefulWidget {
  final String connectionId;
  final String description;

  const ImagesSection({
    super.key,
    required this.connectionId,
    this.description = 'Imágenes de la acometida',
  });

  @override
  State<ImagesSection> createState() => _ImagesSectionState();
}

class _ImagesSectionState extends State<ImagesSection> {
  bool _isPickingImage = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final double imageSize = context.isTablet ? 90.0 : 55.0;

    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_library,
                color: cs.primary,
                size: context.iconSmall,
              ),
              context.hSpace(0.02),
              Text(
                'Fotos de Referencia',
                style: context.titleExtraSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          context.vSpace(0.02),
          SizedBox(
            height: imageSize,
            child: BlocBuilder<AddPropertyImageBloc, AddPropertyImageState>(
              builder: (context, state) {
                final imagePaths = (state is AddPropertyImagePicked)
                    ? state.imagePaths
                    : <String>[];
                final isBlocLoading = state is AddPropertyImageLoading;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length + 1,
                  separatorBuilder: (_, _) =>
                      SizedBox(width: context.smallSpacing),
                  itemBuilder: (context, index) {
                    if (index == imagePaths.length) {
                      return _buildAddButton(
                        size: imageSize,
                        context: context,
                        isLoading: isBlocLoading || _isPickingImage,
                        cs: cs,
                      );
                    }

                    final path = imagePaths[index];
                    final file = File(path);

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: file.existsSync()
                              ? Image.file(
                                  file,
                                  width: imageSize,
                                  height: imageSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _brokenImagePlaceholder(
                                      imageSize,
                                      cs,
                                    );
                                  },
                                )
                              : _brokenImagePlaceholder(imageSize, cs),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => context
                                .read<AddPropertyImageBloc>()
                                .add(RemoveImageEvent(index)),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: cs.errorContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: cs.onErrorContainer,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          BlocListener<AddPropertyImageBloc, AddPropertyImageState>(
            listener: (context, state) {
              if (state is AddPropertyImagePicked ||
                  state is AddPropertyImageError ||
                  state is AddPropertyImageInitial ||
                  state is AddPropertyImageSuccess) {
                _isPickingImage = false;
              }

              if (state is AddPropertyImageSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Fotos subidas correctamente'),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (state is AddPropertyImageError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _brokenImagePlaceholder(double size, ColorScheme cs) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.broken_image, color: cs.onSurfaceVariant),
    );
  }

  Widget _buildAddButton({
    required double size,
    required BuildContext context,
    required bool isLoading,
    required ColorScheme cs,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: isLoading
          ? null
          : () async {
              if (_isPickingImage) return;
              final bloc = context.read<AddPropertyImageBloc>();
              final source = await AttachmentSourcePicker.show(
                context,
                allowFiles: false,
                title: 'Adjuntar Evidencia Fotográfica',
              );
              if (!mounted || source == null) return;
              setState(() => _isPickingImage = true);
              if (source == AttachmentSource.camera) {
                bloc.add(
                  PickImageFromCameraEvent(
                    connectionId: widget.connectionId,
                    description: widget.description,
                  ),
                );
              } else {
                bloc.add(
                  PickImagesEvent(
                    widget.connectionId,
                    widget.description,
                    source: ImageSource.gallery,
                  ),
                );
              }
            },
      child: Opacity(
        opacity: isLoading ? 0.5 : 1.0,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: cs.surfaceContainerHighest,
            border: Border.all(
              color: isLoading
                  ? cs.outline.withValues(alpha: 0.2)
                  : cs.primary.withValues(alpha: 0.45),
              width: 2,
            ),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                    ),
                  )
                : Icon(
                    Icons.add_a_photo_rounded,
                    size: size * 0.48,
                    color: cs.primary,
                  ),
          ),
        ),
      ),
    );
  }
}
*/
