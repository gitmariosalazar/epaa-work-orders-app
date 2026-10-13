import 'package:flutter/material.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> imagePaths;
  final String? title;

  const PhotoGallery({super.key, required this.imagePaths, this.title});

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text('No hay fotos', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title!, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                width: 120,
                color: Colors.grey.shade300,
                child: Center(
                  child: Icon(Icons.image, color: Colors.grey.shade500),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
