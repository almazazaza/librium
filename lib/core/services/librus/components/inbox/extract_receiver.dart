import 'package:html/dom.dart' as dom;

Map<String, dynamic> extractReceiver(dom.Element? table) {
  final metadata = <String, dynamic>{};
  if (table == null || table.localName != "table") return metadata;
  
  final row = table.querySelectorAll("tr");

  if (row.length < 2) return metadata;

  final cells = row[1].querySelectorAll("td");

  if (cells.length < 2) return metadata;

  final receiver = cells[0].text.trim();
  final isRead = cells[1].text.trim() != "NIE";

  metadata["receiver"] = receiver;
  metadata["isRead"] = isRead;

  return metadata;
}