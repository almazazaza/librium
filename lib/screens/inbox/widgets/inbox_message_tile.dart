import 'package:flutter/material.dart';

class InboxMessageTile extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback onTap;
  final ThemeData theme;

  const InboxMessageTile({
    super.key,
    required this.message,
    required this.onTap,
    required this.theme
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message["sender"] ?? "Nieznany nadawca",
                style: const TextStyle(
                  fontSize: 16
                )
              ),
              Text(
                message["topic"] ?? "Bez tematu",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 4),
              Text(
                message["date"] ?? "",
                style: TextStyle(
                  fontSize: 14,
                  color: theme.hintColor
                )
              )
            ]
          )
        )
      )
    );
  }
}
