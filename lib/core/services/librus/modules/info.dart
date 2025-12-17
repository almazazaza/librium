part of '../api.dart';

extension Info on Librus {
  Future<Map<String, dynamic>> getAccountInfo() async {
    try {
      final response = await _dio.get("$baseServerUrl/informacja");

      final document = html_parser.parse(response.data);
      final rows = document.querySelectorAll("table.decorated tbody tr");

      final Map<String, String> data = {};

      for (final row in rows) {
        final th = row.querySelector("th");
        final td = row.querySelector("td");

        if (th != null && td != null) {
          final key = th.text.trim();
          final value = td.text.trim().replaceAll(RegExp(r"\s+"), " ");
          data[key] = value;
        }
      }

      final Map<String, dynamic> result = {};

      final fullName = data["Imię i nazwisko ucznia"]?.split(" ");

      result["firstName"] = fullName?.first;
      result["surname"] = fullName?.sublist(1).join(" ");
      result["class"] = data["Klasa"];
      result["journalNumber"] = int.tryParse(data["Nr w dzienniku"] ?? "");
      result["teacher"] = data["Wychowawca"];
      result["school"] = data["Szkoła"];
      result["username"] = data["Imię i nazwisko użytkownika"];
      result["login"] = data["Login"];

      return result;
    }
    catch (e) {
      throw Exception("$e");
    }
  }
  Future<int?> getLuckyNumber() async {
    try {
      final response = await _dio.get("$baseServerUrl/uczen/index");

      final document = html_parser.parse(response.data);
      final span = document.querySelector("span.luckyNumber b");

      if (span != null) {
        final int? luckyNumber = int.tryParse(span.text.trim());

        return luckyNumber;
      }
      return null;
    }
    catch (e) {
      throw Exception("$e");
    }
  }
}