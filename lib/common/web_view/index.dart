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
  String? _loadErrorDescription;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController.fromPlatformCreationParams(
            _controllerCreationParams(),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(widget.backgroundColor ?? Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                _setLoadError(null);
                _setLoading(true);
              },
              onPageFinished: (_) async {
                final title = await _controller.getTitle();
                if (title != null) {
                  widget.onTitleChanged?.call(title);
                }
                _setLoadError(null);
                _setLoading(false);
              },
              onWebResourceError: (error) {
                if (error.isForMainFrame == false) {
                  return;
                }

                _setLoadError(error.description);
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

  void _setLoadError(String? description) {
    if (!mounted || _loadErrorDescription == description) {
      return;
    }

    setState(() {
      _loadErrorDescription = description;
    });
  }

  void _reload() {
    _setLoadError(null);
    _setLoading(true);
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    final loadErrorDescription = _loadErrorDescription;

    return ColoredBox(
      color: widget.backgroundColor ?? Colors.white,
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (loadErrorDescription != null)
            _WebViewLoadErrorView(
              description: loadErrorDescription,
              onReload: _reload,
            ),
          if (_isLoading)
            Center(
              child:
                  AppPlatform.isIOS
                      ? const CupertinoActivityIndicator()
                      : const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class _WebViewLoadErrorView extends StatelessWidget {
  final String description;
  final VoidCallback onReload;

  const _WebViewLoadErrorView({
    required this.description,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final message =
        description.trim().isEmpty ? '通信状況を確認して、もう一度お試しください。' : description;

    return Positioned.fill(
      child: Material(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    AppPlatform.isIOS
                        ? CupertinoIcons.exclamationmark_triangle
                        : Icons.error_outline,
                    size: 36,
                    color:
                        AppPlatform.isIOS
                            ? CupertinoColors.systemGrey
                            : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ページを読み込めませんでした',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AppPlatform.isIOS
                      ? CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        onPressed: onReload,
                        child: const Text('再読み込み'),
                      )
                      : ElevatedButton(
                        onPressed: onReload,
                        child: const Text('再読み込み'),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
