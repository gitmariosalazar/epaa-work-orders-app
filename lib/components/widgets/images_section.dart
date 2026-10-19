import 'dart:io';

import 'package:clean_architecture/components/widgets/attachment_source_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture/utils/responsive_utils.dart';
import 'package:image_picker/image_picker.dart';

class ImagesSection extends StatelessWidget {
  final List<File> attachedImages;
  final String mode;
  final Function(File) onImageAdded;
  final Function(int) onImageRemoved;
  final bool allowFiles;

  const ImagesSection({
    super.key,
    required this.attachedImages,
    required this.mode,
    required this.onImageAdded,
    required this.onImageRemoved,
    this.allowFiles = false,
  });

  Future<void> _pickFromSource(
    BuildContext context,
    AttachmentSource source,
  ) async {
    if (source == AttachmentSource.file) {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (!context.mounted || result == null) return;
      for (final path in result.paths.whereType<String>()) {
        onImageAdded(File(path));
      }
      return;
    }

    final picker = ImagePicker();
    if (source == AttachmentSource.camera) {
      final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (context.mounted && pickedImage != null) {
        onImageAdded(File(pickedImage.path));
      }
      return;
    }

    final pickedImages = await picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (!context.mounted) return;
    for (final image in pickedImages) {
      onImageAdded(File(image.path));
    }
  }

  Future<void> _showImageSourcePicker(BuildContext context) async {
    final source = await AttachmentSourcePicker.show(
      context,
      allowFiles: allowFiles,
    );
    if (source != null && context.mounted) {
      await _pickFromSource(context, source);
    }
  }

  Widget _buildAddImageButton(
    BuildContext context,
    ColorScheme colors,
    double size,
  ) {
    return GestureDetector(
      onTap: () => _showImageSourcePicker(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: colors.primaryContainer.withValues(alpha: 0.15),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.45),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.add_a_photo_rounded,
          size: size * 0.48,
          color: colors.primary.withValues(alpha: 0.82),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final double imageSize = ResponsiveUtils.isTablet(context) ? 90.0 : 55.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mode == 'completion'
              ? 'Evidencias de finalización'
              : 'Evidencias adjuntas',
          style: ResponsiveUtils.bodyLarge(
            context,
          ).copyWith(fontWeight: FontWeight.w600, color: colors.onSurface),
        ),
        ResponsiveUtils.vSpace(context, 0.01),
        SizedBox(
          height: imageSize,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: attachedImages.length + 1,
            separatorBuilder: (_, _) =>
                SizedBox(width: ResponsiveUtils.smallSpacing(context)),
            itemBuilder: (context, index) {
              if (index == attachedImages.length) {
                return _buildAddImageButton(context, colors, imageSize);
              } else {
                final file = attachedImages[index];
                final extension = file.path.split('.').last.toLowerCase();
                final isImage = {
                  'jpg',
                  'jpeg',
                  'png',
                  'gif',
                  'webp',
                  'bmp',
                }.contains(extension);
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: isImage
                          ? Image.file(
                              file,
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _filePreview(colors, imageSize),
                            )
                          : _filePreview(colors, imageSize),
                    ),
                    Positioned(
                      left: 2,
                      right: 2,
                      bottom: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        color: Colors.black54,
                        child: Text(
                          file.path.split(Platform.pathSeparator).last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () => onImageRemoved(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _filePreview(ColorScheme colors, double size) => Container(
    width: size,
    height: size,
    color: colors.surfaceContainerHighest,
    child: Icon(
      Icons.insert_drive_file_outlined,
      color: colors.primary,
      size: size * 0.48,
    ),
  );
}
