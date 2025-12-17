import 'package:flutter/material.dart';

class FullscreenLoader extends StatelessWidget {
  final bool isLoading;
  const FullscreenLoader({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}