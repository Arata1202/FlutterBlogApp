import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../article/index.dart';
import '../search_result/index.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late WebViewController _controller;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _initializeWebViewController();
  }

  void _createBannerAd() {
    String adUnitId = dotenv.get('PRODUCTION_BANNER_AD_ID_SEARCH');
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

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('web-view-blog-app.netlify.app/tag/') ||
                request.url
                    .contains('web-view-blog-app.netlify.app/search?q=')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultsPage(url: request.url),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web-view-blog-app.netlify.app/keyword'));
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Center(
            child: Text(
              '検索',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
