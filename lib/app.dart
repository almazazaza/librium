import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:librium/core/routes/app_routes.dart';
import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/core/services/librus/api.dart';
import 'package:librium/core/services/github/pages.dart';
import 'package:librium/shared/utils/url_launcher.dart';

class Librium extends StatelessWidget {
  const Librium({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);

    return MaterialApp(
      title: "Librium",
      home: SplashScreen(),
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      theme: theme.themeData,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkAppUpdates(); 
    await _restoreSession();
  }

  Future<void> _restoreSession() async {
    final librus = Provider.of<Librus>(context, listen: false);
    final restored = await librus.restoreSession();

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      restored ? AppRoutes.home : AppRoutes.auth,
    );
  }

  Future<void> _checkAppUpdates() async {
    final data = await GitHub().getVersionJson();

    if (!GitHub().checkUpdateAvailability(data) || !mounted) return;

    final version = GitHub().getLatestUpdateVersion(data);
    final versionInfo = GitHub().getVersionInfo(data, version);
    
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          "Dostępna nowa aktualizacja! (${versionInfo["versionName"]})"
        ),
        content: Text(
          versionInfo["changelog"] ?? "Brak opisu aktualizacji"
        ),
        actions: [
          versionInfo["forceUpdate"] ?? false
          ? TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Wyjdź"))
          : TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Później")
          ),
          TextButton(
            onPressed: () {
              launchURL(versionInfo["releaseLink"] ?? "https://github.com/almazazaza/librium");
              SystemNavigator.pop();
            },
            child: const Text("Aktualizuj")
          )
        ]
      )
    );

    if (!mounted) return;

    if (!GitHub().isCurrentVersionAvailable(data)) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Nie wspierana wersja aplikacji"),
          content: Text("Najprawdopodobniej korzystasz z nie wspieranej wersji aplikacji.\nPobierz ostatnią aktualizację i spróbuj ponownie!"),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text("Wyjdź")
            ),
            TextButton(
              onPressed: () {
                launchURL(versionInfo["releaseLink"] ?? "https://github.com/almazazaza/librium");
                SystemNavigator.pop();
              },
              child: const Text("Aktualizuj")
            )
          ]
        )
      );

      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10)
          ),
          child: SizedBox(
            width: 75,
            height: 75,
            child: SvgPicture.asset(
              "assets/icons/app_logo.svg",
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurface,
                BlendMode.srcIn
              )
            )
          )
        )
      )
    );
  }
}