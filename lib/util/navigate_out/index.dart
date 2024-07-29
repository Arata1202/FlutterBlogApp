import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationHelper {
  static Future<NavigationDecision> handleNavigationRequest(
    NavigationRequest request,
    String currentUrl,
    Future<void> Function()? onArticleNavigate,
  ) async {
    if (!request.url.contains('web-view-blog-app.netlify.app')) {
      try {
        if (await canLaunch(request.url)) {
          await launch(request.url, forceSafariVC: false);
        } else {
          print('Could not launch ${request.url}');
        }
      } catch (e) {
        print('Error launching ${request.url}: $e');
      }
      return NavigationDecision.prevent;
    }

    if (request.url.contains('web-view-blog-app.netlify.app/article') &&
        request.url != currentUrl) {
      if (onArticleNavigate != null) {
        try {
          await onArticleNavigate();
        } catch (e) {
          print('Error in onArticleNavigate: $e');
        }
      }
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }
}
