import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationHelper {
  static Future<NavigationDecision> handleNavigationRequest(
      NavigationRequest request,
      String currentUrl,
      Function onArticleNavigate) async {
    if (!request.url.contains('web-view-blog-app.netlify.app')) {
      if (await canLaunch(request.url)) {
        await launch(request.url, forceSafariVC: false);
        return NavigationDecision.prevent;
      }
    }
    if (request.url.contains('web-view-blog-app.netlify.app/article') &&
        request.url != currentUrl) {
      await onArticleNavigate();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }
}
