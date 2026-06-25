import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/page_scaffold/index.dart';
import '../../common/web_view/index.dart';
import '../../config/app_urls.dart';
import '../../util/navigation/index.dart';
import '../../util/web_view_navigation/index.dart';
import '../article/index.dart';
import '../pagination/index.dart';

class SearchResultsPage extends StatelessWidget {
  final String url;

  const SearchResultsPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      showBackButton: true,
      child: AppWebView(
        initialUrl: Uri.parse(url),
        onNavigationRequest:
            (request) => _handleNavigationRequest(context, request),
      ),
    );
  }

  Future<NavigationDecision> _handleNavigationRequest(
    BuildContext context,
    NavigationRequest request,
  ) async {
    final requestedUrl = AppUrls.toAppUrlString(request.url);

    if (AppUrls.isArticleUrl(requestedUrl) && requestedUrl != url) {
      await pushAppPage(context, ArticlePage(url: requestedUrl));
      return NavigationDecision.prevent;
    }

    if (AppUrls.isPaginationUrl(requestedUrl) && requestedUrl != url) {
      await pushAppPage(context, PaginationPage(url: requestedUrl));
      return NavigationDecision.prevent;
    }

    if (!AppUrls.isAppUrl(requestedUrl)) {
      return preventAndLaunchExternalUrl(request.url);
    }

    return NavigationDecision.navigate;
  }
}
