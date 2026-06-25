import 'package:flutter_test/flutter_test.dart';
import 'package:flutterblogapp/config/app_urls.dart';

void main() {
  group('AppUrls', () {
    test('builds encoded search URLs', () {
      final url = AppUrls.search('大学 旅行');

      expect(url.host, 'realunivlog.com');
      expect(url.path, '/search');
      expect(url.queryParameters['q'], '大学 旅行');
      expect(url.queryParameters['app'], '1');
    });

    test('detects app-owned URLs by host', () {
      expect(AppUrls.isAppUrl('https://realunivlog.com'), isTrue);
      expect(AppUrls.isAppUrl('https://realunivlog.com/articles/test'), isTrue);
      expect(AppUrls.isAppUrl('https://example.com/realunivlog.com'), isFalse);
    });

    test('detects app navigation destinations', () {
      expect(
        AppUrls.isArticleUrl('https://realunivlog.com/articles/sample'),
        isTrue,
      );
      expect(AppUrls.isPaginationUrl('https://realunivlog.com/p/2'), isTrue);
      expect(
        AppUrls.isPaginationUrl('https://realunivlog.com/category/blog/p/2/'),
        isTrue,
      );
      expect(
        AppUrls.isSearchDestinationUrl('https://realunivlog.com/tag/flutter'),
        isTrue,
      );
    });

    test('does not detect unrelated paths as pagination', () {
      expect(
        AppUrls.isPaginationUrl('https://realunivlog.com/help/p'),
        isFalse,
      );
      expect(
        AppUrls.isPaginationUrl('https://realunivlog.com/articles/p/sample'),
        isFalse,
      );
    });

    test('adds app mode to internal URLs', () {
      final url = AppUrls.toAppUrlString(
        'https://realunivlog.com/articles/sample?utm_source=x',
      );

      expect(url, 'https://realunivlog.com/articles/sample?utm_source=x&app=1');
    });

    test('converts app URLs to public URLs for sharing', () {
      expect(
        AppUrls.toPublicUrl('https://realunivlog.com/articles/sample?app=1'),
        'https://realunivlog.com/articles/sample',
      );
      expect(
        AppUrls.toPublicUrl(
          'https://realunivlog.com/articles/sample?utm_source=x&app=1',
        ),
        'https://realunivlog.com/articles/sample?utm_source=x',
      );
    });
  });
}
