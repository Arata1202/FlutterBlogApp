import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../search_result/index.dart';
import '../../common/admob/banner/index.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late WebViewController _webViewController;
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    _loadSearchHistory();
  }

  void _initializeWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CupertinoColors.systemBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('web-view-blog-app.vercel.app/tag/') ||
                request.url
                    .contains('web-view-blog-app.vercel.app/search?q=')) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchResultsPage(url: request.url),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error occurred: $error');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web-view-blog-app.vercel.app/keyword'));
  }

  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  void _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      setState(() {
        _searchHistory.remove(query);
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 30) {
          _searchHistory = _searchHistory.sublist(0, 30);
        }
        _saveSearchHistory();
      });
      _searchController.clear();
      final searchUrl = 'https://web-view-blog-app.vercel.app/search?q=$query';
      _webViewController.loadRequest(Uri.parse(searchUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: '検索',
              onSubmitted: (value) => _performSearch(),
            ),
          ),
          BannerAdWidget(
            adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_SEARCH'),
          ),
          _buildSearchHistory(),
          keyword(),
          Expanded(
            child: WebViewWidget(controller: _webViewController),
          ),
        ],
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.white,
      middle: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
    );
  }

  Widget _buildSearchHistory() {
    return CupertinoListSection(
      header: Text(
        '検索履歴',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
      children: _searchHistory.isNotEmpty
          ? _searchHistory.take(5).map((history) {
              return CupertinoListTile(
                title: Text(history),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.clear_thick_circled,
                    color: CupertinoColors.systemGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchHistory.remove(history);
                      _saveSearchHistory();
                    });
                  },
                ),
                onTap: () {
                  _webViewController.loadRequest(Uri.parse(
                      'https://web-view-blog-app.vercel.app/search?q=$history'));
                },
              );
            }).toList()
          : [
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  '検索履歴はありません。',
                  style: TextStyle(color: CupertinoColors.systemGrey),
                ),
              ),
            ],
    );
  }

  Widget keyword() {
    return CupertinoListSection(
      header: Text(
        'キーワードで探す',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
      children: [],
    );
  }
}
