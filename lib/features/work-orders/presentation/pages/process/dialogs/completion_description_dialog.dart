import 'dart:io';

import 'package:clean_architecture/components/widgets/images_section.dart';
import 'package:flutter/material.dart';

class CompletionDescriptionDialogResult {
  final String description;
  final List<String> evidencePaths;

  const CompletionDescriptionDialogResult({
    required this.description,
    required this.evidencePaths,
  });
}

class CompletionDescriptionDialog extends StatefulWidget {
  const CompletionDescriptionDialog({super.key});

  @override
  State<CompletionDescriptionDialog> createState() =>
      _CompletionDescriptionDialogState();
}

class _CompletionDescriptionDialogState
    extends State<CompletionDescriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final List<File> _evidenceImages = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(
        CompletionDescriptionDialogResult(
          description: _controller.text.trim(),
          evidencePaths: List.unmodifiable(
            _evidenceImages.map((image) => image.path),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final maxDialogHeight = (media.size.height - media.viewInsets.bottom - 32)
        .clamp(1.0, media.size.height)
        .toDouble();

    // Colores suaves y modernos
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 460, maxHeight: maxDialogHeight),
        child: Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── Header atractivo ───
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary.withValues(alpha: 0.12),
                      primary.withValues(alpha: 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.task_alt_rounded,
                        color: primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Finalizar trabajo',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Describe lo realizado y adjunta evidencias',
                            style: TextStyle(
                              fontSize: 13,
                              color: onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: onSurface.withValues(alpha: 0.5),
                      ),
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),
              ),

              // ─── Contenido ───
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 18,
                              color: primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Descripción del trabajo',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: onSurface.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _controller,
                          minLines: 4,
                          maxLines: 6,
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                          decoration: InputDecoration(
                            hintText:
                                'Describe las tareas realizadas, materiales usados y el resultado final...',
                            hintStyle: TextStyle(
                              color: onSurface.withValues(alpha: 0.4),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.45),
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: theme.dividerColor.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: primary,
                                width: 1.8,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: theme.colorScheme.error,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: theme.colorScheme.error,
                                width: 1.8,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              (value?.trim().isNotEmpty ?? false)
                              ? null
                              : 'Ingresa la descripción de finalización.',
                          onFieldSubmitted: (_) => _submit(),
                        ),

                        const SizedBox(height: 24),

                        // Sección de evidencias
                        Row(
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 18,
                              color: primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Evidencias del trabajo',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: onSurface.withValues(alpha: 0.85),
                              ),
                            ),
                            const Spacer(),
                            if (_evidenceImages.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_evidenceImages.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fotos, documentos o archivos que respalden el trabajo',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Contenedor con borde suave para las imágenes
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.35),
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: ImagesSection(
                            attachedImages: _evidenceImages,
                            mode: 'completion',
                            allowFiles: true,
                            allowGallery: true,
                            onImageAdded: (image) =>
                                setState(() => _evidenceImages.add(image)),
                            onImageRemoved: (index) =>
                                setState(() => _evidenceImages.removeAt(index)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Footer con botones ───
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.25,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: const Text(
                          'Continuar',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
