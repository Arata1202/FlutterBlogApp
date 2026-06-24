class AppUrls {
  static const appOrigin = 'https://web-view-blog-app.vercel.app';
  static const publicOrigin = 'https://realunivlog.com';

  static final Uri home = Uri.parse(appOrigin);
  static final Uri programming = _appUri('/category/programming');
  static final Uri university = _appUri('/category/university');
  static final Uri travel = _appUri('/category/travel');
  static final Uri blog = _appUri('/category/blog');
  static final Uri keyword = _appUri('/keyword');
  static final Uri profile = _appUri('/profile');
  static final Uri privacy = _appUri('/privacy');
  static final Uri disclaimer = _appUri('/disclaimer');
  static final Uri copyright = _appUri('/copyright');
  static final Uri link = _appUri('/link');
  static final Uri contact = _appUri('/contact');

  static Uri search(String query) {
    return _appUri('/search').replace(queryParameters: {'q': query});
  }

  static bool isAppUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.host == home.host;
  }

  static bool isArticleUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.host == home.host &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'article';
  }

  static bool isPaginationUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host != home.host) {
      return false;
    }

    final pathSegments =
        uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
    return pathSegments.length == 2 && pathSegments.first == 'p';
  }

  static bool isSearchDestinationUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host != home.host || uri.pathSegments.isEmpty) {
      return false;
    }

    final firstSegment = uri.pathSegments.first;
    return firstSegment == 'tag' ||
        firstSegment == 'archive' ||
        firstSegment == 'search';
  }

  static String toPublicUrl(String appUrl) {
    if (appUrl == appOrigin) {
      return publicOrigin;
    }

    return appUrl.replaceFirst('$appOrigin/', '$publicOrigin/');
  }

  static Uri _appUri(String path) => Uri.parse('$appOrigin$path');
}
