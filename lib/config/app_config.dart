class AppConfig {
  static const oneSignalAppId = String.fromEnvironment('ONESIGNAL_APP_ID');
  static const isAdMobEnabled = bool.fromEnvironment(
    'ADMOB_ENABLED',
    defaultValue: true,
  );
  static const iosBannerAdUnitId = String.fromEnvironment(
    'ADMOB_IOS_BANNER_AD_UNIT_ID',
  );
  static const debugForceUpdate = bool.fromEnvironment(
    'REMOTE_CONFIG_DEBUG_FORCE_UPDATE',
    defaultValue: false,
  );
  static const debugMaintenanceMode = bool.fromEnvironment(
    'REMOTE_CONFIG_DEBUG_MAINTENANCE_MODE',
    defaultValue: false,
  );
}
