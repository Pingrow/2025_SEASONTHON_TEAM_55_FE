import 'package:url_launcher/url_launcher.dart';

Future<void> launchOutLink(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    throw Exception('$urlString을(를) 열 수 없습니다.');
  }
}
