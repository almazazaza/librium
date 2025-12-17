import 'package:flutter/material.dart';

import 'package:librium/core/services/settings/settings.dart';
import 'package:librium/core/constants/app_theme.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  Widget _buildSettingsSwitch({
    required String title,
    String descriptionOn = "",
    String descriptionOff = "",
    required String key,
    required ThemeData theme,
    required SettingsProvider settings
  }) {
    bool value = settings.getBool(key);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 2),
              Text(
                value ? descriptionOn : descriptionOff,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.hintColor
                )
              )
            ]
          )
        ),
        Switch(
          value: value,
          onChanged: (val) async {
            settings.setBool(key, val);
          }
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;
    final settings = context.watch<SettingsProvider>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Ustawienia",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis
                )
              ]
            )
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15
              ),
              physics: BouncingScrollPhysics(),
              children: [
                _buildSettingsSwitch(
                  title: "Pobierać wszystkie wiadomości",
                  descriptionOn: "Pobieranie wszystkich wiadomości (może potrwać dłużej)",
                  descriptionOff: "Pobieranie ostatnich 50 wiadomości (zalecane)",
                  key: "loadAllMessages",
                  theme: theme,
                  settings: settings
                ),
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: theme.hintColor,
                ),
                const SizedBox(height: 10),
                _buildSettingsSwitch(
                  title: "Zablokuj przewijanie paska kart",
                  descriptionOn: "Przewijanie paska kart jest zablokowane",
                  descriptionOff: "Przewijanie paska kart jest dostępne",
                  key: "disableTabBarScroll",
                  theme: theme,
                  settings: settings
                )
              ]
            )
          )
        )
      ]
    );
  }
}