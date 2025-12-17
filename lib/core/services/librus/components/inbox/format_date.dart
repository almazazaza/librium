String formatMessageDate(String rawDate) {
  if (rawDate.isEmpty) return rawDate;

  final parts = rawDate.split(" ");
  if (parts.length != 2) return rawDate;

  final datePart = parts[0];
  final timePart = parts[1];

  final dateElements = datePart.split("-");
  if (dateElements.length != 3) return rawDate;

  final year = dateElements[0];
  final month = dateElements[1].padLeft(2, "0");
  final day = dateElements[2].padLeft(2, "0");

  return "$day.$month.$year $timePart";
}