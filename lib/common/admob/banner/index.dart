import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../util/invalid_admob/index.dart';

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;

  const BannerAdWidget({Key? key, required this.adUnitId}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  AdSize? _adSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await AdClickManager.shouldHideAd()) {
        _createBannerAd();
      }
    });
  }

  void _createBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.toInt());

    if (adSize == null) {
      print('Failed to get adaptive banner size');
      return;
    }

    setState(() {
      _adSize = adSize;
    });

    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: adSize,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdClicked: (_) {
          AdClickManager.incrementClickCount();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
          Future.delayed(Duration(seconds: 5), () {
            _createBannerAd();
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null && _adSize != null
        ? Container(
            color: Colors.white,
            width: _adSize!.width.toDouble(),
            height: _adSize!.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : SizedBox(
            width: _adSize?.width.toDouble() ?? AdSize.banner.width.toDouble(),
            height:
                _adSize?.height.toDouble() ?? AdSize.banner.height.toDouble(),
          );
  }
}
