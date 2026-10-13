import 'package:flutter/material.dart';

class ConnectionInfoCard extends StatelessWidget {
  final dynamic connection; // Changed to dynamic stub

  const ConnectionInfoCard({super.key, required this.connection});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text('ConnectionInfoCard Stub'),
    );
  }
}
