import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/page_scaffold/index.dart';
import '../../../common/web_view/index.dart';
import '../../../config/app_urls.dart';
import '../../../util/web_view_navigation/index.dart';

class MenuWebPage extends StatelessWidget {
  final Uri initialUrl;

  const MenuWebPage({super.key, required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      showBackButton: true,
      child: AppWebView(
        initialUrl: initialUrl,
        onNavigationRequest: _handleNavigationRequest,
      ),
    );
  }

  Future<NavigationDecision> _handleNavigationRequest(
    NavigationRequest request,
  ) async {
    final url = AppUrls.toAppUrlString(request.url);

    if (!AppUrls.isAppUrl(url)) {
      return preventAndLaunchExternalUrl(request.url);
    }

    return NavigationDecision.navigate;
  }
}
