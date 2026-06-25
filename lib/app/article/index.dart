import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/page_scaffold/index.dart';
import '../../common/web_view/index.dart';
import '../../config/app_urls.dart';
import '../../util/navigation/index.dart';
import '../../util/web_view_navigation/index.dart';

class ArticlePage extends StatefulWidget {
  final String url;

  const ArticlePage({super.key, required this.url});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  String _pageTitle = '';
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      showBackButton: true,
      cupertinoTrailing:
          _isLoading
              ? null
              : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _shareArticle,
                child: const Icon(
                  CupertinoIcons.share,
                  color: CupertinoColors.activeBlue,
                ),
              ),
      materialActions: [
        if (!_isLoading)
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: _shareArticle,
          ),
      ],
      child: AppWebView(
        initialUrl: Uri.parse(widget.url),
        onTitleChanged: (title) => _pageTitle = title,
        onLoadingChanged: (isLoading) {
          if (!mounted) {
            return;
          }
          setState(() {
            _isLoading = isLoading;
          });
        },
        onNavigationRequest: _handleNavigationRequest,
      ),
    );
  }

  Future<NavigationDecision> _handleNavigationRequest(
    NavigationRequest request,
  ) async {
    final url = AppUrls.toAppUrlString(request.url);

    if (!AppUrls.isAppUrl(url)) {
      return preventAndLaunchExternalUrl(request.url);
    }

    if (AppUrls.isArticleUrl(url) && url != widget.url) {
      await pushAppPage(context, ArticlePage(url: url));
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _shareArticle() {
    final title = _pageTitle.isEmpty ? 'リアル大学生' : _pageTitle;
    unawaited(
      SharePlus.instance.share(
        ShareParams(text: '$title\n${AppUrls.toPublicUrl(widget.url)}'),
      ),
    );
  }
}
