import 'package:flutter/material.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/shared/widgets/linked_text.dart';

class FooterInfo extends StatelessWidget {
  const FooterInfo({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 13,
          color: theme.hintColor
        ),
        children: [
          const TextSpan(
            text: "Logując się w swoim koncie "
          ),
          const TextSpan(
            text: "Librus",
            style: TextStyle(fontWeight: FontWeight.w500)
          ),
          const TextSpan(
            text: " za pomocą\naplikacji "
          ),
          const TextSpan(
            text: "Librium",
            style: TextStyle(fontWeight: FontWeight.w500)
          ),
          const TextSpan(
            text: ", użytkownik akceptuje:\n"
          ),
          const TextSpan(text: "• "),
          LinkedTextSpan(
            text: "Regulamin systemu Librus Synergia\n",
            url: "https://synergia.librus.pl/regulamin",
            fontSize: 13
          ),
          const TextSpan(text: "• "),
          LinkedTextSpan(
            text: "Politykę prywatności aplikacji Librium\n",
            url: "https://github.com/almazazaza/librium/blob/main/docs/PRIVACY.md",
            fontSize: 13
          ),
          const TextSpan(text: "• "),
          LinkedTextSpan(
            text: "Warunki licencyjne projektu Librium",
            url: "https://github.com/almazazaza/librium/blob/main/docs/LICENSE.md",
            fontSize: 13
          )
        ]
      )
    );
  }
}