import 'package:html/dom.dart' as dom;

void replaceBreaksAndLinks(dom.Element messageElement) {
  for (final br in messageElement.querySelectorAll("br")) {
    br.replaceWith(dom.Text(""));
  }

  for (final a in messageElement.querySelectorAll("a")) {
    final href = a.attributes["href"] ?? "";
    a.replaceWith(dom.Text(href));
  }
}