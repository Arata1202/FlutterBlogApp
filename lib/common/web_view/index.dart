import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../config/app_urls.dart';
import '../../util/platform/index.dart';

typedef AppNavigationHandler =
    Future<NavigationDecision> Function(NavigationRequest request);

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
    _controller =
        WebViewController.fromPlatformCreationParams(
            _controllerCreationParams(),
          )
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
              onWebResourceError: (error) {
                _setLoading(false);
                FlutterError.reportError(
                  FlutterErrorDetails(
                    exception: StateError(
                      'WebView failed to load ${error.url}: ${error.description}',
                    ),
                    library: 'FlutterBlogApp',
                    context: ErrorDescription(
                      'WebView resource loading failed',
                    ),
                  ),
                );
              },
              onNavigationRequest: (request) {
                if (!request.isMainFrame) {
                  return NavigationDecision.navigate;
                }

                return widget.onNavigationRequest?.call(request) ??
                    Future.value(NavigationDecision.navigate);
              },
            ),
          )
          ..loadRequest(AppUrls.withAppMode(widget.initialUrl));
  }

  PlatformWebViewControllerCreationParams _controllerCreationParams() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    }

    return const PlatformWebViewControllerCreationParams();
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
        if (_isLoading)
          Center(
            child: AppPlatform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          ),
      ],
    );
  }
}
