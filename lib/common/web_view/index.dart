import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../util/platform/index.dart';

typedef AppNavigationHandler = Future<NavigationDecision> Function(
  NavigationRequest request,
);

class AppWebView extends StatefulWidget {
  final Uri initialUrl;
  final AppNavigationHandler? onNavigationRequest;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<bool>? onLoadingChanged;
  final Color? backgroundColor;

  const AppWebView({
    super.key,
    required this.initialUrl,
    this.onNavigationRequest,
    this.onTitleChanged,
    this.onLoadingChanged,
    this.backgroundColor,
  });

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(
        widget.backgroundColor ??
            (AppPlatform.isIOS
                ? CupertinoColors.systemBackground
                : Colors.white),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _setLoading(true),
          onPageFinished: (_) async {
            final title = await _controller.getTitle();
            if (title != null) {
              widget.onTitleChanged?.call(title);
            }
            _setLoading(false);
          },
          onNavigationRequest: (request) {
            return widget.onNavigationRequest?.call(request) ??
                Future.value(NavigationDecision.navigate);
          },
        ),
      )
      ..loadRequest(widget.initialUrl);
  }

  void _setLoading(bool value) {
    if (!mounted || _isLoading == value) {
      return;
    }

    setState(() {
      _isLoading = value;
    });
    widget.onLoadingChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
