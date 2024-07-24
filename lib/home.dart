import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://webviewblogapp.netlify.app'));
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 8, // タブの数
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
          bottom: const TabBar(
            isScrollable: true, // スクロールを有効化
            tabs: <Widget>[
              Tab(text: '最新記事'),
              Tab(text: 'プログラミング'),
              Tab(text: '大学生活'),
              Tab(text: '旅行'),
              Tab(text: 'ブログ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            NewPostTab(),
            ProgrammingPostTab(),
            UniversityPostTab(),
            TravelPostTab(),
            BlogPostTab(),
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
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://webviewblogapp.netlify.app'));
    return MaterialApp(
      home: WebViewWidget(controller: controller),
    );
  }
}

class ProgrammingPostTab extends StatelessWidget {
  const ProgrammingPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(
          Uri.parse('https://webviewblogapp.netlify.app/category/programming'));
    return MaterialApp(
      home: WebViewWidget(controller: controller),
    );
  }
}

class UniversityPostTab extends StatelessWidget {
  const UniversityPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(
          Uri.parse('https://webviewblogapp.netlify.app/category/university'));
    return MaterialApp(
      home: WebViewWidget(controller: controller),
    );
  }
}

class TravelPostTab extends StatelessWidget {
  const TravelPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(
          Uri.parse('https://webviewblogapp.netlify.app/category/travel'));
    return MaterialApp(
      home: WebViewWidget(controller: controller),
    );
  }
}

class BlogPostTab extends StatelessWidget {
  const BlogPostTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..loadRequest(
          Uri.parse('https://webviewblogapp.netlify.app/category/blog'));
    return MaterialApp(
      home: WebViewWidget(controller: controller),
    );
  }
}
