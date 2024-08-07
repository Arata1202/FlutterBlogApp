import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../util/last_article/index.dart';
import '../../common/admob/interstitial/index.dart';
import '../../common/admob/banner/index.dart';
import '../../util/navigate_out/index.dart';
import '../../util/wake_lock/index.dart';

class ArticlePage extends StatefulWidget {
  final String url;

  const ArticlePage({super.key, required this.url});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class ArticleHistoryManager {
  static const _historyKey = 'article_history';

  static Future<void> addArticleToHistory(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    history.add(url);
    await prefs.setStringList(_historyKey, history);
  }

  static Future<List<String>> getArticleHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

class _ArticlePageState extends State<ArticlePage> {
  late WebViewController _controller;

  // インタースティシャル
  late InterstitialAdManager _interstitialAdManager;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    WakelockManager.enable();
    LastUrlManager.saveLastUrl(widget.url);

    ArticleHistoryManager.addArticleToHistory(widget.url);

    // インタースティシャル
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadInterstitialAd(
      dotenv.get('PRODUCTION_INTERSTITIAL_AD_ID_HOME'),
      () => setState(() => _isInterstitialAdReady = true),
    );

    _initializeWebViewController();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CupertinoColors.systemBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            return await NavigationHelper.handleNavigationRequest(
              request,
              widget.url,
              () async {
                await _interstitialAdManager.showInterstitialAd();
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ArticlePage(url: request.url),
                  ),
                ).then((_) => LastUrlManager.clearLastUrl());
              },
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  void _cleanupResources() {
    WakelockManager.disable();
    _interstitialAdManager.dispose();
    LastUrlManager.clearLastUrl();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(context),
      child: Column(
        children: [
          BannerAdWidget(
              adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_ARTICLE')),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 39.0),
              child: WebViewWidget(controller: _controller),
            ),
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
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
            SizedBox(width: 4),
            Text(
              '戻る',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ],
        ),
      ),
    );
  }
}
