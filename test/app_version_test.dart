import 'package:flutter_test/flutter_test.dart';
import 'package:flutterblogapp/config/app_version.dart';

void main() {
  group('AppVersion', () {
    test('requires update when latest version is newer', () {
      expect(
        AppVersion.isUpdateRequired(
          currentVersion: '1.4.11',
          latestVersion: '1.5.0',
        ),
        isTrue,
      );
    });

    test('does not require update when current version is newer or equal', () {
      expect(
        AppVersion.isUpdateRequired(
          currentVersion: '1.4.11',
          latestVersion: '1.4.11',
        ),
        isFalse,
      );
      expect(
        AppVersion.isUpdateRequired(
          currentVersion: '1.4.12',
          latestVersion: '1.4.11',
        ),
        isFalse,
      );
    });

    test('normalizes missing patch parts and build metadata', () {
      expect(
        AppVersion.isUpdateRequired(
          currentVersion: '1.4+2',
          latestVersion: '1.4.1',
        ),
        isTrue,
      );
      expect(
        AppVersion.isUpdateRequired(
          currentVersion: '1.4.1+2',
          latestVersion: '1.4.1',
        ),
        isFalse,
      );
    });

    test('does not block startup when remote version is invalid', () {
      expect(
        AppVersion.isUpdateRequired(
          currentVersion: '1.4.11',
          latestVersion: '',
        ),
        isFalse,
      );
      expect(
        AppVersion.isUpdateRequired(
          currentVersion: '1.4.11',
          latestVersion: 'not-a-version',
        ),
        isFalse,
      );
    });
  });
}
