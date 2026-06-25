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
      expect(AppUrls.isFixedPageUrl('https://realunivlog.com/profile'), isTrue);
      expect(AppUrls.isFixedPageUrl('https://realunivlog.com/contact'), isTrue);
      expect(
        AppUrls.isSearchDestinationUrl('https://realunivlog.com/search?q=test'),
        isTrue,
      );
      expect(
        AppUrls.isSearchTopUrl('https://realunivlog.com/search?app=1'),
        isTrue,
      );
      expect(
        AppUrls.isSearchDestinationUrl('https://realunivlog.com/tag/flutter'),
        isTrue,
      );
      expect(
        AppUrls.isSearchDestinationUrl(
          'https://realunivlog.com/archive/2026/05',
        ),
        isTrue,
      );
    });

    test('does not detect unrelated paths as fixed pages', () {
      expect(
        AppUrls.isFixedPageUrl('https://realunivlog.com/articles/sample'),
        isFalse,
      );
      expect(
        AppUrls.isFixedPageUrl('https://realunivlog.com/category/blog'),
        isFalse,
      );
    });

    test('does not detect unrelated paths as search destinations', () {
      expect(
        AppUrls.isSearchDestinationUrl(
          'https://realunivlog.com/articles/sample',
        ),
        isFalse,
      );
      expect(
        AppUrls.isSearchDestinationUrl('https://realunivlog.com/category/blog'),
        isFalse,
      );
      expect(
        AppUrls.isSearchTopUrl('https://realunivlog.com/search?q=test&app=1'),
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
