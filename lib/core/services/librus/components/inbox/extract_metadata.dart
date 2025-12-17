import 'package:html/dom.dart' as dom;

Map<String, String> extractMetadataTable(dom.Element? table) {
  final metadata = <String, String>{};
  if (table == null || table.localName != "table") return metadata;

  for (final row in table.querySelectorAll("tr")) {
    final key = row.querySelector("b")?.text.trim().toLowerCase() ?? "";
    final cells = row.querySelectorAll("td");
    final value = cells.length > 1 ? cells[1].text.trim() : "";
    if (key.isNotEmpty) metadata[key] = value;
  }
  return metadata;
}