import 'package:flutter/material.dart';

enum AttachmentSource { camera, gallery, file }

abstract final class AttachmentSourcePicker {
  static Future<AttachmentSource?> show(
    BuildContext context, {
    bool allowFiles = true,
    String title = 'Adjuntar Evidencia de Campo',
  }) {
    return showModalBottomSheet<AttachmentSource>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    title,
                    style: Theme.of(sheetContext).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                _SourceOption(
                  title: 'Tomar Foto con Cámara',
                  icon: Icons.camera_alt_outlined,
                  color: Colors.blue,
                  onTap: () =>
                      Navigator.of(sheetContext).pop(AttachmentSource.camera),
                ),
                _SourceOption(
                  title: 'Seleccionar de Galería',
                  icon: Icons.photo_library_outlined,
                  color: Colors.purple,
                  onTap: () =>
                      Navigator.of(sheetContext).pop(AttachmentSource.gallery),
                ),
                if (allowFiles)
                  _SourceOption(
                    title: 'Seleccionar Archivo / PDF',
                    icon: Icons.file_present_outlined,
                    color: Colors.orange,
                    onTap: () =>
                        Navigator.of(sheetContext).pop(AttachmentSource.file),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SourceOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SourceOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13.5)),
      onTap: onTap,
    );
  }
}
