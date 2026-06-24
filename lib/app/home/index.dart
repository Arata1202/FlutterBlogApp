import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/web_view/index.dart';
import '../../config/app_urls.dart';
import '../../util/navigation/index.dart';
import '../../util/platform/index.dart';
import '../../util/web_view_navigation/index.dart';
import '../article/index.dart';
import '../pagination/index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final _tabs = [
    _HomeTab(label: '最新記事', url: AppUrls.home),
    _HomeTab(label: 'プログラミング', url: AppUrls.programming),
    _HomeTab(label: '大学生活', url: AppUrls.university),
    _HomeTab(label: '旅行', url: AppUrls.travel),
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
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppPlatform.isIOS ? 100 : 112),
          child: Column(
            children: [
              AppPlatform.isIOS ? _buildNavigationBar() : _buildAppBar(),
              TabBar(
                indicatorColor: CupertinoColors.activeBlue,
                labelColor: CupertinoColors.activeBlue,
                isScrollable: true,
                tabs: [for (final tab in _tabs) Tab(text: tab.label)],
                onTap: _onTabTapped,
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            for (var index = 0; index < _tabs.length; index++)
              _loadedIndexes.contains(index)
                  ? _HomeWebView(initialUrl: _tabs[index].url)
                  : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.white,
      middle: Image.asset('assets/title.webp', height: 28),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Image.asset('assets/title.webp', height: 28),
      centerTitle: true,
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
    final url = request.url;
    final currentUrl = initialUrl.toString();

    if (AppUrls.isArticleUrl(url) && url != currentUrl) {
      await pushAppPage(context, ArticlePage(url: url));
      return NavigationDecision.prevent;
    }

    if (AppUrls.isPaginationUrl(url) && url != currentUrl) {
      await pushAppPage(context, PaginationPage(url: url));
      return NavigationDecision.prevent;
    }

    if (!AppUrls.isAppUrl(url)) {
      return preventAndLaunchExternalUrl(url);
    }

    return NavigationDecision.navigate;
  }
}
