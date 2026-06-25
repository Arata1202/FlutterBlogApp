class AppConfig {
  static const oneSignalAppId = String.fromEnvironment('ONESIGNAL_APP_ID');
  static const isAdMobEnabled = bool.fromEnvironment(
    'ADMOB_ENABLED',
    defaultValue: true,
  );
  static const iosBannerAdUnitId = String.fromEnvironment(
    'ADMOB_IOS_BANNER_AD_UNIT_ID',
  );
}
