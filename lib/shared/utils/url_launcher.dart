import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw "Nie udało się otworzyć link: $url";
  }
}
Future<void> launchEmail(String email) async {
  final emailUri = Uri(
    scheme: "mailto",
    path: email,
    query: "subject=Librium"
  );

  if (!await launchUrl(emailUri)) {
    throw "Nie udało się otworzyć email: $email";
  }
}