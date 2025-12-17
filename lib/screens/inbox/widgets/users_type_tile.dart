import 'package:flutter/material.dart';

class UsersTypeTile extends StatelessWidget {
  final bool isExpanded;
  final Map<String, dynamic> type;
  final VoidCallback onTap;
  final ThemeData theme;

  const UsersTypeTile({
    super.key,
    required this.isExpanded,
    required this.type,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  type["typeName"] ?? "Nieznany typ",
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16
                  )
                )
              ),
              const SizedBox(width: 12),
              Icon(
                isExpanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
                size: 25
              )
            ]
          )
        )
      )
    );
  }
}
