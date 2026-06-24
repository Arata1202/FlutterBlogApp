import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/page_scaffold/index.dart';
import '../../common/web_view/index.dart';
import '../../config/app_urls.dart';
import '../../util/navigation/index.dart';
import '../../util/platform/index.dart';
import '../search_result/index.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  Uri _webViewUrl = AppUrls.keyword;

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
          AppPlatform.isIOS
              ? _buildCupertinoSectionTitle()
              : _buildMaterialSectionTitle('アーカイブ・タグ'),
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

  Widget _buildCupertinoSectionTitle() {
    return CupertinoListSection(
      header: const Text(
        'アーカイブ・タグ',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
      children: const [],
    );
  }

  Widget _buildMaterialSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<NavigationDecision> _handleNavigationRequest(
    NavigationRequest request,
  ) async {
    if (AppUrls.isSearchDestinationUrl(request.url)) {
      await pushAppPage(context, SearchResultsPage(url: request.url));
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }
}
