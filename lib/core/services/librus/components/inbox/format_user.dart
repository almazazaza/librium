String formatUser(String rawSender) {
  if (rawSender.isEmpty) return rawSender;

  final cleaned = rawSender
      .replaceAll(RegExp(r"\(.*?\)"), "")
      .replaceAll(RegExp(r"\[.*?\]"), "")
      .trim();

  final parts = cleaned.split(RegExp(r"\s+"));

  if (parts.length == 2) {
    return "${parts[1]} ${parts[0]}";
  }

  return cleaned;
}