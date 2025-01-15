import 'package:flutter/material.dart';
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
import '../../components/menu/favorite/index.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

class ArticlePage extends StatefulWidget {
  final String url;

  const ArticlePage({super.key, required this.url});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class ArticleHistoryManager {
  static const _historyKey = 'article_history';

  static Future<void> addArticleToHistory(String url, String title) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    history.add('$title|$url');
    await prefs.setStringList(_historyKey, history);
  }

  static Future<List<Map<String, String>>> getArticleHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history.map((entry) {
      var parts = entry.split('|');
      return {
        'title': parts[0],
        'url': parts[1],
      };
    }).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

class FavoritesManager {
  static const _favoritesKey = 'favorite_articles';

  static Future<void> addFavorite(String url, String title) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (favorites.length >= 15) {
      return;
    }
    favorites.insert(0, '$title|$url');
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<void> removeFavorite(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.removeWhere((entry) => entry.split('|')[1] == url);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<List<Map<String, String>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((entry) {
      var parts = entry.split('|');
      return {
        'title': parts[0],
        'url': parts[1],
      };
    }).toList();
  }

  static Future<bool> isFavorite(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.any((entry) => entry.split('|')[1] == url);
  }

  static Future<int> getFavoriteCount() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.length;
  }
}

class _ArticlePageState extends State<ArticlePage> {
  late WebViewController _controller;
  bool _isInterstitialAdReady = false;
  late InterstitialAdManager _interstitialAdManager;
  String _pageTitle = '';
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WakelockManager.enable();
    LastUrlManager.saveLastUrl(widget.url);

    // インタースティシャル
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadInterstitialAd(
      dotenv.get('INTERSTITIAL_AD'),
      () => setState(() => _isInterstitialAdReady = true),
    );

    _initializeWebViewController();
    _checkIfFavorite();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(
          isIOS ? CupertinoColors.systemBackground : Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            _pageTitle = await _controller.getTitle() ?? 'Unknown';
            ArticleHistoryManager.addArticleToHistory(widget.url, _pageTitle);
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (isIOS) {
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
            } else {
              return await NavigationHelper.handleNavigationRequest(
                request,
                widget.url,
                () async {
                  await _interstitialAdManager.showInterstitialAd();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticlePage(url: request.url),
                    ),
                  ).then((_) => LastUrlManager.clearLastUrl());
                },
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _checkIfFavorite() async {
    _isFavorite = await FavoritesManager.isFavorite(widget.url);
    setState(() {});
  }

  void _toggleFavorite() async {
    int favoriteCount = await FavoritesManager.getFavoriteCount();
    if (_isFavorite) {
      await FavoritesManager.removeFavorite(widget.url);
      setState(() {
        _isFavorite = false;
      });
    } else if (favoriteCount >= 15) {
      _showFavoriteLimitExceededSheet();
    } else {
      await FavoritesManager.addFavorite(widget.url, _pageTitle);
      setState(() {
        _isFavorite = true;
      });
    }
  }

  void _showFavoriteLimitExceededSheet() {
    if (isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: const Text('登録は15件までです。'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Favorite()),
                  );
                },
                child: const Text('お気に入りを編集'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('登録は15件までです。', textAlign: TextAlign.center),
              ),
              ListTile(
                title: const Text('お気に入りを編集'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favorite()),
                  );
                },
              ),
              ListTile(
                title: const Text('キャンセル'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
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
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(context),
        child: Column(
          children: [
            BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: WebViewWidget(controller: _controller),
              ),
            ),
          ],
        ),
      );
    }
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
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          _shareArticle();
        },
        child:
            const Icon(CupertinoIcons.share, color: CupertinoColors.activeBlue),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back, color: Colors.black),
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        if (!_isLoading)
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
      ],
    );
  }

  void _shareArticle() {
    Share.share('$_pageTitle\n${widget.url}');
  }
}
