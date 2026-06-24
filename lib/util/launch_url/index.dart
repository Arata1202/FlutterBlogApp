import 'package:url_launcher/url_launcher.dart';

Future<bool> launchExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || !await canLaunchUrl(uri)) {
    return false;
  }

  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
