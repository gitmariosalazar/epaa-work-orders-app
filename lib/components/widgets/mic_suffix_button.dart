import 'package:flutter/material.dart';

class MicSuffixButton extends StatelessWidget {
  final TextEditingController controller;

  const MicSuffixButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mic_none),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dictado no disponible')),
        );
      },
    );
  }
}
