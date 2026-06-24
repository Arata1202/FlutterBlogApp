import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../launch_url/index.dart';

Future<NavigationDecision> preventAndLaunchExternalUrl(String url) async {
  try {
    if (!await launchExternalUrl(url)) {
      throw StateError('Could not launch $url');
    }
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'FlutterBlogApp',
        context: ErrorDescription('External WebView URL launch failed'),
      ),
    );
  }

  return NavigationDecision.prevent;
}
