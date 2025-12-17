List<String> extractLinks(String text) {
  final regex = RegExp(r"https?://[^\s]+");
  return regex.allMatches(text).map((m) => m.group(0)!).toList();
}