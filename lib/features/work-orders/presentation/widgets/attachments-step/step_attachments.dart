// features/work-orders/presentation/widgets/step_attachments.dart

import 'dart:io';

import 'package:clean_architecture/components/widgets/attachment_source_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clean_architecture/core/utils/responsive/responsive_utils.dart';
import 'package:clean_architecture/core/constants/app_colors.dart';

class StepAttachments extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) updateData;

  const StepAttachments({
    super.key,
    required this.formData,
    required this.updateData,
  });

  @override
  State<StepAttachments> createState() => _StepAttachmentsState();
}

class _StepAttachmentsState extends State<StepAttachments> {
  final TextEditingController _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _descController.text = widget.formData['attachmentDescription'] ?? '';
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        _addFiles(result.files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al seleccionar archivos: $e"),
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (!mounted || images.isEmpty) return;

      final files = <PlatformFile>[];
      for (final image in images) {
        final file = File(image.path);
        files.add(
          PlatformFile(
            name: image.name,
            path: image.path,
            size: await file.length(),
          ),
        );
      }
      _addFiles(files);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imágenes: $e'),
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
            ),
          ),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (photo != null && mounted) {
        final file = PlatformFile(
          name: photo.name,
          path: photo.path,
          size: await File(photo.path).length(),
          bytes: await photo.readAsBytes(),
        );
        _addFiles([file]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al tomar la foto: $e"),
            backgroundColor: Colors.red,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
            ),
          ),
        );
      }
    }
  }

  void _addFiles(List<PlatformFile> newFiles) {
    final currentFiles = List<PlatformFile>.from(
      widget.formData['attachedFiles'] ?? [],
    );
    currentFiles.addAll(newFiles);
    widget.updateData('attachedFiles', currentFiles);
  }

  void _removeFile(int index) {
    final currentFiles = List<PlatformFile>.from(
      widget.formData['attachedFiles'] ?? [],
    );
    currentFiles.removeAt(index);
    widget.updateData('attachedFiles', currentFiles);
  }

  Future<void> _showAddOptions() async {
    final source = await AttachmentSourcePicker.show(context);
    if (!mounted || source == null) return;

    switch (source) {
      case AttachmentSource.camera:
        await _takePhoto();
      case AttachmentSource.gallery:
        await _pickFromGallery();
      case AttachmentSource.file:
        await _pickFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    final files = List<PlatformFile>.from(
      widget.formData['attachedFiles'] ?? [],
    );

    return SingleChildScrollView(
      padding: context.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Adjuntos",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddOptions,
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text(
                    "Agregar",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: files.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "No hay archivos adjuntos",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Este paso es opcional",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: files.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final file = files[index];
                          final isImage = [
                            'jpg',
                            'jpeg',
                            'png',
                            'gif',
                            'webp',
                            'bmp',
                          ].contains(file.extension?.toLowerCase());
                          final isPdf = file.extension?.toLowerCase() == 'pdf';

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isPdf
                                    ? Icons.picture_as_pdf
                                    : isImage
                                    ? Icons.image_outlined
                                    : Icons.description,
                                color: Colors.indigo.shade700,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              file.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              "${(file.size / 1024).toStringAsFixed(1)} KB",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () => _removeFile(index),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _descController,
              maxLines: 4,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                labelText: "Descripción opcional de los adjuntos",
                labelStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.note_add_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onChanged: (value) =>
                  widget.updateData('attachmentDescription', value),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }
}
