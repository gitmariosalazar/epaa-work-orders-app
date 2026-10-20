import 'package:clean_architecture/components/photo/photo_grid.dart';
import 'package:clean_architecture/components/widgets/attachment_source_picker.dart';
import 'package:clean_architecture/shared/files/domain/entities/file_category.dart';
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
    return [
      'EN_PROCESO',
      'EN_PROCESO_INSPECCION',
      'EN_PROCESO_INSTALACION',
      'EJECUTADA',
      'PENDIENTE',
    ].contains(status);
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
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

  Future<void> _showAddAttachmentBottomSheet(BuildContext context) async {
    final source = await AttachmentSourcePicker.show(context);
    if (!context.mounted || source == null) return;

    switch (source) {
      case AttachmentSource.camera:
        await _pickFromCamera(context);
      case AttachmentSource.gallery:
        await _pickFromGallery(context);
      case AttachmentSource.file:
        await _pickDocument(context);
    }
  }

  static const _stageLabels = {
    'REPORTE_INICIAL': 'Reporte inicial',
    'EN_PROCESO': 'En proceso',
    'TRABAJO_TERMINADO': 'Trabajo terminado',
    'CONFORMIDAD_CLIENTE': 'Conformidad del cliente',
    'INSPECCION_SEGURIDAD': 'Inspección previa / Seguridad',
  };

  String _stageLabel(String code) => _stageLabels[code] ?? code;

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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // 1. Agrupar por evidenceStep
    final Map<String, List<EvidenceAttachmentEntity>> grouped = {};

    debugPrint('Evidencias adjuntas: $order');

    for (final a in order.adjuntos) {
      final key = a.evidenceStep?.trim().isNotEmpty == true
          ? a.evidenceStep!
          : 'Sin categoría'; // o el nombre que prefieras para los null/vacíos

      grouped.putIfAbsent(key, () => []).add(a);
    }

    // Opcional: ordenar las secciones si tienes un orden definido
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        // Ejemplo de orden personalizado (ajusta según tus steps reales)
        const order = [
          'REPORTE_INICIAL',
          'INSPECCION_SEGURIDAD',
          'EN_PROCESO',
          'TRABAJO_TERMINADO',
          'CONFORMIDAD_CLIENTE',
        ];
        final ia = order.indexOf(a);
        final ib = order.indexOf(b);
        if (ia == -1 && ib == -1) return a.compareTo(b);
        if (ia == -1) return 1;
        if (ib == -1) return -1;
        return ia.compareTo(ib);
      });

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.attachment_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Evidencias y Archivos Adjuntos',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (_isEditable)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _showAddAttachmentBottomSheet(context),
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      size: 14,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Adjuntar',
                      style: TextStyle(fontSize: 11.5, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const Divider(height: 16),

            // Contenido vacío
            if (order.adjuntos.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      color: isDark ? cs.outlineVariant : Colors.grey.shade400,
                      size: 36,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No hay archivos o fotos de evidencia adjuntos.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? cs.onSurfaceVariant : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Secciones por evidenceStep
              ...sortedKeys.map((step) {
                final items = grouped[step]!;
                final images = items.where((a) => a.isImage).toList();
                final attachments = items.where((a) => !a.isImage).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _stageLabel(step),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${items.length})',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? cs.onSurfaceVariant : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Galería de imágenes de esta sección
                    if (images.isNotEmpty) ...[
                      PhotoGallery(
                        category: FileCategory.workOrders,
                        height: 200,
                        imagePaths: images.map((a) => a.filePath).toList(),
                      ),
                      if (attachments.isNotEmpty) const SizedBox(height: 8),
                    ],

                    // Lista de archivos no-imagen
                    if (attachments.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attachments.length,
                        separatorBuilder: (_, _) => const Divider(height: 10),
                        itemBuilder: (context, index) {
                          final att = attachments[index];
                          final isImg =
                              att.nombreArchivo.toLowerCase().endsWith(
                                '.jpg',
                              ) ||
                              att.nombreArchivo.toLowerCase().endsWith(
                                '.jpeg',
                              ) ||
                              att.nombreArchivo.toLowerCase().endsWith(
                                '.png',
                              ) ||
                              att.nombreArchivo.toLowerCase().endsWith('.webp');

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isImg
                                    ? (isDark
                                        ? cs.primary.withValues(alpha: 0.18)
                                        : Colors.blue.shade50)
                                    : (isDark
                                        ? Colors.amber.withValues(alpha: 0.18)
                                        : Colors.amber.shade50),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isImg
                                    ? Icons.image_outlined
                                    : Icons.description_outlined,
                                color: isImg
                                    ? (isDark
                                        ? cs.primary
                                        : Colors.blue.shade700)
                                    : (isDark
                                        ? Colors.amber.shade400
                                        : Colors.amber.shade800),
                                size: 20,
                              ),
                            ),
                            title: Text(
                              att.nombreArchivo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              att.fechaCarga,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? cs.onSurfaceVariant : Colors.grey.shade600,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.open_in_new_rounded,
                                size: 18,
                                color: isDark ? cs.onSurfaceVariant : Colors.grey.shade700,
                              ),
                              tooltip: 'Abrir archivo',
                              onPressed: () => _openFileUrl(
                                context,
                                att.url,
                              ),
                            ),
                          );
                        },
                      ),

                    // Separador entre secciones
                    if (step != sortedKeys.last)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}
