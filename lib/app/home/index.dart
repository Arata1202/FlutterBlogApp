import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/page_scaffold/index.dart';
import '../../common/web_view/index.dart';
import '../../config/app_urls.dart';
import '../../util/navigation/index.dart';
import '../../util/platform/index.dart';
import '../../util/web_view_navigation/index.dart';
import '../article/index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final _tabs = [
    _HomeTab(label: '最新記事', url: AppUrls.home),
    _HomeTab(label: '大学生活', url: AppUrls.university),
    _HomeTab(label: '社会人生活', url: AppUrls.work),
    _HomeTab(label: 'レジャー', url: AppUrls.leisure),
    _HomeTab(label: '旅行', url: AppUrls.travel),
    _HomeTab(label: 'プログラミング', url: AppUrls.programming),
    _HomeTab(label: 'ブログ', url: AppUrls.blog),
  ];

  int _currentIndex = 0;
  final Set<int> _loadedIndexes = {0};

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _loadedIndexes.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _tabs.length,
      child:
          AppPlatform.isIOS
              ? AppPageScaffold(child: _buildContent())
              : Column(
                children: [
                  _buildMaterialHeader(context),
                  Expanded(child: _buildContent()),
                ],
              ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        ColoredBox(
          color: Colors.white,
          child: Material(
            color: Colors.white,
            child: TabBar(
              indicatorColor: CupertinoColors.activeBlue,
              labelColor: CupertinoColors.activeBlue,
              isScrollable: true,
              tabs: [for (final tab in _tabs) Tab(text: tab.label)],
              onTap: _onTabTapped,
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              for (var index = 0; index < _tabs.length; index++)
                _loadedIndexes.contains(index)
                    ? _HomeWebView(initialUrl: _tabs[index].url)
                    : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialHeader(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SizedBox(
          height: kToolbarHeight,
          child: Center(child: Image.asset('assets/title.webp', height: 28)),
        ),
      ),
    );
  }
}

class _HomeTab {
  final String label;
  final Uri url;

  const _HomeTab({required this.label, required this.url});
}

class _HomeWebView extends StatelessWidget {
  final Uri initialUrl;

  const _HomeWebView({required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return AppWebView(
      initialUrl: initialUrl,
      onNavigationRequest:
          (request) => _handleNavigationRequest(context, request),
    );
  }

  Future<NavigationDecision> _handleNavigationRequest(
    BuildContext context,
    NavigationRequest request,
  ) async {
    final url = AppUrls.toAppUrlString(request.url);
    final currentUrl = initialUrl.toString();

    if (AppUrls.isArticleUrl(url) && url != currentUrl) {
      await pushAppPage(context, ArticlePage(url: url));
      return NavigationDecision.prevent;
    }

    if (!AppUrls.isAppUrl(url)) {
      return preventAndLaunchExternalUrl(request.url);
    }

    return NavigationDecision.navigate;
  }
}
