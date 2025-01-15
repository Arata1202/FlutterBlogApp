import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../article/index.dart';
import '../../common/admob/banner/index.dart';
import '../../common/admob/interstitial/index.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String? _lastUrl;
  late InterstitialAdManager _interstitialAdManager;
  bool _isInterstitialAdReady = false;

  final List<Widget> _tabs = [
    const NewPostTab(),
    const ProgrammingPostTab(),
    const UniversityPostTab(),
    const TravelPostTab(),
    const BlogPostTab(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeInterstitialAdManager();
    _loadLastUrl();
  }

  void _initializeInterstitialAdManager() {
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadInterstitialAd(
      dotenv.get('INTERSTITIAL_AD'),
      () => setState(() => _isInterstitialAdReady = true),
    );
  }

  void _loadLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastUrl = prefs.getString('lastUrl');
    });
    if (_lastUrl != null) {
      if (isIOS) {
        _showInterstitialAd().then((_) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ArticlePage(url: _lastUrl!),
            ),
          ).then((_) => _clearLastUrl());
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticlePage(url: _lastUrl!),
          ),
        ).then((_) => _clearLastUrl());
      }
    }
  }

  void _clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUrl');
  }

  Future<void> _showInterstitialAd() async {
    if (_isInterstitialAdReady) {
      await _interstitialAdManager.showInterstitialAd();
    } else {
      print('Interstitial ad is not ready yet');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _interstitialAdManager.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return DefaultTabController(
        initialIndex: 0,
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Column(
              children: [
                _buildNavigationBar(context),
                TabBar(
                  indicatorColor: CupertinoColors.activeBlue,
                  labelColor: CupertinoColors.activeBlue,
                  isScrollable: true,
                  tabs: const <Widget>[
                    Tab(text: '最新記事'),
                    Tab(text: 'プログラミング'),
                    Tab(text: '大学生活'),
                    Tab(text: '旅行'),
                    Tab(text: 'ブログ'),
                  ],
                  onTap: _onTabTapped,
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _tabs,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return DefaultTabController(
        initialIndex: 0,
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(105.0),
            child: Column(
              children: [
                _buildAppBar(context),
                TabBar(
                  indicatorColor: CupertinoColors.activeBlue,
                  labelColor: CupertinoColors.activeBlue,
                  isScrollable: true,
                  tabs: const <Widget>[
                    Tab(text: '最新記事'),
                    Tab(text: 'プログラミング'),
                    Tab(text: '大学生活'),
                    Tab(text: '旅行'),
                    Tab(text: 'ブログ'),
                  ],
                  onTap: _onTabTapped,
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _tabs,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class NewPostTab extends StatelessWidget {
  const NewPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(url: 'https://web-view-blog-app.vercel.app');
  }
}

class ProgrammingPostTab extends StatelessWidget {
  const ProgrammingPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.vercel.app/category/programming');
  }
}

class UniversityPostTab extends StatelessWidget {
  const UniversityPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.vercel.app/category/university');
  }
}

class TravelPostTab extends StatelessWidget {
  const TravelPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.vercel.app/category/travel');
  }
}

class BlogPostTab extends StatelessWidget {
  const BlogPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.vercel.app/category/blog');
  }
}

class WebViewTab extends StatefulWidget {
  final String url;

  const WebViewTab({super.key, required this.url});

  @override
  _WebViewTabState createState() => _WebViewTabState();
}

class _WebViewTabState extends State<WebViewTab> {
  late WebViewController _controller;
  late InterstitialAdManager _interstitialAdManager;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _initializeInterstitialAdManager();
    _initializeWebViewController();
  }

  void _initializeInterstitialAdManager() {
    _interstitialAdManager = InterstitialAdManager();
    _interstitialAdManager.loadInterstitialAd(
      dotenv.get('INTERSTITIAL_AD'),
      () => setState(() => _isInterstitialAdReady = true),
    );
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(
          isIOS ? CupertinoColors.systemBackground : Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('web-view-blog-app.vercel.app/article') &&
                request.url != widget.url) {
              await _showInterstitialAd();
              if (isIOS) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ArticlePage(url: request.url),
                  ),
                ).then((_) => _clearLastUrl());
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticlePage(url: request.url),
                  ),
                ).then((_) => _clearLastUrl());
              }
              return NavigationDecision.prevent;
            }
            if (!request.url.contains('web-view-blog-app.vercel.app')) {
              if (await canLaunch(request.url)) {
                await launch(request.url, forceSafariVC: false);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _showInterstitialAd() async {
    if (_isInterstitialAdReady) {
      await _interstitialAdManager.showInterstitialAd();
    } else {
      print('Interstitial ad is not ready yet');
    }
  }

  void _clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUrl');
  }

  @override
  void dispose() {
    _interstitialAdManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WebViewWidget(controller: _controller),
    );
  }
}
