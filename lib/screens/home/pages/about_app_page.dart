import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/shared/widgets/linked_text.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "O programie",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ]
        )
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 30
              ),
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: SvgPicture.asset(
                            "assets/icons/app_logo.svg",
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.onSurface,
                              BlendMode.srcIn
                            )
                          )
                        )
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Librium",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.colorScheme.onSurface
                        ),
                        children: [
                          const TextSpan(
                            text: "To nieoficjalna, bezpłatna aplikacja z dostępnym kodem źródłowym, służąca do pobierania i wyświetlania danych z serwisu "
                          ),
                          const TextSpan(
                            text: "Librus Synergia",
                            style: TextStyle(fontWeight: FontWeight.w500)
                          ),
                          const TextSpan(
                            text: ". Aplikacja nie jest powiązana z firmą "
                          ),
                          const TextSpan(
                            text: "Librus sp. z o.o.",
                            style: TextStyle(fontWeight: FontWeight.w500)
                          ),
                          const TextSpan(
                            text: " i korzysta wyłącznie z oficjalnych zasobów systemu."
                          ),
                          const TextSpan(
                            text: "\n\nWszystkie dane użytkownika są przechowywane "
                          ),
                          const TextSpan(
                            text: "lokalnie na urządzeniu",
                            style: TextStyle(fontWeight: FontWeight.w500)
                          ),
                          const TextSpan(
                            text: " z wykorzystaniem pakietu "
                          ),
                          const TextSpan(
                            text: "flutter_secure_storage",
                            style: TextStyle(fontWeight: FontWeight.w500)
                          ),
                          const TextSpan(
                            text: " i przesyłane "
                          ),
                          const TextSpan(
                            text: "wyłącznie",
                            style: TextStyle(fontWeight: FontWeight.w500)
                          ),
                          const TextSpan(
                            text: " na serwery systemu Librus."
                          ),
                          const TextSpan(
                            text: " W niektórych sytuacjach aplikacja może łączyć się z publicznym serwerem na GitHubie, na przykład w celu sprawdzenia dostępności aktualizacji."
                          ),
                          const TextSpan(
                            text: "\n\nAplikacja została stworzona przez ucznia technikum jako projekt hobbystyczny."
                          ),
                          const TextSpan(
                            text: "\n\nEwentualne błędy działania aplikacji lub inne problemy można zgłosić na:"
                          ),
                          LinkedTextSpan(
                            text: "\nGitHub Librium Issues",
                            url: "https://github.com/almazazaza/librium/issues",
                            fontSize: 15
                          ),
                          EmailTextSpan(
                            text: "\nKontakt przez email",
                            email: "almazazaza.librium@gmail.com",
                            fontSize: 15
                          )
                        ]
                      )
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: theme.hintColor,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface
                        ),
                        children: [
                          const TextSpan(
                            text: "Kod źródłowy dostępny jest tutaj:\n"
                          ),
                          LinkedTextSpan(
                            text: "https://github.com/almazazaza/librium",
                            url: "https://github.com/almazazaza/librium",
                            fontSize: 16
                          )
                        ]
                      )
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: theme.hintColor,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.colorScheme.onSurface
                        ),
                        children: [
                          const TextSpan(
                            text: "Dokumenty dotyczące systemu Librus oraz aplikacji Librium:\n"
                          ),
                          const TextSpan(text: "• "),
                          LinkedTextSpan(
                            text: "Regulamin systemu Librus Synergia\n",
                            url: "https://synergia.librus.pl/regulamin",
                            fontSize: 15
                          ),
                          const TextSpan(text: "• "),
                          LinkedTextSpan(
                            text: "Politykę prywatności aplikacji Librium\n",
                            url: "https://github.com/almazazaza/librium/blob/main/docs/PRIVACY.md",
                            fontSize: 15
                          ),
                          const TextSpan(text: "• "),
                          LinkedTextSpan(
                            text: "Warunki licencyjne projektu Librium",
                            url: "https://github.com/almazazaza/librium/blob/main/docs/LICENSE.md",
                            fontSize: 15
                          )
                        ]
                      )
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: theme.hintColor,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Wersja aplikacji:",
                          style: TextStyle(
                            fontSize: 17,
                            color: theme.colorScheme.onSurface
                          )
                        ),
                        Text(
                          "0.1a",
                          style: TextStyle(
                            fontSize: 17,
                            color: theme.colorScheme.onSurface
                          )
                        ),
                      ]
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Aplikacja zbudowana jest w oparciu o framework Flutter",
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor
                      )
                    ),
                    const SizedBox(height: 10),
                  ]
                )
              )
            );
          }
        )
      )
    );
  }
}