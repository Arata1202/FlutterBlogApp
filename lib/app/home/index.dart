import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../article/index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String? _lastUrl;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
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
    _loadLastUrl();
    _createBannerAd();
    _loadInterstitialAd();
  }

  void _createBannerAd() {
    String adUnitId = dotenv.get('PRODUCTION_BANNER_AD_ID_HOME');

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  void _loadLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastUrl = prefs.getString('lastUrl');
    });
    if (_lastUrl != null) {
      _showInterstitialAd().then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticlePage(url: _lastUrl!),
          ),
        ).then((_) => _clearLastUrl());
      });
    }
  }

  void _clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUrl');
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: dotenv.get('PRODUCTION_INTERSTITIAL_AD_ID_HOME'),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_isInterstitialAdReady) {
      await _interstitialAd?.show();
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 60,
          elevation: 4,
          title: Image.asset(
            'assets/title.webp',
            height: 28,
          ),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
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
        ),
        body: Column(
          children: [
            if (_bannerAd != null)
              Container(
                color: Colors.white,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
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

class NewPostTab extends StatelessWidget {
  const NewPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(url: 'https://web-view-blog-app.netlify.app');
  }
}

class ProgrammingPostTab extends StatelessWidget {
  const ProgrammingPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.netlify.app/category/programming');
  }
}

class UniversityPostTab extends StatelessWidget {
  const UniversityPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.netlify.app/category/university');
  }
}

class TravelPostTab extends StatelessWidget {
  const TravelPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.netlify.app/category/travel');
  }
}

class BlogPostTab extends StatelessWidget {
  const BlogPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewTab(
        url: 'https://web-view-blog-app.netlify.app/category/blog');
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
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('web-view-blog-app.netlify.app/article') &&
                request.url != widget.url) {
              await _showInterstitialAd();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlePage(url: request.url),
                ),
              ).then((_) => _clearLastUrl());
              return NavigationDecision.prevent;
            }
            if (!request.url.contains('web-view-blog-app.netlify.app')) {
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

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: dotenv.get('PRODUCTION_INTERSTITIAL_AD_ID_HOME'),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_isInterstitialAdReady) {
      await _interstitialAd?.show();
    } else {
      print('Interstitial ad is not ready yet');
    }
  }

  void _clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WebViewWidget(controller: _controller),
    );
  }
}
