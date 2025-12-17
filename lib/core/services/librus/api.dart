import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/parser.dart' as html_parser;

import 'package:librium/core/constants/api_constants.dart';

import 'components/inbox/format_date.dart';
import 'components/inbox/format_user.dart';
import 'components/inbox/replace_message.dart';
import 'components/inbox/extract_links.dart';
import 'components/inbox/extract_metadata.dart';
import 'components/inbox/extract_receiver.dart';

part 'modules/info.dart';
part 'modules/inbox.dart';

enum LoginStatus {
  success(null),
  redirect(null),
  forbidden("Odmowa dostępu: Nieprawidłowy login lub hasło"),
  serverError("Błąd serwera: Wewnętrzny błąd serwera"),
  networkError("Błąd sieciowy: Nie udało się połączyć z serwerem"),
  unknownError("Błąd: Nieznany błąd");
  
  final String? message;

  const LoginStatus(this.message);
}

class Librus {
  final Dio _dio;
  final PersistCookieJar _cookieJar;
  final FlutterSecureStorage _secureStorage;

  Librus._(this._dio, this._cookieJar, this._secureStorage);

  static Future<Librus> init() async {
    final dio = Dio(
      BaseOptions(
        headers: {
          "User-Agent":
              "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.73 Safari/537.36"
        },
        followRedirects: false,
        validateStatus: (_) => true
      )
    );

    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(storage: FileStorage("${dir.path}/.cookies"));
    dio.interceptors.add(CookieManager(cookieJar));

    final secureStorage = FlutterSecureStorage();

    return Librus._(dio, cookieJar, secureStorage);
  }

  Future<void> saveCookies(Response response) async {
    final setCookie = response.headers.map["set-cookie"];
    if (setCookie != null) {
      final cookies = setCookie.map((e) => Cookie.fromSetCookieValue(e)).toList();
      await _cookieJar.saveFromResponse(response.requestOptions.uri, cookies);
    }
  }
  
  Future<List<Cookie>> getCookies() async {
    return _cookieJar.loadForRequest(Uri.parse('$baseServerUrl/'));
  }
  
  Future<LoginStatus> authenticate(
    final String login,
    final String password, 
    {final bool saveData = true}) async {
    try {
      await _dio.get(
        "$baseApiUrl/OAuth/Authorization?client_id=46&response_type=code&scope=mydata",
      );

      final response = await _dio.post(
        "$baseApiUrl/OAuth/Authorization?client_id=46",
        data: {
          "action": "login",
          "login": login,
          "pass": password
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (_) => true
        )
      );

      await _dio.get(
        "$baseApiUrl/OAuth/Authorization/2FA?client_id=46",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: true
        )
      );

      switch (response.statusCode) {
        case 200: {
          if (response.data["status"] == "ok") {
            if (saveData) {
              await _secureStorage.write(key: "librus_login", value: login);
              await _secureStorage.write(key: "librus_password", value: password);
            }

            return LoginStatus.success;
          }
          else {return LoginStatus.unknownError;}
        }
        case 302: return LoginStatus.redirect;
        case 403: {
          if (response.data["status"] == "error" && response.data["errors"]?[0]?["code"] == 0) {
            return LoginStatus.forbidden;
          }
          else {return LoginStatus.unknownError;}
        }
        case 500: return LoginStatus.serverError;
        default: return LoginStatus.unknownError;
      }
    }
    catch (e) {
      return LoginStatus.networkError;
    }
  }
  Future<bool> isSessionActive() async {
    try {
      final response = await _dio.get("$baseServerUrl/uczen/index");

      final document = html_parser.parse(response.data);
      final userSection = document.querySelector("div#user-section");

      if (userSection == null) return false;

      return true;
    }
    catch (e) {
      return false;
    }
  }
  Future<bool> isTechnicalBreak() async {
    try {
      final response = await _dio.get("$baseApiUrl/OAuth/Authorization");

      final document = html_parser.parse(response.data);
      final span = document.querySelector("span.warning-title");

      if (span == null) return false;

      return span.text.contains("Przerwa techniczna");
    }
    catch (e) {
      return false;
    }
  }
  Future<bool> restoreSession() async {
    try {
      final cookies = await getCookies();

      if (cookies.isNotEmpty) {
        final sessionOk = await isSessionActive();

        if (sessionOk) {
          return true;
        }
      }

      final login = await _secureStorage.read(key: "librus_login");
      final password = await _secureStorage.read(key: "librus_password");

      if (login == null || password == null) {
        return false;
      }

      final status = await authenticate(login, password, saveData: false);

      return status == LoginStatus.success;
    }
    catch (e) {
      return false;
    }
  }
  Future<void> destroySession() async {
    try {
      await _secureStorage.delete(key: "librus_login");
      await _secureStorage.delete(key: "librus_password");

      await _dio.get("$baseServerUrl/wyloguj");

      await _cookieJar.deleteAll();
    }
    catch (e) {
      throw Exception("$e");
    }
  }
}