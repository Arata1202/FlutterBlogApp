import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  void loadInterstitialAd(String adUnitId, Function onAdLoaded) {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd?.setImmersiveMode(true);
          onAdLoaded();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_isInterstitialAdReady) {
      await _interstitialAd?.show();
    } else {
      print('Interstitial ad is not ready yet');
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
