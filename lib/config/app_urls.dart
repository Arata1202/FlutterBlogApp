class AppUrls {
  static const publicOrigin = 'https://realunivlog.com';
  static const appOrigin = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: publicOrigin,
  );
  static const _appModeParameter = 'app';
  static const _appModeValue = '1';

  static final Uri home = _appUri('/');
  static final Uri programming = _appUri('/category/programming');
  static final Uri university = _appUri('/category/university');
  static final Uri work = _appUri('/category/work');
  static final Uri leisure = _appUri('/category/leisure');
  static final Uri travel = _appUri('/category/travel');
  static final Uri blog = _appUri('/category/blog');
  static final Uri searchTop = _appUri('/search');
  static final Uri profile = _appUri('/profile');
  static final Uri privacy = _appUri('/privacy');
  static final Uri disclaimer = _appUri('/disclaimer');
  static final Uri copyright = _appUri('/copyright');
  static final Uri link = _appUri('/link');
  static final Uri contact = _appUri('/contact');

  static Uri search(String query) {
    return _appUri('/search', queryParameters: {'q': query});
  }

  static bool isAppUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return false;
    }

    final appUri = Uri.parse(appOrigin);

    return uri.scheme == appUri.scheme &&
        uri.host == appUri.host &&
        uri.port == appUri.port;
  }

  static bool isArticleUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        isAppUrl(url) &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.first == 'articles';
  }

  static bool isPaginationUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !isAppUrl(url)) {
      return false;
    }

    final pathSegments =
        uri.pathSegments.where((segment) => segment.isNotEmpty).toList();
    if (pathSegments.length < 2 ||
        pathSegments[pathSegments.length - 2] != 'p') {
      return false;
    }

    return int.tryParse(pathSegments.last) != null;
  }

  static bool isSearchDestinationUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !isAppUrl(url) || uri.pathSegments.isEmpty) {
      return false;
    }

    final firstSegment = uri.pathSegments.first;
    return firstSegment == 'category' ||
        firstSegment == 'tag' ||
        firstSegment == 'archive' ||
        firstSegment == 'search';
  }

  static Uri withAppMode(Uri uri) {
    if (!isAppUrl(uri.toString())) {
      return uri;
    }

    final queryParameters = Map<String, String>.from(uri.queryParameters);
    queryParameters[_appModeParameter] = _appModeValue;

    return uri.replace(queryParameters: queryParameters);
  }

  static String toAppUrlString(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return url;
    }

    return withAppMode(uri).toString();
  }

  static String toPublicUrl(String appUrl) {
    final uri = Uri.tryParse(appUrl);
    if (uri == null || !isAppUrl(appUrl)) {
      return appUrl;
    }

    final queryParameters = Map<String, String>.from(uri.queryParameters)
      ..remove(_appModeParameter);
    final publicUri = Uri.parse(publicOrigin);
    final publicUrl =
        queryParameters.isEmpty
            ? uri.replace(
              scheme: publicUri.scheme,
              host: publicUri.host,
              port: publicUri.hasPort ? publicUri.port : null,
              query: '',
            )
            : uri.replace(
              scheme: publicUri.scheme,
              host: publicUri.host,
              port: publicUri.hasPort ? publicUri.port : null,
              queryParameters: queryParameters,
            );

    if (queryParameters.isEmpty) {
      return publicUrl.toString().replaceFirstMapped(
        RegExp(r'\?(#|$)'),
        (match) => match.group(1) ?? '',
      );
    }

    return publicUrl.toString();
  }

  static Uri _appUri(String path, {Map<String, String>? queryParameters}) {
    final uri = Uri.parse('$appOrigin$path');
    return withAppMode(uri.replace(queryParameters: queryParameters));
  }
}
