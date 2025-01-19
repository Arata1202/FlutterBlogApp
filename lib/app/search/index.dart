import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../search_result/index.dart';
import '../../common/admob/banner/index.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

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
      ..setBackgroundColor(
          isIOS ? CupertinoColors.systemBackground : Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('web-view-blog-app.vercel.app/tag/') ||
                request.url
                    .contains('web-view-blog-app.vercel.app/search?q=') ||
                request.url.contains('web-view-blog-app.vercel.app/archive')) {
              if (isIOS) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SearchResultsPage(url: request.url),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsPage(url: request.url),
                  ),
                );
              }
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
    if (isIOS) {
      final query = _searchController.text;
      if (query.isNotEmpty) {
        setState(() {
          _searchHistory.remove(query);
          _searchHistory.insert(0, query);
          if (_searchHistory.length > 5) {
            _searchHistory = _searchHistory.take(5).toList();
          }
          _saveSearchHistory();
        });
        _searchController.clear();
        final searchUrl =
            'https://web-view-blog-app.vercel.app/search?q=$query';
        _webViewController.loadRequest(Uri.parse(searchUrl));
      }
    } else {
      final query = _searchController.text;
      if (query.isNotEmpty) {
        setState(() {
          _searchHistory.remove(query);
          _searchHistory.insert(0, query);
          if (_searchHistory.length > 5) {
            _searchHistory = _searchHistory.take(5).toList();
          }
          _saveSearchHistory();
        });
        _searchController.clear();
        final searchUrl =
            'https://web-view-blog-app.vercel.app/search?q=$query';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsPage(url: searchUrl),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
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
              adUnitId: dotenv.get('BANNER_AD'),
            ),
            keyword(),
            Expanded(
              child: WebViewWidget(controller: _webViewController),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildSearchFormCard(),
            BannerAdWidget(
              adUnitId: dotenv.get('BANNER_AD'),
            ),
            _buildSectionTitle('タグ'),
            Expanded(
              child: WebViewWidget(controller: _webViewController),
            ),
          ],
        ),
      );
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      centerTitle: true,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFormCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '検索',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _performSearch,
            ),
          ),
          onSubmitted: (value) => _performSearch(),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, String history) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(history),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() {
                _searchHistory.remove(history);
                _saveSearchHistory();
              });
              Navigator.pop(context);
            },
            child: Text('削除する'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('キャンセル'),
        ),
      ),
    );
  }

  Widget keyword() {
    return CupertinoListSection(
      header: Text(
        'アーカイブ・タグ',
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
