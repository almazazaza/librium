import 'package:flutter/material.dart';

import 'package:librium/screens/auth/pages/auth_page.dart';
import 'package:librium/screens/home/pages/home_page.dart';
import 'package:librium/screens/home/pages/settings_page.dart';
import 'package:librium/screens/inbox/pages/inbox_page.dart';
import 'package:librium/screens/home/pages/about_app_page.dart';

class AppRoutes {

  static const String auth = "auth";
  static const String home = "home";
  static const String about = "home/about";
  static const String settings = "home/settings";
  static const String inbox = "inbox";

  static Map<String, WidgetBuilder> routes = {
    auth: (context) => const AuthPage(),
    home: (context) => const HomePage(),
    about: (context) => const AboutAppPage(),
    settings: (context) => const SettingsPage(),
    inbox: (context) => const InboxPage()
  };
}