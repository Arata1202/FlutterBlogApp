import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../config/app_config.dart';
import '../../../util/platform/index.dart';

enum _BannerAdLoadStatus { idle, loading, failed }

class AppBannerAd extends StatefulWidget {
  const AppBannerAd({super.key});

  @override
  State<AppBannerAd> createState() => _AppBannerAdState();
}

class _AppBannerAdState extends State<AppBannerAd> {
  BannerAd? _bannerAd;
  AdSize? _adSize;
  int? _loadedWidth;
  int? _failedWidth;
  _BannerAdLoadStatus _loadStatus = _BannerAdLoadStatus.idle;

  bool get _shouldShowAd {
    return AppPlatform.isIOS &&
        AppConfig.isAdMobEnabled &&
        AppConfig.iosBannerAdUnitId.isNotEmpty;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadAd(int width) async {
    if (!_canLoadAd(width)) {
      return;
    }

    setState(() {
      _loadStatus = _BannerAdLoadStatus.loading;
    });

    BannerAd? pendingAd;
    try {
      final adSize =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
      if (!mounted) {
        return;
      }

      if (adSize == null) {
        _markLoadFailed(width);
        return;
      }

      final bannerAd = BannerAd(
        adUnitId: AppConfig.iosBannerAdUnitId,
        size: adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            pendingAd = null;
            if (!mounted) {
              ad.dispose();
              return;
            }

            _bannerAd?.dispose();
            setState(() {
              _bannerAd = ad as BannerAd;
              _adSize = adSize;
              _loadedWidth = width;
              _failedWidth = null;
              _loadStatus = _BannerAdLoadStatus.idle;
            });
          },
          onAdFailedToLoad: (ad, error) {
            pendingAd = null;
            ad.dispose();
            if (!mounted) {
              return;
            }

            _reportLoadError(error);
            _markLoadFailed(width);
          },
        ),
      );
      pendingAd = bannerAd;

      await bannerAd.load();
    } catch (error, stackTrace) {
      pendingAd?.dispose();
      if (!mounted) {
        return;
      }

      _reportLoadError(error, stackTrace);
      _markLoadFailed(width);
    }
  }

  bool _canLoadAd(int width) {
    return _shouldShowAd &&
        width > 0 &&
        _loadStatus != _BannerAdLoadStatus.loading &&
        _failedWidth != width &&
        _loadedWidth != width;
  }

  void _markLoadFailed(int width) {
    setState(() {
      _bannerAd = null;
      _adSize = null;
      _loadedWidth = null;
      _failedWidth = width;
      _loadStatus = _BannerAdLoadStatus.failed;
    });
  }

  void _reportLoadError(Object error, [StackTrace? stackTrace]) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'FlutterBlogApp',
        context: ErrorDescription('Banner ad failed to load'),
      ),
    );
  }

  void _scheduleLoadIfNeeded(int width) {
    if (!_canLoadAd(width)) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadAd(width);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowAd) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            (constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : MediaQuery.sizeOf(context).width)
                .truncate();

        _scheduleLoadIfNeeded(width);

        final loadedAd = _bannerAd;
        final loadedAdSize = _adSize;
        if (loadedAd != null && loadedAdSize != null) {
          return _LoadedBannerAd(ad: loadedAd, adSize: loadedAdSize);
        }

        if (_loadStatus == _BannerAdLoadStatus.failed) {
          return const SizedBox.shrink();
        }

        return const _BannerAdPlaceholder();
      },
    );
  }
}

class _LoadedBannerAd extends StatelessWidget {
  const _LoadedBannerAd({required this.ad, required this.adSize});

  final BannerAd ad;
  final AdSize adSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          height: adSize.height.toDouble(),
          child: Center(
            child: SizedBox(
              width: adSize.width.toDouble(),
              height: adSize.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerAdPlaceholder extends StatelessWidget {
  const _BannerAdPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: AdSize.banner.height.toDouble(),
      ),
    );
  }
}
