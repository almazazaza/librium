import 'package:dio/dio.dart';

import 'package:librium/core/constants/api_constants.dart';
import 'package:librium/core/constants/app_version.dart';

class GitHub {
  final _dio = Dio(
    BaseOptions(
      headers: {
        "User-Agent":
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.73 Safari/537.36"
      },
      followRedirects: false,
      validateStatus: (_) => true
    )
  );

  Future<Map<String, dynamic>> getVersionJson() async {
    try {
      final response = await _dio.get(
        "$githubPagesUrl/version.json",
        options: Options(
          headers: {
            "Content-Type": "application/json"
          }
        )
      );

      return Map<String, dynamic>.from(response.data);
    }
    catch (e) {
      return {};
    }
  }
  
  bool checkUpdateAvailability(final Map<String, dynamic> data) {
    if (data["latestVersionCode"] != versionCode && data["latestVersionCode"] != null) return true;

    return false;
  }
  String getLatestUpdateVersion(final Map<String, dynamic> data) {
    return data["latestVersion"] ?? appVersion;
  }
  Map<String, dynamic> getVersionInfo(final Map<String, dynamic> data, final String version) {
    return data["versions"][version];
  }
  bool isCurrentVersionAvailable(final Map<String, dynamic> data) {
    if (data["versions"][appVersion]["available"]) return true;

    return false;
  }
}