import 'package:flutter_test/flutter_test.dart';
import 'package:flutterblogapp/config/app_urls.dart';

void main() {
  group('AppUrls', () {
    test('builds encoded search URLs', () {
      final url = AppUrls.search('大学 旅行');

      expect(url.host, 'web-view-blog-app.vercel.app');
      expect(url.path, '/search');
      expect(url.queryParameters['q'], '大学 旅行');
    });

    test('detects app-owned URLs by host', () {
      expect(AppUrls.isAppUrl('https://web-view-blog-app.vercel.app'), isTrue);
      expect(
        AppUrls.isAppUrl('https://web-view-blog-app.vercel.app/article/test'),
        isTrue,
      );
      expect(
        AppUrls.isAppUrl('https://example.com/web-view-blog-app.vercel.app'),
        isFalse,
      );
    });

    test('detects app navigation destinations', () {
      expect(
        AppUrls.isArticleUrl(
          'https://web-view-blog-app.vercel.app/article/sample',
        ),
        isTrue,
      );
      expect(
        AppUrls.isPaginationUrl('https://web-view-blog-app.vercel.app/p/2'),
        isTrue,
      );
      expect(
        AppUrls.isSearchDestinationUrl(
          'https://web-view-blog-app.vercel.app/tag/flutter',
        ),
        isTrue,
      );
    });

    test('converts app URLs to public URLs for sharing', () {
      expect(
        AppUrls.toPublicUrl(
          'https://web-view-blog-app.vercel.app/article/sample',
        ),
        'https://realunivlog.com/article/sample',
      );
    });
  });
}
