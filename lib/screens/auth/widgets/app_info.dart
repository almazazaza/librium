import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/shared/widgets/linked_text.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20)
          ),
          child: SizedBox(
            width: 125,
            height: 125,
            child: SvgPicture.asset(
              "assets/icons/app_logo.svg",
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurface,
                BlendMode.srcIn
              )
            )
          )
        ),
        const SizedBox(height: 5),
        const Text(
          "Librium",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 5),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 15,
              color: theme.colorScheme.onSurface
            ),
            children: [
              const TextSpan(
                text: "To nieoficjalna aplikacja z dostępnym kodem źródłowym",
                style: TextStyle(fontWeight: FontWeight.w500)
              ),
              const TextSpan(
                text: ",\nktóra pobiera i wyświetla dane z serwisu\n"
              ),
              const TextSpan(
                text: "Librus Synergia",
                style: TextStyle(fontWeight: FontWeight.w500)
              ),
              const TextSpan(
                text: ".\nAplikacja nie jest powiązana z firmą "
              ),
              const TextSpan(
                text: "Librus Sp. z o.o.",
                style: TextStyle(fontWeight: FontWeight.w500)
              ),
              const TextSpan(
                text: "\ni korzysta wyłącznie z oficjalnych zasobów.\n\n"
                      "Kod źródłowy dostępny jest tutaj:\n"
              ),
              LinkedTextSpan(
                text: "https://github.com/almazazaza/librium",
                url: "https://github.com/almazazaza/librium",
                fontSize: 15
              )
            ]
          )
        )
      ]
    );
  }
}