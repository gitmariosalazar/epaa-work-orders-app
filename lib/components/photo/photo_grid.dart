import 'package:clean_architecture/shared/files/domain/entities/file_category.dart';
import 'package:clean_architecture/shared/files/domain/utils/file_path_utils.dart';
import 'package:clean_architecture/shared/files/presentation/widgets/secure_file_image.dart';
import 'package:flutter/material.dart';

/// Galería de fotos protegidas (mismo diseño que app-properties):
/// carrusel + indicadores + visor a pantalla completa.
///
/// La carga segura (token + caché) la delega en [SecureFileImage] (SRP/DIP).
class PhotoGallery extends StatefulWidget {
  final List<String> imagePaths;
  final String? title;

  /// Carpeta del backend donde viven las fotos.
  final FileCategory category;
  final double height;

  const PhotoGallery({
    super.key,
    required this.imagePaths,
    this.title,
    this.category = FileCategory.incidents,
    this.height = 380,
  });

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  late final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) return const _EmptyPhotos();

    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),
          ),
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemCount: widget.imagePaths.length,
            itemBuilder: (context, index) {
              final path = FilePathUtils.clean(widget.imagePaths[index]);
              return _PhotoItem(
                key: ValueKey(path),
                category: widget.category,
                path: path,
                onTap: () => _showFullScreen(context, index),
              );
            },
          ),
        ),
        if (widget.imagePaths.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imagePaths.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? cs.primary
                        : cs.outline.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showFullScreen(BuildContext context, int initialIndex) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => FullScreenPhotoGallery(
          imagePaths: widget.imagePaths,
          initialIndex: initialIndex,
          category: widget.category,
        ),
      ),
    );
  }
}

class _PhotoItem extends StatelessWidget {
  final FileCategory category;
  final String path;
  final VoidCallback? onTap;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const _PhotoItem({
    super.key,
    required this.category,
    required this.path,
    this.onTap,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    return SecureFileImage(
      category: category,
      filename: path,
      fit: fit,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }
}

class _EmptyPhotos extends StatelessWidget {
  const _EmptyPhotos();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 96, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay fotos disponibles',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

/// Visor a pantalla completa.
class FullScreenPhotoGallery extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final FileCategory category;

  const FullScreenPhotoGallery({
    super.key,
    required this.imagePaths,
    this.initialIndex = 0,
    this.category = FileCategory.incidents,
  });

  @override
  State<FullScreenPhotoGallery> createState() => _FullScreenPhotoGalleryState();
}

class _FullScreenPhotoGalleryState extends State<FullScreenPhotoGallery> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex);
  late int _currentIndex = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.imagePaths.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) => InteractiveViewer(
          child: Center(
            child: _PhotoItem(
              category: widget.category,
              path: FilePathUtils.clean(widget.imagePaths[index]),
              fit: BoxFit.contain,
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }
}
