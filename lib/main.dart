import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'app.dart';
import 'core/services/librus/api.dart';
import 'core/services/settings/settings.dart';
import 'core/constants/app_theme.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final Librus librus = await Librus.init();

  final SettingsProvider settingsProvider = SettingsProvider();
  await settingsProvider.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppTheme()
        ),
        Provider<Librus>.value(value: librus),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: settingsProvider
        )
      ],
      child: const Librium()
    )
  );
}