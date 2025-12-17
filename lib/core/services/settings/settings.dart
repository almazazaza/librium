import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsProvider extends ChangeNotifier {
  late File _configFile;

  Map<String, dynamic> _settings = {
    "loadAllMessages": false,
    "disableTabBarScroll": false
  };

  Future<void> init() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();

      _configFile = File("${dir.path}/settings.json");

      if (!await _configFile.exists()) {
        await _configFile.writeAsString(jsonEncode(_settings));
      }

      final data = jsonDecode(await _configFile.readAsString());
      _settings = Map<String, dynamic>.from(data);
    }
    catch (e) {
      return;
    }
  }

  bool getBool(String key) => _settings[key] ?? false;

  Future<void> setBool(String key, bool value) async {
    _settings[key] = value;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await _configFile.writeAsString(jsonEncode(_settings));
  }
}