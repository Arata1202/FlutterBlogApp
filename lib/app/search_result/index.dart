import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../article/index.dart';
import '../../common/admob/interstitial/index.dart';
import '../../common/admob/banner/index.dart';

class SearchResultsPage extends StatefulWidget {
  final String url;

  const SearchResultsPage({super.key, required this.url});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late WebViewController _controller;
  late InterstitialAdManager _interstitialAdManager;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _interstitialAdManager = InterstitialAdManager();
    _loadInterstitialAd();
    _initializeWebViewController();
  }

  void _loadInterstitialAd() {
    _interstitialAdManager.loadInterstitialAd(
      dotenv.get('PRODUCTION_INTERSTITIAL_AD_ID_SEARCH'),
      () => setState(() => _isInterstitialAdReady = true),
    );
  }

  void _showInterstitialAd(VoidCallback onAdClosed) {
    if (_isInterstitialAdReady) {
      _interstitialAdManager.showInterstitialAd().then((_) {
        onAdClosed();
      }).catchError((error) {
        print('Failed to show interstitial ad: $error');
        onAdClosed();
      });
    } else {
      print('Interstitial ad is not ready yet');
      onAdClosed();
    }
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('web-view-blog-app.vercel.app/article')) {
              _showInterstitialAd(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticlePage(url: request.url),
                  ),
                );
              });
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
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    _interstitialAdManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
        // bottom: const PreferredSize(
        //   preferredSize: Size.fromHeight(30.0),
        //   child: Center(
        //       child: Text(
        //         '検索結果',
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontSize: 15,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       ),
        // ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          BannerAdWidget(
              adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_SEARCH_RESULT')),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
