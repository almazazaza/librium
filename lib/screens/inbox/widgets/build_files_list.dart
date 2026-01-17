import 'package:flutter/material.dart';

import 'package:librium/shared/utils/url_launcher.dart';

Widget buildFilesList(
  List<Map<String, dynamic>> files,
  ThemeData theme,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      ...files.map((file) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.hintColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              launchURL(file["link"]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    Icons.file_download_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      file["fileName"],
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ]
              )
            )
          )
        );
      })
    ]
  );
}