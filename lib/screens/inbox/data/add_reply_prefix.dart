String withReplyPrefix(String topic) {
  final trimmed = topic.trimLeft();
  return trimmed.toLowerCase().startsWith("re:")
      ? trimmed
      : "Re: $trimmed";
}

String buildQuotedMessage({
  required String sender,
  required String dateTime,
  required String content,
}) {
  return '''


----------
Użytkownik $sender $dateTime napisał(a):

$content''';
}