import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/page_scaffold/index.dart';
import '../../common/web_view/index.dart';
import '../../config/app_urls.dart';
import '../../util/navigation/index.dart';
import '../../util/platform/index.dart';
import '../../util/web_view_navigation/index.dart';
import '../search_result/index.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  Uri _webViewUrl = AppUrls.searchTop;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      return;
    }

    _searchController.clear();
    final searchUrl = AppUrls.search(query);

    if (AppPlatform.isIOS) {
      setState(() {
        _webViewUrl = searchUrl;
      });
      return;
    }

    pushAppPage(context, SearchResultsPage(url: searchUrl.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      child: Column(
        children: [
          AppPlatform.isIOS ? _buildCupertinoSearchField() : _buildSearchCard(),
          Expanded(
            child: AppWebView(
              key: ValueKey(_webViewUrl.toString()),
              initialUrl: _webViewUrl,
              onNavigationRequest: _handleNavigationRequest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CupertinoSearchTextField(
        controller: _searchController,
        placeholder: '検索',
        onSubmitted: (_) => _performSearch(),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '検索',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _performSearch,
            ),
          ),
          onSubmitted: (_) => _performSearch(),
        ),
      ),
    );
  }

  Future<NavigationDecision> _handleNavigationRequest(
    NavigationRequest request,
  ) async {
    final url = AppUrls.toAppUrlString(request.url);
    final currentUrl = _webViewUrl.toString();

    if (AppUrls.isSearchDestinationUrl(url) && url != currentUrl) {
      await pushAppPage(context, SearchResultsPage(url: url));
      return NavigationDecision.prevent;
    }

    if (!AppUrls.isAppUrl(url)) {
      return preventAndLaunchExternalUrl(request.url);
    }

    return NavigationDecision.navigate;
  }
}
