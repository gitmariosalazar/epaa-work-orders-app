import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/features/work-orders/domain/entities/work_order_detail_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkOrderAttachmentsCard extends StatelessWidget {
  final WorkOrderDetailEntity order;
  final Function(List<String> filePaths) onUploadAttachments;

  const WorkOrderAttachmentsCard({
    super.key,
    required this.order,
    required this.onUploadAttachments,
  });

  bool get _isEditable {
    final status = order.estado.toUpperCase();
    return ['EN_PROCESO', 'EN_PROCESO_INSPECCION', 'EN_PROCESO_INSTALACION'].contains(status);
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (photo != null) {
      onUploadAttachments([photo.path]);
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 85);
    if (images.isNotEmpty) {
      onUploadAttachments(images.map((img) => img.path).toList());
    }
  }

  Future<void> _pickDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.paths.isNotEmpty) {
      final validPaths = result.paths.whereType<String>().toList();
      if (validPaths.isNotEmpty) {
        onUploadAttachments(validPaths);
      }
    }
  }

  void _showAddAttachmentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Adjuntar Evidencia de Campo',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
                ),
                title: const Text('Tomar Foto con Cámara', style: TextStyle(fontSize: 13.5)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromCamera(context);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.photo_library_outlined, color: Colors.purple),
                ),
                title: const Text('Seleccionar de Galería', style: TextStyle(fontSize: 13.5)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromGallery(context);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.file_present_outlined, color: Colors.orange),
                ),
                title: const Text('Seleccionar Archivo / PDF', style: TextStyle(fontSize: 13.5)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickDocument(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openFileUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se puede abrir el archivo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final attachments = order.adjuntos;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.attachment_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Evidencias y Archivos Adjuntos',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (_isEditable)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _showAddAttachmentBottomSheet(context),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 14, color: Colors.white),
                    label: const Text('Adjuntar', style: TextStyle(fontSize: 11.5, color: Colors.white)),
                  ),
              ],
            ),
            const Divider(height: 16),
            if (attachments.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(Icons.folder_open_outlined, color: Colors.grey.shade400, size: 36),
                    const SizedBox(height: 6),
                    Text(
                      'No hay archivos o fotos de evidencia adjuntos.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                separatorBuilder: (context, index) => const Divider(height: 10),
                itemBuilder: (context, index) {
                  final att = attachments[index];
                  final isImg = att.nombreArchivo.toLowerCase().endsWith('.jpg') ||
                      att.nombreArchivo.toLowerCase().endsWith('.jpeg') ||
                      att.nombreArchivo.toLowerCase().endsWith('.png') ||
                      att.nombreArchivo.toLowerCase().endsWith('.webp');

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isImg ? Colors.blue.shade50 : Colors.amber.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isImg ? Icons.image_outlined : Icons.description_outlined,
                        color: isImg ? Colors.blue.shade700 : Colors.amber.shade800,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      att.nombreArchivo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    subtitle: Text(
                      att.fechaSubida ?? 'Sin fecha',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      tooltip: 'Abrir archivo',
                      onPressed: () => _openFileUrl(context, att.urlArchivo),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
