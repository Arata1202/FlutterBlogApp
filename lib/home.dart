import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String? _lastUrl;

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
  }

  void _loadLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastUrl = prefs.getString('lastUrl');
    });
    if (_lastUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlePage(url: _lastUrl!),
        ),
      ).then((_) => _clearLastUrl());
    }
  }

  void _clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUrl');
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
        body: IndexedStack(
          index: _currentIndex,
          children: _tabs,
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

class WebViewTab extends StatelessWidget {
  final String url;

  const WebViewTab({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('/article') && request.url != url) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlePage(url: request.url),
                ),
              ).then((_) => _clearLastUrl());
              return NavigationDecision.prevent;
            }
            // 外部リンク（Amazon、楽天、Yahoo）の場合は外部ブラウザで開く
            if (request.url.contains('amazon.co.jp') ||
                request.url.contains('rakuten.co.jp') ||
                request.url.contains('yahoo.co.jp')) {
              if (await canLaunch(request.url)) {
                await launch(request.url, forceSafariVC: false);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      backgroundColor: Colors.white,
      body: WebViewWidget(controller: controller),
    );
  }

  void _clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUrl');
  }
}

class ArticlePage extends StatefulWidget {
  final String url;

  const ArticlePage({super.key, required this.url});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _saveLastUrl(widget.url);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('/article') && request.url != widget.url) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlePage(url: request.url),
                ),
              ).then((_) => _clearLastUrl());
              return NavigationDecision.prevent;
            }
            // 外部リンク（Amazon、楽天、Yahoo）の場合は外部ブラウザで開く
            if (request.url.contains('amazon.co.jp') ||
                request.url.contains('rakuten.co.jp') ||
                request.url.contains('google.com') ||
                request.url.contains('yahoo.co.jp')) {
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

  void _saveLastUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUrl', url);
  }

  void _clearLastUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastUrl');
  }

  @override
  void dispose() {
    // 自動ロックを有効化
    Wakelock.disable();
    _clearLastUrl();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 60,
        elevation: 4,
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
      ),
      backgroundColor: Colors.white,
      body: WebViewWidget(controller: _controller),
    );
  }
}
