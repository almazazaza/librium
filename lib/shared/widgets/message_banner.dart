import 'package:flutter/material.dart';

enum BannerType { success, error }

class MessageBanner extends StatelessWidget {
  final String text;
  final BannerType type;

  const MessageBanner({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final color = type == BannerType.success
      ? Colors.green.shade500
      : Colors.red.shade400;
    final icon = type == BannerType.success
      ? Icons.check_circle
      : Icons.error;

    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15
              ),
            ),
          ),
        ],
      ),
    );
  }
}