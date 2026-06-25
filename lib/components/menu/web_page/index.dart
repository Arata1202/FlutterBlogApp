import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/page_scaffold/index.dart';
import '../../../common/web_view/index.dart';
import '../../../config/app_urls.dart';
import '../../../util/navigation/index.dart';
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
        onNavigationRequest: (request) =>
            _handleNavigationRequest(context, request),
      ),
    );
  }

  Future<NavigationDecision> _handleNavigationRequest(
    BuildContext context,
    NavigationRequest request,
  ) async {
    final url = AppUrls.toAppUrlString(request.url);

    if (!AppUrls.isAppUrl(url)) {
      return preventAndLaunchExternalUrl(request.url);
    }

    if (AppUrls.isFixedPageUrl(url) && !_isCurrentPage(url)) {
      await pushAppPage(context, MenuWebPage(initialUrl: Uri.parse(url)));
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  bool _isCurrentPage(String url) {
    final requestedUri = Uri.tryParse(url);
    if (requestedUri == null) {
      return false;
    }

    final currentUri = AppUrls.withAppMode(initialUrl);
    return requestedUri.scheme == currentUri.scheme &&
        requestedUri.host == currentUri.host &&
        requestedUri.port == currentUri.port &&
        requestedUri.path == currentUri.path;
  }
}
