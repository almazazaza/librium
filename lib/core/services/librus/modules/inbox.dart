part of '../api.dart';

extension Inbox on Librus {
  Future<List<Map<String, dynamic>>> getInbox({
    final int folderId = 5,
    final bool loadAllMessages = false,
  }) async {
    try {
      int length = 0;
      final List<Map<String, dynamic>> data = [];

      final response = await _dio.get("$baseServerUrl/wiadomosci/$folderId");
      final document = html_parser.parse(response.data);
      
      final span = document.querySelector("div.pagination span");
      if (span != null) {
        final spanText = span.text.trim();
        final match = RegExp(r"(\d+)\s*$").firstMatch(spanText);

        if (loadAllMessages) {
          length = int.tryParse(match!.group(1)!) ?? 0;
        }
        else {
          length = 1;
        }
      }

      if (length == 0) {
        final rows = document.querySelectorAll("table.decorated.stretch tbody tr");

        for (final row in rows) {
          Map<String, dynamic>? message = _parseInboxRow(row);
          
          if (message == null) continue;
          data.add(message);
        }
        return data;
      }

      for (int i = 0; i < length; i++) {
        final formData = FormData.fromMap({
          "numer_strony10$folderId": i,
          "poprzednia": folderId,
          "idPojemnika": 100 + folderId
        });

        final response = await _dio.post(
          "$baseServerUrl/wiadomosci/$folderId",
          data: formData
        );
        final document = html_parser.parse(response.data);

        final rows = document.querySelectorAll("table.decorated.stretch tbody tr");

        for (final row in rows) {
          Map<String, dynamic>? message = _parseInboxRow(row);
          
          if (message == null) continue;
          data.add(message);
        }
      }
      return data;
    }
    catch (e) {
      throw Exception("$e");
    }
    
  }
  Future<Map<String, dynamic>> getMessage(final int? folderId, final int? messageId) async {
    final Map<String, dynamic> data = {
      "meta": null,
      "plainText": "",
      "links": <String>[]
    };

    if (folderId == null && messageId == null) return data;

    try {
      final response = await _dio.get("$baseServerUrl/wiadomosci/1/$folderId/$messageId/f0");
      
      final document = html_parser.parse(response.data);
      final messageElement = document.querySelector("div.container-message-content");

      if (messageElement == null) return data;

      replaceBreaksAndLinks(messageElement);

      final plainText = messageElement.text;
      final links = extractLinks(plainText);
      final files = await getFiles(response);

      final metadataBefore = extractMetadataTable(messageElement.previousElementSibling);
      final metadataAfter = extractMetadataTable(messageElement.nextElementSibling);

      final sender = formatUser(metadataBefore["nadawca"] ?? "");
      final topic = metadataBefore["temat"] ?? "";
      final sentAt = formatMessageDate(metadataBefore["wysłano"] ?? "");
      final readAt = formatMessageDate(metadataAfter["przeczytano"] ?? "");

      data["meta"] = {};
      data["plainText"] = plainText;
      data["links"] = links;
      if (files.isNotEmpty) data["files"] = files;

      if (sender != "") {
        data["meta"]["sender"] = sender;
        data["meta"]["readAt"] = readAt;
      }
      else {
        final receiverData = extractReceiver(messageElement.nextElementSibling);

        data["meta"]["receiver"] = formatUser(receiverData["receiver"] ?? "");
        data["meta"]["isRead"] = receiverData["isRead"];
      }

      data["meta"]["topic"] = topic;
      data["meta"]["sentAt"] = sentAt;

      return data;
    }
    catch (e) {
      throw Exception("$e");
    }
  }
  Future<bool> sendMessage(
    int? userId,
    String topic,
    String content
  ) async {
    if (userId == null) {
      return false;
    }

    try {
      await _dio.get("$baseServerUrl/wiadomosci/2/5");

      final formData = FormData.fromMap({
        "DoKogo": userId.toString(),
        "temat": topic,
        "tresc": content,
        "poprzednia": 6,
        "wyslij": "Wyślij"
      });

      await _dio.post(
        "$baseServerUrl/wiadomosci/5",
        data: formData,
        options: Options(
          followRedirects: true,
          validateStatus: (_) => true,
        ),
      );

      final finalResponse = await _dio.get("$baseServerUrl/wiadomosci/6");

      final document = html_parser.parse(finalResponse.data);

      final container = document.querySelector("div.container.green");
      if (container == null) return false;

      final p = container.querySelector("p");
      if (p == null) return false;

      return p.text.contains("Wysłano wiadomość");
    }
    catch (e) {
      return false;
    }
  }
  Future<List<Map<String, dynamic>>> getReceiverTypes() async {
    final response = await _dio.get("$baseServerUrl/wiadomosci/2/5");

    final document = html_parser.parse(response.data);
    final rows = document.querySelectorAll("table.message-recipients tbody tr");

    List<Map<String, dynamic>> data = [];

    for (final row in rows) {
      final cells = row.querySelectorAll("td");

      final radio = cells[0].querySelector("input[type='radio']");
      final onclick = radio?.attributes["onclick"] ?? "";
      final regex = RegExp(r"selectRecipients\s*\((.*)\)");
      final match = regex.firstMatch(onclick);

      if (match == null) continue;

      final argsString = match.group(1)!;

      final rawArgs = argsString.split(',').map((e) => e.trim()).toList();

      final type = rawArgs[0].replaceAll('"', '').replaceAll("'", "");
      final isVirtualClass = rawArgs[1] == 'true';
      final groupId = int.tryParse(rawArgs[2]);

      int? classId;

      if (rawArgs.length > 3) {
        classId = int.tryParse(rawArgs[3]);
      }

      final label = cells[1].querySelector("label");
      final typeName = label?.text.trim();

      data.add({
        "typeName": typeName,
        "type": type,
        "groupId": groupId,
        "isVirtualClass": isVirtualClass,
        "classId": classId
      });
    }

    return data;
  }
  Future<List<Map<String, dynamic>>> getReceivers(
    final String type,
    final int groupId,
    final bool isVirtualClass,
    {final int? classId}
  ) async {
    final Map<String, dynamic> map = {};

    map["typAdresata"] = type;
    map["poprzednia"] = 5;
    map["tabZaznaczonych"] = "";
    map["czyWirtualneKlasy"] = isVirtualClass;
    map["idGrupy"] = groupId;

    if (classId != null) {
      map["klasa_rada_rodzicow"] = classId;
      map["klasa_opiekunowie"] = classId;
      map["klasa_rodzice"] = classId;
    }

    FormData formData = FormData.fromMap(map);

    final response = await _dio.post(
      "$baseServerUrl/getRecipients",
      data: formData
    );

    final document = html_parser.parse(response.data);
    final rows = document.querySelectorAll("table tbody tr");

    List<Map<String, dynamic>> data = [];

    for (final row in rows) {
      final cells = row.querySelectorAll("td");

      final checkbox = cells[0].querySelector("input[type='checkbox']");
      final userId = int.tryParse(checkbox?.attributes["value"] ?? "");

      final label = cells[1].querySelector("label");
      final fullName = formatUser(label?.text.trim() ?? "");

      data.add({
        "id": userId,
        "fullName": fullName
      });
    }

    return data;
  }
  Future<int?> getReceiverIdInReply(final int? folderId, final int? messageId) async {
    if (folderId == null || messageId == null) return null;

    try {
      final response = await _dio.get("$baseServerUrl/wiadomosci/3/$folderId/$messageId");

      final document = html_parser.parse(response.data);
      final input = document.querySelector("input[name='DoKogo']");

      if (input == null) return null;

      final int? receiverId = int.tryParse(input.attributes["value"] ?? "");

      return receiverId;
    }
    catch (e) {
      return null;
    }
  }
  Future<List<Map<String, dynamic>>> getFiles(final Response response) async {
    List<Map<String, dynamic>> data = [];

    final document = html_parser.parse(response.data);
    final messageContent = document.querySelector("div.container-message-content");

    if (messageContent == null) return data;

    final filesTable = messageContent.nextElementSibling;

    if (filesTable == null) return data;

    final rows = filesTable.querySelectorAll("tr");

    if (rows.isEmpty) return data;
    rows.removeAt(0);

    for (final row in rows) {
      final cells = row.querySelectorAll("td");

      if (cells.length < 2) continue;

      final fileName = cells[0].text.replaceAll(RegExp(r"\s+"), " ").trim();

      final button = cells[1].querySelector("a img");
      final onclick = button?.attributes["onclick"] ?? "";
      final regex = RegExp(
        r'otworz_w_nowym_oknie\s*\(\s*["]([^"]+)["]',
        multiLine: true
      );
      final match = regex.firstMatch(onclick);

      if (match == null) continue;

      final fileLink = match.group(1)?.replaceAll(r'\/', '/');

      final response = await _dio.get(
        "$baseServerUrl$fileLink",
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: true,
          responseType: ResponseType.stream
        )
      );

      final redirectedLink = response.realUri.toString();

      data.add({
        "fileName": fileName,
        "link": redirectedLink
      });
    }
    return data;
  }
  Map<String, dynamic>? _parseInboxRow(final row) {
    final cells = row.querySelectorAll("td");

    if (cells.length < 6) return null;

    final filesIcon = cells[1].querySelector("img.tooltip.existing-msg-files-icon");
    final sender = formatUser(cells[2].querySelector("a")?.text.trim() ?? "");
    final topic = cells[3].querySelector("a")?.text.trim();

    if (topic == null) return null;
          
    int? folderId;
    int? messageId;

    final href = cells[2].querySelector("a")?.attributes["href"];

    if (href != null) {
      final match = RegExp(r"^/wiadomosci/1/(\d+)/(\d+)/f0/?$").firstMatch(href);

      if (match != null) {
        folderId = int.tryParse(match.group(1)!);
        messageId = int.tryParse(match.group(2)!);
      }
    }

    final formattedDate = formatMessageDate(cells[4].text.trim());

    return {
      "sender": sender,
      "topic": topic,
      "date": formattedDate,
      "folderId": folderId,
      "messageId": messageId,
      "containsFiles": filesIcon != null
    };
  }
}