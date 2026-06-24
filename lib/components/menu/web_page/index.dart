import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/page_scaffold/index.dart';
import '../../../common/web_view/index.dart';
import '../../../config/app_urls.dart';
import '../../../util/launch_url/index.dart';

class MenuWebPage extends StatelessWidget {
  final Uri initialUrl;

  const MenuWebPage({
    super.key,
    required this.initialUrl,
  });

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
    if (!AppUrls.isAppUrl(request.url)) {
      await launchExternalUrl(request.url);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }
}
